local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local FFlagEnableBottomNavOnMarketplace = require(Parent.SharedFlags).FFlagEnableBottomNavOnMarketplace
local FFlagAXEnableProfileTab = require(Parent.SharedFlags).FFlagAXEnableProfileTab
local FFlagAppIaScopedScrollAway = require(Parent.SharedFlags).FFlagAppIaScopedScrollAway

return FFlagAXEnableProfileTab and (FFlagAppIaScopedScrollAway and (FFlagEnableBottomNavOnMarketplace and game:DefineFastFlag("ProfilePlatformMeTabScrollAway", false)))
