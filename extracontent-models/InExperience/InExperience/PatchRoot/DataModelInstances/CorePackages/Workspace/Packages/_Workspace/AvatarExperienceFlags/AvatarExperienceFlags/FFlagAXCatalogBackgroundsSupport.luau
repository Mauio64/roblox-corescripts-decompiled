local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local ok = pcall(function() -- line: 3
	return Enum.AvatarAssetType.AvatarBackground
end)

return game:DefineFastFlag("AXCatalogBackgroundsSupportDev", false) and (FFlagAXBackgroundsRoot and ok)
