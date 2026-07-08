local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SharedFlags = require(AppChatParent.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local getFFlagHideNotificationIconForVR = require(AppChat.Flags.getFFlagHideNotificationIconForVR)
local FFlagAppChatRemoveNotifications = SharedFlags.FFlagAppChatRemoveNotifications
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector

local function useChatLandingVisibility() -- line: 24
	-- upvalues: useIsInExperience (copy), useIsChatEnabled (copy), useAppPolicy (copy), getFFlagHideNotificationIconForVR (copy), useSelector (copy), FFlagAppChatRemoveNotifications (copy), GetFFlagEnableAppChatInExperience (copy)
	local v12 = useIsInExperience()
	local v13 = useIsChatEnabled()
	local v14 = useAppPolicy(function(p1) -- line: 28
		return p1.getChatHeaderSearch()
	end)
	local v15 = useAppPolicy(function(p2) -- line: 31
		return p2.getChatHeaderCreateChatGroup()
	end)
	local v16 = useAppPolicy(function(p3) -- line: 34
		-- upvalues: getFFlagHideNotificationIconForVR (copy)
		return p3.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p3.getWebViewSupport())
	end)
	local v17 = useSelector(function(p4) -- line: 39
		local NotificationBadgeCounts = p4.NotificationBadgeCounts

		return NotificationBadgeCounts and NotificationBadgeCounts.TopBarNotificationIcon or 0
	end)
	local v18 = v14 and (not v12 and v13)
	local v19 = v15 and v13
	local v20 = not v12 and (v16 and not FFlagAppChatRemoveNotifications)
	local v21 = v12 and GetFFlagEnableAppChatInExperience()

	return {
		topBarShowSearch = v18,
		topBarShowCreateChatGroup = v19,
		topBarShowNotifications = v20,
		topBarShowSnoozeNotifications = v21,
		showSearchRow = v12,
		notificationCount = v17
	}
end

return useChatLandingVisibility
