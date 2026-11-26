local FFlagAXRootRFYMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXRootRFYMigration")
local FFlagAXMoveAllTabToWidgetOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXMoveAllTabToWidgetOnly")

return FFlagAXRootRFYMigration and FFlagAXMoveAllTabToWidgetOnly and game:DefineFastFlag("AXFixWidgetOnlyTabNoItemsFound", false)
