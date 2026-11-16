local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local getFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience

local module2 = require("@luauforge/bundled/gsb")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local getFFlagHideNotificationIconForVR = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagHideNotificationIconForVR")
local fFlagAppChatRemoveNotifications = SharedFlags.FFlagAppChatRemoveNotifications

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

local function useChatLandingVisibility()
	local v5 = useIsInExperience()
	local v6 = useIsChatEnabled()

	local v7 = module2(function(p2)
		return p2.getChatHeaderSearch()
	end)

	local v8 = module2(function(p2)
		return p2.getChatHeaderCreateChatGroup()
	end)

	local v9 = module2(function(p2)
		return p2.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p2.getWebViewSupport())
	end)

	local v10 = useSelector(function(p2)
		local notificationBadgeCounts = p2.NotificationBadgeCounts
		return notificationBadgeCounts and notificationBadgeCounts.TopBarNotificationIcon or 0
	end)

	return {
		topBarShowSearch = v7 and not v5 and v6,
		topBarShowCreateChatGroup = v8 and v6,
		topBarShowNotifications = not v5 and v9 and not fFlagAppChatRemoveNotifications,
		topBarShowSnoozeNotifications = v5 and getFFlagEnableAppChatInExperience(),
		showSearchRow = v5,
		notificationCount = v10
	}
end

return useChatLandingVisibility
