local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return { collectibleItemData = p.collectibleItemData }
end)
