local CorePackages = game:GetService("CorePackages")
local FFlagAXMoveCatalogFilterToL1Navigation = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMoveCatalogFilterToL1Navigation

game:DefineFastFlag("AXEnableCategoryPills9", false)

return function() -- line: 7
	-- upvalues: FFlagAXMoveCatalogFilterToL1Navigation (copy)
	return FFlagAXMoveCatalogFilterToL1Navigation and game:GetFastFlag("AXEnableCategoryPills9")
end
