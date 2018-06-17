# Tiler

Learning Git / Github

Starting fresh with a modular tile method
2018-05-28:	setting up to develop tile system modularity
2018-05-29:	trying out class and inheritance... success with classes, no inheritance...
2018-05-30:	adding symmetry arrays to read through during cluster building. moved symmetries to their own tab. done
2018-05-30:	make a trivial TileSystem class, because. done
2018-05-30:	resolved TileSystem render, included basic tile switching
2018-05-30:	working on tile image updating... maybe I need two different tiles?
2018-05-31:	making Tile class use an ArrayList to hold historical tile states (in answer to above question) Done
2018-05-31:	can I use . syntax better? no.
2018-05-31:	Adding tile animation and switching to regular array (of 30) rather than ArrayList
			Part way there...
			Need to fix Symmetry stepping routines
2018-06-14:	Done. Created Tiling[][] variable to describe stepping and offsets, scalable. 
2018-06-14:	Done. Putting TileGenerator inside TileSystem, add multiple TileSystems to see interference
---- 
2018-06-14:	Attempting to build the Tile System better, with one Tile object and lots of metadtata used in displaying the field.
			- Done. combine Tile and TileGrenerator into one class (its own tab)
			- Done. use cluster and tiling math to fill the data array in TileSystem
			- Done. make TileSystem.display() function
			- later. (detect changed tiles?)
2018-06-15:	Done. Tidying up the above steps.
----
2018-06-15:	Done. Tile History Basics: make the tiles' history state proportional to distance from center.
2018-06-15:	Done. Fixed centering calculation for tile field.
2018-06-15: Done. Make tile locations and drawing relative to center of tile.
----
2018-06-15: Done. Add screen XY awareness to Cell class.
----
2018-06-17: Branch - On-Screen awareness
			Done - Change Cell class to TileData class (name change only) (also cellArray to TileArray)
			Done - Add isOnScreen boolean to TileData
			Done - Figure out how to calculate that
			Done - Add toggle to render all tiles or only those on screen, look at CPU savings
----
2018-06-17: Branch - Video Mask
			Done - Add a mask to the whole screen
