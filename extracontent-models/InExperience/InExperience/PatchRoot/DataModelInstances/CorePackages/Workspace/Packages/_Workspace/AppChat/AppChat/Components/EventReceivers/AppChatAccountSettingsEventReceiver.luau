local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(AppChatParent.RobloxAppEnums).LoginStatus
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
local v21 = require(AppChat.Logger):new(script.Name)

local function AppChatAccountSettingsEventReceiver(t1: {[any]: any}) -- line: 35
	-- upvalues: useDispatch (copy), useIsAppLoaded (copy), useSelector (copy), LoginStatus (copy), getFFlagDebugAppChat (copy), useKeybind (copy), v21 (copy), React (copy), fetchChatMetadata (copy), useIsAppChatVisible (copy), useIsChatEnabled (copy), getDeepValue2 (copy), usePrevious (copy), reloadAllMessages (copy), RealtimeDelivery (copy), AppChatNetworking (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), DismissedAllConversationModalsForSequence (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy)
	local v24 = useDispatch()
	local v25 = useIsAppLoaded()
	local v26 = useSelector(function(p1) -- line: 38
		-- upvalues: LoginStatus (copy)
		return p1.AuthenticationStatus and p1.AuthenticationStatus.status == LoginStatus.LOGGED_IN
	end)

	if getFFlagDebugAppChat() then
		useKeybind({
			keyCode = Enum.KeyCode.G,
			modifierKey = Enum.ModifierKey.Ctrl
		}, function() -- line: 43
			-- upvalues: v21 (copy), v24 (copy)
			v21:debug("Ctrl + G pressed, toggling group chat enabled")
			v24({
				type = "Debug_GroupChatEnabledToggled"
			})
		end, { v24 })
	end

	local v27 = React.useCallback(function() -- line: 51
		-- upvalues: v24 (copy), fetchChatMetadata (copy), v21 (copy)
		v24(fetchChatMetadata()):andThen(function(p2) -- line: 52
			-- upvalues: v21 (copy)
			v21:info("Finished fetching chat metadata. Determined isChatEnabled as {}", p2)
		end)
	end, { v24 })
	local v28 = useIsAppChatVisible()

	React.useEffect(function() -- line: 59
		-- upvalues: t1 (copy), v26 (copy), v25 (copy), v21 (copy), v27 (copy)
		if (t1.isInExperience or v26) and not v25 then
			v21:info("App is not loaded, fetching chat metadata")
			v27()
		end
	end, {
		v27,
		v25,
		t1.isInExperience,
		v26
	})

	local v29 = useIsChatEnabled()
	local v30 = useSelector(function(p3) -- line: 67
		-- upvalues: getDeepValue2 (copy)
		return getDeepValue2(p3, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
	end)
	local v31 = usePrevious(v30)

	React.useEffect(function() -- line: 72
		-- upvalues: v29 (copy), v31 (copy), v30 (copy), v21 (copy), v24 (copy), reloadAllMessages (copy)
		if v29 and (v31 ~= nil and v31 ~= v30) then
			v21:info("Chat messages eligibility changed, reloading all messages")
			v24(reloadAllMessages()):catch(function(p4) -- line: 79
				-- upvalues: v21 (copy)
				v21:warn("Failed to reload all messages after chat user messages eligibility change", p4)
			end)
		end
	end, {
		v24,
		v29,
		v31,
		v30
	})
	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p5) -- line: 85
		-- upvalues: v21 (copy), v24 (copy), reloadAllMessages (copy), v27 (copy)
		if p5.SettingsChanged then
			local v36 = table.find(p5.SettingsChanged, "WhoCanUsePartyChatWithMe")

			if v36 then
				v21:info("Received privacy setting notification, reloading all messages")
				v24(reloadAllMessages()):catch(function(p6) -- line: 91
					-- upvalues: v21 (copy)
					v21:warn("Failed to reload all messages after party setting change", p6)
				end)
			end

			if false or (table.find(p5.SettingsChanged, "WhoCanPartyWithMe") or (table.find(p5.SettingsChanged, "WhoCanUsePartyVoiceWithMe") or v36)) then
				v21:info("Received privacy setting notification, fetching chat metadata")
				v27()
			end
		end
	end, {
		v27,
		v24
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(p7, p8) -- line: 107
		-- upvalues: v21 (copy), v27 (copy)
		if p7 == Enum.ConnectionState.Connected and p8 then
			v21:info("Reconnected to UserSettingsChanged, fetching chat metadata")
			v27()
		end
	end, { v27 })

	local function v32(b1: boolean) -- line: 114
		-- upvalues: v24 (copy), AppChatNetworking (copy), v21 (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), DismissedAllConversationModalsForSequence (copy)
		v24(AppChatNetworking.rodux.GetChatLandingModal.API(b1)):catch(function(p9) -- line: 115
			-- upvalues: v21 (copy)
			v21:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p9)))
		end)

		if FFlagEnableAEGIS2AppChatConversationBanner then
			v24(DismissedAllConversationModalsForSequence(AppChatNetworking.Constants.ModalSequence.ConversationBottomModal))
		end
	end

	RealtimeDelivery.useRealtimeNamespace(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(_) -- line: 129
		-- upvalues: v21 (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), v25 (copy), v32 (copy), t1 (copy), v27 (copy)
		v21:info("Received Realtime: {}", FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace)

		if not v25 then
			return
		end

		v32(t1.isInExperience)
		v27()
	end, {
		v27,
		v25,
		t1.isInExperience,
		v28
	})
	RealtimeDelivery.useRealtimeConnectionStateChanged(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p11, p12) -- line: 141
		-- upvalues: v21 (copy), FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace (copy), v25 (copy), v32 (copy), t1 (copy), v27 (copy)
		v21:info("Reconnected to Realtime: {}, hasMissedEvents: {}", FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, (tostring(p12)))

		if p11 ~= Enum.ConnectionState.Connected or not p12 or not v25 then
			return
		end

		v32(t1.isInExperience)
		v27()
	end, {
		v27,
		v25,
		t1.isInExperience,
		v28
	})

	return nil
end

return AppChatAccountSettingsEventReceiver
