return require("@luauforge/bundled/dqu").makeActionCreator("SetHomePageDataStatus", function(value)
	assert(
		type(value) == "string",
		string.format("SetHomePageDataStatus action expects status to be an string, was %s", (type(value)))
	)

	return { status = value }
end)
