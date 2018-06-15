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
			- combine Tile and TileGrenerator into one class (its own tab)
			- use cluster and tiling math to fill the data array in TileSystem
			- make TileSystem.display() function
			- (detect changed tiles?)

