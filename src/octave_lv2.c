/* Streaming phase-vocoder pitch shifter. All storage is allocated before run(). */
#include <lv2/core/lv2.h>
#include <math.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define N 1024
#define HOP 256
#define LATENCY (N - HOP)
#define PI 3.14159265358979323846

typedef struct {
    float input[N], output[HOP], overlap[N], window[N];
    double real[N], imag[N], last_phase[N/2+1], sum_phase[N/2+1];
    double magnitude[N/2+1], frequency[N/2+1];
    size_t position;
} PitchDSP;

typedef struct {
    const float *pitch, *input;
    float *output, *latency;
    PitchDSP dsp;
} Octave;

static void fft(double *real, double *imag, int inverse)
{
    for(unsigned i = 1, j = 0; i < N; ++i) {
        unsigned bit = N >> 1;
        for(; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if(i < j) {
            double t = real[i]; real[i] = real[j]; real[j] = t;
            t = imag[i]; imag[i] = imag[j]; imag[j] = t;
        }
    }
    for(unsigned length = 2; length <= N; length <<= 1) {
        double angle = (inverse ? 2 : -2) * PI / length;
        double step_r = cos(angle), step_i = sin(angle);
        for(unsigned start = 0; start < N; start += length) {
            double wr = 1, wi = 0;
            for(unsigned j = 0; j < length/2; ++j) {
                unsigned a = start+j, b = a+length/2;
                double tr = wr*real[b] - wi*imag[b];
                double ti = wr*imag[b] + wi*real[b];
                real[b] = real[a]-tr; imag[b] = imag[a]-ti;
                real[a] += tr; imag[a] += ti;
                double next = wr*step_r-wi*step_i;
                wi = wr*step_i+wi*step_r; wr = next;
            }
        }
    }
    if(inverse) for(unsigned i = 0; i < N; ++i) { real[i] /= N; imag[i] /= N; }
}

static void transform(PitchDSP *dsp, double ratio)
{
    for(unsigned i = 0; i < N; ++i) {
        dsp->real[i] = dsp->input[i]*dsp->window[i];
        dsp->imag[i] = 0;
    }
    fft(dsp->real, dsp->imag, 0);
    memset(dsp->magnitude, 0, sizeof(dsp->magnitude));
    memset(dsp->frequency, 0, sizeof(dsp->frequency));
    for(unsigned bin = 0; bin <= N/2; ++bin) {
        double magnitude = hypot(dsp->real[bin], dsp->imag[bin]);
        double phase = atan2(dsp->imag[bin], dsp->real[bin]);
        double delta = phase-dsp->last_phase[bin]-2*PI*bin*HOP/N;
        dsp->last_phase[bin] = phase;
        delta -= 2*PI*round(delta/(2*PI));
        double frequency = (bin+delta*N/(2*PI*HOP))*ratio;
        unsigned target = (unsigned)lround(bin*ratio);
        if(target <= N/2 && frequency >= 0 && frequency <= N/2) {
            dsp->magnitude[target] += magnitude;
            dsp->frequency[target] += magnitude*frequency;
        }
    }
    memset(dsp->real, 0, sizeof(dsp->real));
    memset(dsp->imag, 0, sizeof(dsp->imag));
    for(unsigned bin = 0; bin <= N/2; ++bin) {
        double magnitude = dsp->magnitude[bin];
        if(magnitude > 1e-12)
            dsp->sum_phase[bin] += 2*PI*HOP*dsp->frequency[bin]/(N*magnitude);
        dsp->sum_phase[bin] = remainder(dsp->sum_phase[bin], 2*PI);
        dsp->real[bin] = magnitude*cos(dsp->sum_phase[bin]);
        dsp->imag[bin] = magnitude*sin(dsp->sum_phase[bin]);
        if(bin > 0 && bin < N/2) {
            dsp->real[N-bin] = dsp->real[bin];
            dsp->imag[N-bin] = -dsp->imag[bin];
        }
    }
    dsp->imag[0] = dsp->imag[N/2] = 0;
    fft(dsp->real, dsp->imag, 1);
    for(unsigned i = 0; i < N; ++i)
        dsp->overlap[i] += (float)(dsp->real[i]*dsp->window[i]*(2.0/3.0));
    memcpy(dsp->output, dsp->overlap, sizeof(dsp->output));
    memmove(dsp->overlap, dsp->overlap+HOP, LATENCY*sizeof(float));
    memset(dsp->overlap+LATENCY, 0, HOP*sizeof(float));
    memmove(dsp->input, dsp->input+HOP, LATENCY*sizeof(float));
}

static void activate(LV2_Handle handle)
{
    Octave *octave = handle;
    memset(&octave->dsp, 0, sizeof(octave->dsp));
    octave->dsp.position = LATENCY;
    for(unsigned i = 0; i < N; ++i)
        octave->dsp.window[i] = (float)(.5-.5*cos(2*PI*i/N));
}

static LV2_Handle instantiate(const LV2_Descriptor *descriptor, double rate,
                              const char *path, const LV2_Feature *const *features)
{
    (void)descriptor; (void)rate; (void)path; (void)features;
    Octave *octave = calloc(1, sizeof(*octave));
    if(octave) activate(octave);
    return octave;
}

static void connect_port(LV2_Handle handle, uint32_t port, void *data)
{
    Octave *octave = handle;
    if(port == 0) octave->pitch = data;
    if(port == 1) octave->input = data;
    if(port == 2) octave->output = data;
    if(port == 3) octave->latency = data;
}

static void run(LV2_Handle handle, uint32_t count)
{
    Octave *octave = handle;
    PitchDSP *dsp = &octave->dsp;
    double ratio = octave->pitch ? *octave->pitch : .5;
    if(!isfinite(ratio)) ratio = 1;
    ratio = fmin(2, fmax(.5, ratio));
    if(octave->latency) *octave->latency = LATENCY;
    for(uint32_t i = 0; i < count; ++i) {
        float input = octave->input[i];
        dsp->input[dsp->position] = isfinite(input) ? input : 0;
        octave->output[i] = dsp->output[dsp->position-LATENCY];
        if(++dsp->position == N) {
            transform(dsp, ratio);
            dsp->position = LATENCY;
        }
    }
}

static void cleanup(LV2_Handle handle) { free(handle); }
static const LV2_Descriptor descriptor = {
    "urn:pipedal:octave", instantiate, connect_port, activate, run, NULL, cleanup, NULL
};

LV2_SYMBOL_EXPORT const LV2_Descriptor *lv2_descriptor(uint32_t index)
{
    return index == 0 ? &descriptor : NULL;
}
