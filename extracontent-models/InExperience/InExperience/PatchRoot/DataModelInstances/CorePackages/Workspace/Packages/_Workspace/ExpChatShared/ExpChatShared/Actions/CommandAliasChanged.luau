local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(name: string, primaryAlias: string, secondaryAlias: string)
	return { name = name, primaryAlias = primaryAlias, secondaryAlias = secondaryAlias }
end)
