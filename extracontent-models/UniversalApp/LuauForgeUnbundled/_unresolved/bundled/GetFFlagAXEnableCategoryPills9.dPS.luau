local fFlagAXMoveCatalogFilterToL1Navigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveCatalogFilterToL1Navigation

game:DefineFastFlag("AXEnableCategoryPills9", false)

return function()
	return fFlagAXMoveCatalogFilterToL1Navigation and game:GetFastFlag("AXEnableCategoryPills9")
end
