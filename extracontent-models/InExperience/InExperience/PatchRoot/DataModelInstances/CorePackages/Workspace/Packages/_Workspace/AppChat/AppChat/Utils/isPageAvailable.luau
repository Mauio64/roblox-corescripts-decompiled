local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local isPlacementInExperience = require(AppChat.Contexts.ChatPlacementContext).isPlacementInExperience
local t1 = {
	[EnumScreens.AddFriends] = true,
	[EnumScreens.PrivacySettings] = true,
	[EnumScreens.GameDetail] = true,
	[EnumScreens.ViewUserProfile] = true,
	[EnumScreens.Groups] = true
}

return function(s1: string, p1) -- line: 15
	-- upvalues: isPlacementInExperience (copy), t1 (copy)
	if isPlacementInExperience(p1) and t1[s1] then
		return false
	end

	return true
end
