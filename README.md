# cl-victor

This is a part of the SubText project

## Summary

CL-VICTOR is a vector data structure that efficiently encodes variable-width data into a constant narrow-width datastream.  Victors work particularly well on data such as text containing mostly ASCII but some UNICODE characters, or 8-bit instructions that sometimes must be much wider to encode an address.  Originally designed as a CPU instruction fetch mechanism by Victor Yurkovsky, it works surprisingly well on certain kinds of data. 

## A simple example: ASCII text with multibyte characters.

Victor contains two vectors: an 8-bit vector as long as the text, and a wide vector with a length that is a fixed fraction of the first one.  The fraction is often 1/16, but generally should be tuned to the ratio of wide characters in the text.

ASCII characters are simply placed into the narrow vector; for wide characters, the high bit is set and the low 7 bits represent an index into the wide array that contains the character.

The interesting part: for every narrow character position in the array, there is a 128-element window into the wide array.  The window slides around, according to the same ratio chosen above.

Even more interesting: wide characters can be reused if they happen to be already in the window.

## Limitations

- The ratio of wide/narrow characters must be known in advance and fixed (to avoid re-adjusting the data).

- Random-access writing is not generally possible


## Benefits

- Random access reading is very fast

- Approximately same space utilization as UTF-8 while retaining 1-1 character indexing

- Able to embed arbitrary Lisp objects

## Reference

The details are documented in an annoying series of articles here:
- [StrangeCPU #1: A new CPU](https://www.fpgarelated.com/showarticle/44.php)
- [StrangeCPU #2. Sliding Window Token Machines](https://www.fpgarelated.com/showarticle/45.php)
- [StrangeCPU #3. Instruction Slides - The Strangest CPU Yet!](https://www.fpgarelated.com/showarticle/46.php)
- [StrangeCPU #4. Microcode](https://www.fpgarelated.com/showarticle/49.php)

See the notes.org file here for implementation details and notes.




