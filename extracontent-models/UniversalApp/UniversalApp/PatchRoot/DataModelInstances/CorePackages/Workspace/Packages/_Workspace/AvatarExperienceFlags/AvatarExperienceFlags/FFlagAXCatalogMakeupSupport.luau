local FFlagAXCustomizeMakeupSupport = require(script.Parent.FFlagAXCustomizeMakeupSupport)

return pcall(function() -- line: 3
	return Enum.AvatarAssetType.EyeMakeup
end) and (game:DefineFastFlag("AXCatalogMakeupSupport10", false) and FFlagAXCustomizeMakeupSupport)
