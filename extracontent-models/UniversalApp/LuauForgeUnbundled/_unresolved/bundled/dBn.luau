return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetGameSocialLinks", function(value, p2)
	assert(
		type(value) == "string",
		string.format("SetGameSocialLinks action expects universeId to be a string, was %s", (type(value)))
	)

	assert(
		type(p2) == "table",
		string.format("SetGameSocialLinks action expects socialLinks to be a table, was %s", (type(p2)))
	)

	return { universeId = value, socialLinks = p2 }
end)
