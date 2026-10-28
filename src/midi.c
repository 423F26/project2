#include "midi.h"

bool midi_queue_push(MidiQueue *queue, MidiEvent event)
{
    if(!queue || event.status < 0x80 || event.status >= 0xf0 ||
       event.data1 > 127 || event.data2 > 127 ||
       ((event.status & 0xf0) == 0xc0 && event.data2 != 0) ||
       ((event.status & 0xf0) == 0xd0 && event.data2 != 0)) return false;
    if(queue->count == MIDI_QUEUE_CAPACITY) {
        queue->head = (queue->head + 1) % MIDI_QUEUE_CAPACITY;
        queue->count--;
        queue->dropped++;
    }
    queue->events[(queue->head + queue->count) % MIDI_QUEUE_CAPACITY] = event;
    queue->count++;
    return true;
}

size_t midi_queue_drain(MidiQueue *queue, MidiEvent *events, size_t capacity)
{
    if(!queue || (!events && capacity)) return 0;
    size_t count = queue->count < capacity ? queue->count : capacity;
    for(size_t i = 0; i < count; ++i)
        events[i] = queue->events[(queue->head + i) % MIDI_QUEUE_CAPACITY];
    queue->head = (queue->head + count) % MIDI_QUEUE_CAPACITY;
    queue->count -= count;
    return count;
}
