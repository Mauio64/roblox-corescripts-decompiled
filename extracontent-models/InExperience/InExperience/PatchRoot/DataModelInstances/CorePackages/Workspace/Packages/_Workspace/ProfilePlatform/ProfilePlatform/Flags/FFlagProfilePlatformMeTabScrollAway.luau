local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags2.FFlagAXEnableProfileTab
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAppIaScopedScrollAway = SharedFlags3.FFlagAppIaScopedScrollAway

return FFlagAXEnableProfileTab
	and FFlagAppIaScopedScrollAway
	and FFlagEnableBottomNavOnMarketplace
	and game:DefineFastFlag("ProfilePlatformMeTabScrollAway", false)
