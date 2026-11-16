local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fetchChatMetadata = require(AppChat.Conversations.Thunks.fetchChatMetadata)
local useIsAppLoaded = require(AppChat.Hooks.useIsAppLoaded)
local useKeybind = require(AppChat.App.Hooks.useKeybind)
local RoactUtils3 = require(parent.RoactUtils)
local usePrevious = RoactUtils3.Hooks.usePrevious
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local reloadAllMessages = require(AppChat.Conversations.Thunks.reloadAllMessages)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

local AppChatNetworking = require(parent.AppChatNetworking)

local DismissedAllConversationModalsForSequence = require(AppChat.Conversations.Actions.DismissedAllConversationModalsForSequence)
local useIsAppChatVisible = require(AppChat.App.Hooks.useIsAppChatVisible)

local getFFlagDebugAppChat = require(AppChat.Flags.getFFlagDebugAppChat)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableAEGIS2AppChatConversationBanner = SharedFlags2.FFlagEnableAEGIS2AppChatConversationBanner

local SharedFlags3 = require(parent.SharedFlags)
local FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace = SharedFlags3.FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function AppChatAccountSettingsEventReceiver(p): nil
	local v2 = useDispatch()
	local v3 = useIsAppLoaded()
	local v4

	if FFlagUseSignalsForAuthenticationStatus then
		v4 = useSignalState(getAuthenticationStatusStore(false).getStatus) == LoginStatus.LOGGED_IN
	else
		v4 = useSelector(function(p2)
			return p2.AuthenticationStatus and p2.AuthenticationStatus.status == LoginStatus.LOGGED_IN
		end)
	end

	if getFFlagDebugAppChat() then
		useKeybind({ keyCode = Enum.KeyCode.G, modifierKey = Enum.ModifierKey.Ctrl }, function()
			v:debug("Ctrl + G pressed, toggling group chat enabled")
			v2({ type = "Debug_GroupChatEnabledToggled" })
		end, { v2 })
	end

	local v5 = React.useCallback(function()
		v2(fetchChatMetadata()):andThen(function(p2)
			v:info("Finished fetching chat metadata. Determined isChatEnabled as {}", p2)
		end)
	end, { v2 })

	local v6 = useIsAppChatVisible()

	React.useEffect(function()
		if (p.isInExperience or v4) and not v3 then
			v:info("App is not loaded, fetching chat metadata")
			v5()
		end
	end, { v5, v3, p.isInExperience, v4 })
	local v7 = useIsChatEnabled()
	local v8

	if FFlagAppChatUseSignalsForChatSettings then
		v8 = useSignalState(GetFriendsChatSettingsStore(false).getChatUserMessagesEnabled)
	else
		v8 = useSelector(function(p2)
			return getDeepValue2(p2, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
		end)
	end

	local v9 = usePrevious(v8)

	React.useEffect(function()
		if v7 and v9 ~= nil and v9 ~= v8 then
			v:info("Chat messages eligibility changed, reloading all messages")
			v2(reloadAllMessages()):catch(function(p2)
				v:warn("Failed to reload all messages after chat user messages eligibility change", p2)
			end)
		end
	end, { v2, v7, v9, v8 })

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p2)
		if p2.SettingsChanged then
			local index = table.find(p2.SettingsChanged, "WhoCanUsePartyChatWithMe")

			if index then
				v:info("Received privacy setting notification, reloading all messages")
				v2(reloadAllMessages()):catch(function(p3)
					v:warn("Failed to reload all messages after party setting change", p3)
				end)
			end

			if
				table.find(p2.SettingsChanged, "WhoCanPartyWithMe")
				or table.find(p2.SettingsChanged, "WhoCanUsePartyVoiceWithMe")
				or index
			then
				v:info("Received privacy setting notification, fetching chat metadata")
				v5()
			end
		end
	end, { v5, v2 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("UserSettingsChanged", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v:info("Reconnected to UserSettingsChanged, fetching chat metadata")
			v5()
		end
	end, { v5 })

	local function fn(isInExperience: boolean)
		v2(AppChatNetworking.rodux.GetChatLandingModal.API(isInExperience)):catch(function(p2)
			v:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p2)))
		end)

		if FFlagEnableAEGIS2AppChatConversationBanner then
			v2(DismissedAllConversationModalsForSequence(AppChatNetworking.Constants.ModalSequence.ConversationBottomModal))
		end
	end

	RealtimeDelivery.useRealtimeNamespace(FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace, function(_)
		v:info("Received Realtime: {}", FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace)

		if not v3 then
			return
		end

		fn(p.isInExperience)
		v5()
	end, { v5, v3, p.isInExperience, v6 })

	RealtimeDelivery.useRealtimeConnectionStateChanged(
		FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
		function(p2, p3)
			v:info(
				"Reconnected to Realtime: {}, hasMissedEvents: {}",
				FStringAEGIS2AppChatAgeVerifiedRealtimeNamespace,
				(tostring(p3))
			)

			if p2 ~= Enum.ConnectionState.Connected or not (p3 and v3) then
				return
			end

			fn(p.isInExperience)
			v5()
		end,
		{ v5, v3, p.isInExperience, v6 }
	)

	return nil
end

return AppChatAccountSettingsEventReceiver
