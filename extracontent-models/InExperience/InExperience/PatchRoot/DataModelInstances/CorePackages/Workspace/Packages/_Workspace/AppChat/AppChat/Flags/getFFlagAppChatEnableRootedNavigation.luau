local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local getFFlagAppChatRequestedRoute = require(AppChat.Flags.getFFlagAppChatRequestedRoute)

game:DefineFastFlag("AppChatEnableRootedNavigation2", false)

return function() -- line: 9
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), getFFlagAppChatRequestedRoute (copy)
	return game:GetFastFlag("AppChatEnableRootedNavigation2") and (FFlagExpChatEnableFriendsTab and getFFlagAppChatRequestedRoute())
end
