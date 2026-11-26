local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local isPlacementInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").isPlacementInExperience
local fFlagAppChatOnConsoles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatOnConsoles
local FFlagAppChatHidePrivacySettingsWithoutWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatHidePrivacySettingsWithoutWebView")

local set = {
	[EnumScreens.AddFriends] = true,
	[EnumScreens.PrivacySettings] = true,
	[EnumScreens.GameDetail] = true,
	[EnumScreens.ViewUserProfile] = true,
	[EnumScreens.Groups] = true
}

local v5 = { [EnumScreens.Groups] = true, [EnumScreens.PrivacySettings] = FFlagAppChatHidePrivacySettingsWithoutWebView }

return function(p2, p3, p4): boolean
	if isPlacementInExperience(p3) and set[p2] or fFlagAppChatOnConsoles and p4 == false and v5[p2] then
		return false
	end

	return true
end
