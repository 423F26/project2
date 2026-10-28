#ifndef PEDAL_MIDI_H
#define PEDAL_MIDI_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define MIDI_QUEUE_CAPACITY 256

/* MIDI channel voice messages. Program change and channel pressure use data2=0.
   frame is the input-audio frame position. */
typedef struct {
    uint64_t frame;
    uint8_t status, data1, data2;
} MidiEvent;

typedef struct {
    MidiEvent events[MIDI_QUEUE_CAPACITY];
    size_t head, count;
    uint64_t dropped;
} MidiQueue;

bool midi_queue_push(MidiQueue *queue, MidiEvent event);
size_t midi_queue_drain(MidiQueue *queue, MidiEvent *events, size_t capacity);

#endif
