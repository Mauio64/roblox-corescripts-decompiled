local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(p1, p2) -- line: 4
	assert(type(p1) == "string", string.format("SetGameSocialLinks action expects universeId to be a string, was %s", (type(p1))))
	assert(type(p2) == "table", string.format("SetGameSocialLinks action expects socialLinks to be a table, was %s", (type(p2))))

	return {
		universeId = p1,
		socialLinks = p2
	}
end)
