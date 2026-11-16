local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)

local v = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return game:DefineFastFlag("AXCatalogBackgroundsSupport", false) and FFlagAXBackgroundsRoot and v
