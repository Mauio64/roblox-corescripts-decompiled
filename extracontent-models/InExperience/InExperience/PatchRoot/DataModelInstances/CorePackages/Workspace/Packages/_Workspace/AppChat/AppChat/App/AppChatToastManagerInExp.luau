local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatToastEventReceiver = require(AppChat.Components.EventReceivers.AppChatToastEventReceiver)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local ExpChatShared = require(parent.ExpChatShared)
local FriendsSurfaceVisibility = ExpChatShared.FriendsSurfaceVisibility

local v = { hideAllChatToasts = false, isAppChatVisible = false }

function AppChatToastManagerInExp(p)
	local joined = Cryo.Dictionary.join(v, p)
	local visibleFriendsConversationId

	if FFlagExpChatEnableFriendsTab then
		visibleFriendsConversationId = SignalsReact.useSignalState(FriendsSurfaceVisibility.getVisibleConversationId)
	end

	local navigateToChat = React.useCallback(function(p2: string)
		joined.navigateToChat(p2)
	end, { joined.navigateToChat })

	local createElement = React.createElement
	local hideAllChatToasts

	if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		hideAllChatToasts = joined.hideAllChatToasts
	end

	local isAppChatVisible

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		isAppChatVisible = joined.isAppChatVisible
	end

	return createElement(AppChatToastEventReceiver, {
		navigateToChat = navigateToChat,
		hideAllChatToasts = hideAllChatToasts,
		isAppChatVisible = isAppChatVisible,
		isInExperience = true,
		visibleFriendsConversationId = visibleFriendsConversationId
	})
end

return AppChatToastManagerInExp
