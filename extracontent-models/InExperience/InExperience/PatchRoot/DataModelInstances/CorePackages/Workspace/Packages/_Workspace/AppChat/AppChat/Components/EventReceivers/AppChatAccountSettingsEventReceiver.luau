local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local LoginStatus = require(AppChatParent.RobloxAppEnums).LoginStatus
local FFlagUseSignalsForAuthenticationStatus = require(AppChatParent.SharedFlags).FFlagUseSignalsForAuthenticationStatus
local v10 = if not FFlagUseSignalsForAuthenticationStatus then nil else require(AppChatParent.AuthenticationStatus).GetAuthenticationStatusStore
local fetchChatMetadata = require(AppChat.Conversations.Thunks.fetchChatMetadata)
local useIsAppLoaded = require(AppChat.Hooks.useIsAppLoaded)
local useKeybind = require(AppChat.App.Hooks.useKeybind)
local usePrevious = require(AppChatParent.RoactUtils).Hooks.usePrevious
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local reloadAllMessages = require(AppChat.Conversations.Thunks.reloadAllMessages)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local DismissedAllConversationModalsForSequence = require(AppChat.Conversations.Actions.DismissedAllConversationModalsForSequence)
local useIsAppChatVisible = require(AppChat.App.Hooks.useIsAppChatVisible)
local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)
local FFlagEnableAEGIS2AppChatConversationBanner = require(AppChatParent.SharedFlags).FFlagEnableAEGIS2AppChatConversationBanner
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require(AppChatParent.SharedFlags).FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace
local v24 = require(AppChat.Logger):new(script.Name)

local function AppChatAccountSettingsEventReceiver(t1: {[any]: any}) -- line: 43
	-- upvalues: useDispatch (copy), useIsAppLoaded (copy), FFlagUseSignalsForAuthenticationStatus (copy), useSignalState (copy), v10 (copy), LoginStatus (copy), useSelector (copy), getFFlagDebugAppChat (copy), useKeybind (copy), v24 (copy), React (copy), fetchChatMetadata (copy), useIsAppChatVisible (copy), useIsChatEnabled (copy), getDeepValue2 (copy), usePrevious (copy), reloadAllMessages (copy), RealtimeDelivery (copy), AppChatNetworking (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), DismissedAllConversationModalsForSequence (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy)
	local v27 = useDispatch()
	local v28 = useIsAppLoaded()
	local v29 = if not FFlagUseSignalsForAuthenticationStatus then useSelector(function(p1) -- line: 48
		-- upvalues: LoginStatus (copy)
		return p1.AuthenticationStatus and p1.AuthenticationStatus.status == LoginStatus.LOGGED_IN
	end) else useSignalState(v10(false).getStatus) == LoginStatus.LOGGED_IN

	if getFFlagDebugAppChat() then
		useKeybind({
			keyCode = Enum.KeyCode.G,
			modifierKey = Enum.ModifierKey.Ctrl
		}, function() -- line: 53
			-- upvalues: v24 (copy), v27 (copy)
			v24:debug("Ctrl + G pressed, toggling group chat enabled")
			v27({
				type = "Debug_GroupChatEnabledToggled"
			})
		end, { v27 })
	end

	local v30 = React.useCallback(function() -- line: 61
		-- upvalues: v27 (copy), fetchChatMetadata (copy), v24 (copy)
		v27(fetchChatMetadata()):andThen(function(p2) -- line: 62
			-- upvalues: v24 (copy)
			v24:info("Finished fetching chat metadata. Determined isChatEnabled as {}", p2)
		end)
	end, { v27 })
	local v31 = useIsAppChatVisible()

	React.useEffect(function() -- line: 69
		-- upvalues: t1 (copy), v29 (copy), v28 (copy), v24 (copy), v30 (copy)
		if (t1.isInExperience or v29) and not v28 then
			v24:info("App is not loaded, fetching chat metadata")
			v30()
		end
	end, {
		v30,
		v28,
		t1.isInExperience,
		v29
	})

	local v32 = useIsChatEnabled()
	local v33 = useSelector(function(p3) -- line: 77
		-- upvalues: getDeepValue2 (copy)
		return getDeepValue2(p3, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
	end)
	local v34 = usePrevious(v33)

	React.useEffect(function() -- line: 82
		-- upvalues: v32 (copy), v34 (copy), v33 (copy), v24 (copy), v27 (copy), reloadAllMessages (copy)
		if v32 and (v34 ~= nil and v34 ~= v33) then
			v24:info("Chat messages eligibility changed, reloading all messages")
			v27(reloadAllMessages()):catch(function(p4) -- line: 89
				-- upvalues: v24 (copy)
				v24:warn("Failed to reload all messages after chat user messages eligibility change", p4)
			end)
		end
	end, {
		v27,
		v32,
		v34,
		v33
	})
	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p5) -- line: 95
		-- upvalues: v24 (copy), v27 (copy), reloadAllMessages (copy), v30 (copy)
		if p5.SettingsChanged then
			local v39 = table.find(p5.SettingsChanged, "WhoCanUsePartyChatWithMe")

			if v39 then
				v24:info("Received privacy setting notification, reloading all messages")
				v27(reloadAllMessages()):catch(function(p6) -- line: 101
					-- upvalues: v24 (copy)
					v24:warn("Failed to reload all messages after party setting change", p6)
				end)
			end

			if false or (table.find(p5.SettingsChanged, "WhoCanPartyWithMe") or (table.find(p5.SettingsChanged, "WhoCanUsePartyVoiceWithMe") or v39)) then
				v24:info("Received privacy setting notification, fetching chat metadata")
				v30()
			end
		end
	end, {
		v30,
		v27
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(p7, p8) -- line: 117
		-- upvalues: v24 (copy), v30 (copy)
		if p7 == Enum.ConnectionState.Connected and p8 then
			v24:info("Reconnected to UserSettingsChanged, fetching chat metadata")
			v30()
		end
	end, { v30 })

	local function v35(b1: boolean) -- line: 124
		-- upvalues: v27 (copy), AppChatNetworking (copy), v24 (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), DismissedAllConversationModalsForSequence (copy)
		v27(AppChatNetworking.rodux.GetChatLandingModal.API(b1)):catch(function(p9) -- line: 125
			-- upvalues: v24 (copy)
			v24:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p9)))
		end)

		if FFlagEnableAEGIS2AppChatConversationBanner then
			v27(DismissedAllConversationModalsForSequence(AppChatNetworking.Constants.ModalSequence.ConversationBottomModal))
		end
	end

	RealtimeDelivery.useRealtimeNamespace(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(_) -- line: 139
		-- upvalues: v24 (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), v28 (copy), v35 (copy), t1 (copy), v30 (copy)
		v24:info("Received Realtime: {}", FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace)

		if not v28 then
			return
		end

		v35(t1.isInExperience)
		v30()
	end, {
		v30,
		v28,
		t1.isInExperience,
		v31
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p11, p12) -- line: 151
		-- upvalues: v24 (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), v28 (copy), v35 (copy), t1 (copy), v30 (copy)
		v24:info("Reconnected to Realtime: {}, hasMissedEvents: {}", FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, (tostring(p12)))

		if p11 ~= Enum.ConnectionState.Connected or not p12 or not v28 then
			return
		end

		v35(t1.isInExperience)
		v30()
	end, {
		v30,
		v28,
		t1.isInExperience,
		v31
	})

	return nil
end

return AppChatAccountSettingsEventReceiver
