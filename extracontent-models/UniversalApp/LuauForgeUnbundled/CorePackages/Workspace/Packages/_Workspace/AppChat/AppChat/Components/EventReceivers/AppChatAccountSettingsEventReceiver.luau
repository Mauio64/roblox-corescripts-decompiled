local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fetchChatMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchChatMetadata")
local useIsAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsAppLoaded")
local useKeybind = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useKeybind")
local usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.usePrevious
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local reloadAllMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/reloadAllMessages")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")
local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local DismissedAllConversationModalsForSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/DismissedAllConversationModalsForSequence")
local useIsAppChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useIsAppChatVisible")

local getFFlagDebugAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagDebugAppChat")

local fFlagEnableAEGIS2AppChatConversationBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableAEGIS2AppChatConversationBanner

local fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatAccountSettingsEventReceiver")

local function AppChatAccountSettingsEventReceiver(p2): nil
	local v6 = useDispatch()
	local v7 = useIsAppLoaded()
	local v8

	if fFlagUseSignalsForAuthenticationStatus then
		v8 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
	else
		v8 = useSelector(function(p3)
			return p3.AuthenticationStatus and p3.AuthenticationStatus.status == loginStatus.LOGGED_IN
		end)
	end

	if getFFlagDebugAppChat() then
		useKeybind({ keyCode = Enum.KeyCode.G, modifierKey = Enum.ModifierKey.Ctrl }, function()
			v5:debug("Ctrl + G pressed, toggling group chat enabled")
			v6({ type = "Debug_GroupChatEnabledToggled" })
		end, { v6 })
	end

	local v9 = React.useCallback(function()
		v6(fetchChatMetadata()):andThen(function(p3)
			v5:info("Finished fetching chat metadata. Determined isChatEnabled as {}", p3)
		end)
	end, { v6 })

	local v10 = useIsAppChatVisible()

	React.useEffect(function()
		if (p2.isInExperience or v8) and not v7 then
			v5:info("App is not loaded, fetching chat metadata")
			v9()
		end
	end, { v9, v7, p2.isInExperience, v8 })
	local v11 = useIsChatEnabled()
	local v12

	if FFlagAppChatUseSignalsForChatSettings then
		v12 = useSignalState(GetFriendsChatSettingsStore(false).getChatUserMessagesEnabled)
	else
		v12 = useSelector(function(p3)
			return getDeepValue2(p3, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
		end)
	end

	local v13 = usePrevious(v12)

	React.useEffect(function()
		if v11 and v13 ~= nil and v13 ~= v12 then
			v5:info("Chat messages eligibility changed, reloading all messages")
			v6(reloadAllMessages()):catch(function(p3)
				v5:warn("Failed to reload all messages after chat user messages eligibility change", p3)
			end)
		end
	end, { v6, v11, v13, v12 })

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p3)
		if p3.SettingsChanged then
			local index = table.find(p3.SettingsChanged, "WhoCanUsePartyChatWithMe")

			if index then
				v5:info("Received privacy setting notification, reloading all messages")
				v6(reloadAllMessages()):catch(function(p4)
					v5:warn("Failed to reload all messages after party setting change", p4)
				end)
			end

			if
				table.find(p3.SettingsChanged, "WhoCanPartyWithMe")
				or table.find(p3.SettingsChanged, "WhoCanUsePartyVoiceWithMe")
				or index
			then
				v5:info("Received privacy setting notification, fetching chat metadata")
				v9()
			end
		end
	end, { v9, v6 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(p3, p4)
		if p3 == Enum.ConnectionState.Connected and p4 then
			v5:info("Reconnected to UserSettingsChanged, fetching chat metadata")
			v9()
		end
	end, { v9 })

	local function fn(isInExperience)
		v6(AppChatNetworking.rodux.GetChatLandingModal.API(isInExperience)):catch(function(p3)
			v5:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p3)))
		end)

		if fFlagEnableAEGIS2AppChatConversationBanner then
			v6(DismissedAllConversationModalsForSequence(AppChatNetworking.Constants.ModalSequence.ConversationBottomModal))
		end
	end

	RealtimeDelivery.useRealtimeNamespace(fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(p3)
		v5:info("Received Realtime: {}", fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace)

		if not v7 then
			return
		end

		fn(p2.isInExperience)
		v9()
	end, { v9, v7, p2.isInExperience, v10 })

	RealtimeDelivery.useRealtimeConnectionStateChanged(
		fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
		function(p3, p4)
			v5:info(
				"Reconnected to Realtime: {}, hasMissedEvents: {}",
				fStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
				(tostring(p4))
			)

			if p3 ~= Enum.ConnectionState.Connected or not (p4 and v7) then
				return
			end

			fn(p2.isInExperience)
			v9()
		end,
		{ v9, v7, p2.isInExperience, v10 }
	)

	return nil
end

return AppChatAccountSettingsEventReceiver
