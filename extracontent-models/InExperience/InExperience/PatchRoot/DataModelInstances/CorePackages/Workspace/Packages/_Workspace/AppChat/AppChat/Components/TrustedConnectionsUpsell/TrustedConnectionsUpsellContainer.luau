local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local React = require(AppChatParent.React)
local TrustedContacts = require(AppChatParent.TrustedContacts)
local AppTabBarRodux = require(AppChatParent.AppTabBarRodux)
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useIsAppChatVerticallyConstrained = require(AppChat.App.Hooks.useIsAppChatVerticallyConstrained)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local SharedFlags = require(AppChatParent.SharedFlags)
local refreshConversationUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshConversationUnfilteredThreadsDetails)
local Promise = require(AppChatParent.Promise)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local SetTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat
local ConversationOverlayTelemetry = require(AppChat.Components.ChatConversation.PartialModal.ConversationOverlayTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)
local TrustedFriendsModalEntry = TrustedContacts.TrustedFriendsModalEntry
local FFlagAppChatEnableDoubleOptIn = SharedFlags.FFlagAppChatEnableDoubleOptIn
local FFlagAppChatEnableTrustedFriendEntryPoint = require(AppChat.Flags.FFlagAppChatEnableTrustedFriendEntryPoint)
local FIntUnfilteredThreadsPvDelayMs = require(AppChat.Flags.FIntUnfilteredThreadsPvDelayMs)
local t1 = {
	[ConversationOverlay.TrustedConnectionCreated] = TrustedFriendsModalEntry
}

local function v25(t2: {[any]: any}) -- line: 58
	return {
		shouldOverrideNavigation = true,
		onClosed = t2.onClosed,
		isVerticallyConstrained = t2.isVerticallyConstrained,
		userId = t2.userId
	}
end

local t3 = {
	[ConversationOverlay.TrustedConnectionCreated] = {
		component = TrustedFriendsModalEntry,
		mapProps = function(p1) -- line: 69
			return {
				shouldOverrideNavigation = true,
				isVerticallyConstrained = p1.isVerticallyConstrained,
				userId = p1.userId,
				onClosed = p1.onClosed,
				onAcknowledged = p1.onAcknowledged
			}
		end
	},
	[ConversationOverlay.AddTrustedConnectionU18] = {
		component = TrustedFriendsModalEntry,
		mapProps = v25
	},
	[ConversationOverlay.TrustedConnectionRequestU18] = {
		component = TrustedFriendsModalEntry,
		mapProps = v25
	}
}

return function(t4: {[any]: any}) -- line: 100
	-- upvalues: useGetOneToOneFriendIdFromConversationId (copy), useIsAppChatVerticallyConstrained (copy), useDispatch (copy), FFlagAppChatEnableDoubleOptIn (copy), useIsInExperience (copy), useTelemetry (copy), AppTelemetryLayer (copy), React (copy), ConversationOverlayTelemetry (copy), t3 (copy), t1 (copy), FFlagAppChatEnableTrustedFriendEntryPoint (copy), SetTabBarVisibleFromChat (copy), Promise (copy), FIntUnfilteredThreadsPvDelayMs (copy), refreshConversationUnfilteredThreadsDetails (copy), ModalTelemetry (copy)
	local v30 = useGetOneToOneFriendIdFromConversationId(t4.conversationId) or ""
	local v31 = useIsAppChatVerticallyConstrained()
	local v32 = useDispatch()
	local modalVariant = t4.modalVariant
	local v34 = if not FFlagAppChatEnableDoubleOptIn then nil else useIsInExperience()
	local v35 = useTelemetry(AppTelemetryLayer.Context)

	React.useEffect(function() -- line: 108
		-- upvalues: v35 (copy), ConversationOverlayTelemetry (copy), modalVariant (copy)
		v35.emit(ConversationOverlayTelemetry.Events.ModalRendered, {
			modalVariant = modalVariant
		})
	end, { modalVariant })

	local v36 = if not FFlagAppChatEnableDoubleOptIn then t1[modalVariant] ~= nil else t3[modalVariant] ~= nil

	React.useEffect(function() -- line: 125
		-- upvalues: FFlagAppChatEnableTrustedFriendEntryPoint (copy), v36 (copy), v32 (copy), SetTabBarVisibleFromChat (copy)
		if not FFlagAppChatEnableTrustedFriendEntryPoint or not v36 then
			return
		end

		v32(SetTabBarVisibleFromChat(false))

		return function() -- line: 130
			-- upvalues: v32 (copy), SetTabBarVisibleFromChat (copy)
			v32(SetTabBarVisibleFromChat(true))
		end
	end, {
		v32,
		v36
	})

	local v37 = React.useCallback(function() -- line: 136
		-- upvalues: t4 (copy), FFlagAppChatEnableDoubleOptIn (copy), Promise (copy), FIntUnfilteredThreadsPvDelayMs (copy), v32 (copy), refreshConversationUnfilteredThreadsDetails (copy), v34 (copy)
		t4.dismissModal()

		if FFlagAppChatEnableDoubleOptIn then
			Promise.delay(FIntUnfilteredThreadsPvDelayMs / 1000):andThen(function() -- line: 139
				-- upvalues: v32 (copy), refreshConversationUnfilteredThreadsDetails (copy), t4 (copy), v34 (copy)
				v32(refreshConversationUnfilteredThreadsDetails(t4.conversationId, v34))
			end)
		end
	end, {
		t4.conversationId,
		modalVariant,
		v32,
		t4.dismissModal,
		v34
	})
	local v38 = React.useCallback(function() -- line: 152
		-- upvalues: v35 (copy), ConversationOverlayTelemetry (copy), modalVariant (copy), ModalTelemetry (copy), v37 (copy)
		v35.emit(ConversationOverlayTelemetry.Events.ModalAction, {
			modalVariant = modalVariant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta
		})
		v37()
	end, {
		v37,
		v35,
		modalVariant
	})
	local v39 = React.useCallback(function() -- line: 159
		-- upvalues: v35 (copy), ConversationOverlayTelemetry (copy), modalVariant (copy), ModalTelemetry (copy), v37 (copy)
		v35.emit(ConversationOverlayTelemetry.Events.ModalAction, {
			modalVariant = modalVariant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss
		})
		v37()
	end, {
		v37,
		v35,
		modalVariant
	})

	if FFlagAppChatEnableDoubleOptIn then
		local v40 = t3[modalVariant]

		if v40 then
			return React.createElement(v40.component, v40.mapProps({
				isVerticallyConstrained = v31,
				userId = v30,
				onClosed = v39,
				onAcknowledged = v38
			}))
		end
	else
		local v41 = t1[modalVariant]

		if v41 then
			return React.createElement(v41, {
				shouldOverrideNavigation = true,
				isVerticallyConstrained = v31,
				userId = v30,
				onClosed = v39,
				onAcknowledged = v38
			})
		end
	end

	return nil
end
