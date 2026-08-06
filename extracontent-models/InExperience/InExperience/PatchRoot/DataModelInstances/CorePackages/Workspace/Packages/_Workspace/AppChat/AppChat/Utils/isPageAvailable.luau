local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local isPlacementInExperience = require(AppChat.Contexts.ChatPlacementContext).isPlacementInExperience
local FFlagAppChatOnConsoles = require(AppChatParent.SharedFlags).FFlagAppChatOnConsoles
local t1 = {
	[EnumScreens.AddFriends] = true,
	[EnumScreens.PrivacySettings] = true,
	[EnumScreens.GameDetail] = true,
	[EnumScreens.ViewUserProfile] = true,
	[EnumScreens.Groups] = true
}
local t2 = {
	[EnumScreens.Groups] = true
}

return function(s1: string, p1, b1: boolean?) -- line: 22
	-- upvalues: isPlacementInExperience (copy), t1 (copy), FFlagAppChatOnConsoles (copy), t2 (copy)
	if isPlacementInExperience(p1) and t1[s1] then
		return false
	end

	if FFlagAppChatOnConsoles and b1 == false and t2[s1] then
		return false
	end

	return true
end
