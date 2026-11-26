local fFlagEnableBottomNavOnMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBottomNavOnMarketplace
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local fFlagAppIaScopedScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAppIaScopedScrollAway

return fFlagAXEnableProfileTab
	and fFlagAppIaScopedScrollAway
	and fFlagEnableBottomNavOnMarketplace
	and game:DefineFastFlag("ProfilePlatformMeTabScrollAway", false)
