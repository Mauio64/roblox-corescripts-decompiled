return require("@luauforge/bundled/dqu").makeActionCreator("SetGamesPageDataStatus", function(value, p2)
	assert(
		type(value) == "string",
		string.format("SetGamesPageDataStatus action expects status to be a string, was %s", (type(value)))
	)

	return { status = value, isRefreshFetch = p2 }
end)
