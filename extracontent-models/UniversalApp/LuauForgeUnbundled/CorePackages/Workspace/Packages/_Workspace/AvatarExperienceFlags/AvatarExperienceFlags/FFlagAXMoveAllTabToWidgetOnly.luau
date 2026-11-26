local FFlagAXRootRFYMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXRootRFYMigration")
local FFlagAXPassScreenSizeToWidgetApi = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXPassScreenSizeToWidgetApi")

return FFlagAXRootRFYMigration and FFlagAXPassScreenSizeToWidgetApi and game:DefineFastFlag("AXMoveAllTabToWidgetOnly5", false)
