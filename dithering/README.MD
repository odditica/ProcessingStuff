## Basic Ordered Dithering Demo (27/01/2018)

Real-time dithering, uses the PICO-8 palette. 

Please note that the fragment shader uses linear search for colour lookup. This is rather ineffective (albeit not noticeably, since the palette consists of only 16 colours), unlike a simple LUT lookup. The reason my solution doesn't utilise a LUT is due to the fact that I simply did not have the time to figure out the process of generating one.  

![](https://github.com/Blokatt/ProcessingStuff/blob/master/dithering/small.gif)
