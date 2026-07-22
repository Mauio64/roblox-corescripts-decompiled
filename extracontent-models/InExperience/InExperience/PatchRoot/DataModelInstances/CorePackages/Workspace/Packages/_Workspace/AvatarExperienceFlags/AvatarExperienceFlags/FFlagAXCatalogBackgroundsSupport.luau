local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local ok = pcall(function() -- line: 3
	return Enum.AvatarAssetType.AvatarBackground
end)

return game:DefineFastFlag("AXCatalogBackgroundsSupport", false) and (FFlagAXBackgroundsRoot and ok)
