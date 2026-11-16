local AppChatToastEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatToastEventReceiver")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local getFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local friendsSurfaceVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ExpChatShared").FriendsSurfaceVisibility

local v5 = { hideAllChatToasts = false, isAppChatVisible = false }

function LUAUFORGE_MODULE_GLOBALS_ijW_AppChatToastManagerInExp(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6

	if fFlagExpChatEnableFriendsTab then
		v6 = SignalsReact.useSignalState(friendsSurfaceVisibility.getVisibleConversationId)
	end

	local v7 = React.useCallback(function(p3)
		joined.navigateToChat(p3)
	end, { joined.navigateToChat })

	local createElement = React.createElement

	local v10 = if not getFFlagAppChatInExpToastSnoozeMenuDismissFix() then joined.hideAllChatToasts else nil
	local v11 = if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then joined.isAppChatVisible else nil
	return createElement(AppChatToastEventReceiver, {
		navigateToChat = v7,
		hideAllChatToasts = v10,
		isAppChatVisible = v11,
		isInExperience = true,
		visibleFriendsConversationId = v6
	})
end

return LUAUFORGE_MODULE_GLOBALS_ijW_AppChatToastManagerInExp
