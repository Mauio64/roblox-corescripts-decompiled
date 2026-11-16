local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatOnConsoles = SharedFlags.FFlagAppChatOnConsoles
local FFlagAppChatHidePrivacySettingsWithoutWebView = require(AppChat.Flags.FFlagAppChatHidePrivacySettingsWithoutWebView)

local set = {
	[EnumScreens.AddFriends] = true,
	[EnumScreens.PrivacySettings] = true,
	[EnumScreens.GameDetail] = true,
	[EnumScreens.ViewUserProfile] = true,
	[EnumScreens.Groups] = true
}

local v = {
	[EnumScreens.Groups] = true,
	[EnumScreens.PrivacySettings] = FFlagAppChatHidePrivacySettingsWithoutWebView
}

return function(p: string, p2, flag: boolean?): boolean
	if isPlacementInExperience(p2) and set[p] then
		return false
	end

	return not FFlagAppChatOnConsoles or flag ~= false or not v[p]
end
