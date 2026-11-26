return require("@luauforge/bundled/dBi").makeActionCreator("SetGameThumbnails", function(p2)
	assert(
		type(p2) == "table",
		string.format("SetGameThumbnails action expects thumbnailsTable to be a table, was %s", (type(p2)))
	)

	return { thumbnails = p2 }
end)
