local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience

local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local getFFlagHideNotificationIconForVR = require(AppChat.Flags.getFFlagHideNotificationIconForVR)
local FFlagAppChatRemoveNotifications = SharedFlags.FFlagAppChatRemoveNotifications

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useChatLandingVisibility()
	local showSearchRow = useIsInExperience()
	local v = useIsChatEnabled()

	local v2 = useAppPolicy(function(p)
		return p.getChatHeaderSearch()
	end)

	local v3 = useAppPolicy(function(p)
		return p.getChatHeaderCreateChatGroup()
	end)

	local v4 = useAppPolicy(function(p)
		return p.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p.getWebViewSupport())
	end)

	local notificationCount = useSelector(function(p)
		local notificationBadgeCounts = p.NotificationBadgeCounts
		return notificationBadgeCounts and notificationBadgeCounts.TopBarNotificationIcon or 0
	end)

	return {
		topBarShowSearch = v2 and not showSearchRow and v,
		topBarShowCreateChatGroup = v3 and v,
		topBarShowNotifications = not showSearchRow and v4 and not FFlagAppChatRemoveNotifications,
		topBarShowSnoozeNotifications = showSearchRow and GetFFlagEnableAppChatInExperience(),
		showSearchRow = showSearchRow,
		notificationCount = notificationCount
	}
end

return useChatLandingVisibility
