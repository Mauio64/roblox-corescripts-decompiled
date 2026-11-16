return require("@luauforge/bundled/dqu").makeActionCreator("SetFetchHomePageDataStatusAll", function(value)
	assert(
		type(value) == "string",
		string.format(
			"SetFetchHomePageDataStatusAll action expects status to be an string, was %s",
			(type(value))
		)
	)

	return { status = value }
end)
