local Parent = script:FindFirstAncestor("GameThumbnailsRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 21
	assert(type(p1) == "table", string.format("SetGameThumbnails action expects thumbnailsTable to be a table, was %s", (type(p1))))

	return {
		thumbnails = p1
	}
end)
