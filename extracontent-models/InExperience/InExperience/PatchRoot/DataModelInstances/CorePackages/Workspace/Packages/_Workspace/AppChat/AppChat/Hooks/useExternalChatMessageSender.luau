local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Http = require(parent.Http)
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local React = require(parent.React)
local RetrievalStatus = Http.Enum.RetrievalStatus
local StatusCodes = Http.StatusCodes
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigateIntoChat2 = require(AppChat.Conversations.Thunks.NavigateIntoChat)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local SendTextMessage = require(AppChat.Conversations.Thunks.SendTextMessage)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local createConversationFromFriendPlaceholder = require(AppChat.Conversations.createConversationFromFriendPlaceholder)
local EnumScreens = require(AppChat.EnumScreens)
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)
require(AppChat.Stores.GetConversationStore)
local getConversationSendEligibilityStatus = require(AppChat.Utils.getConversationSendEligibilityStatus)
local getUserSendEligibilityStatus = require(AppChat.Utils.getUserSendEligibilityStatus)
local navigateWithOsaGate = require(AppChat.Utils.navigateWithOsaGate)
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local useChatSettingsRetrievalStatus = require(AppChat.Hooks.useChatSettingsRetrievalStatus)
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local isNavigationAvailable = RobloxAppNavigation.isNavigationAvailable

local _ = { Success = "success", Failure = "failure", Declined = "declined" }

local function makeSendResult(status: string, id: string?) -- 10 equivalent calls inferred from this helper
	return { conversationId = id, status = status }
end

local function isSuccessfulResponse(data): boolean -- 1 equivalent call inferred from this helper
	if data then
		if data.responseCode == StatusCodes.OK then
			data = data.responseBody and data.responseBody.messages and data.responseBody.messages[1]
		else
			data = false
		end
	end

	local status = data and data.status

	return data ~= nil
		and (status == nil or status == "" or status == AppChatNetworking.Constants.ResponseStatus.SUCCESS)
end

local function useExternalChatMessageSender(flag: boolean)
	local dispatch = useDispatch()
	local timeoutStore = GetChatModerationStatusDataHydration()
	local v = useAppPolicy(function(p)
		return p.getCanUsePlatformChat()
	end)

	local v2 = useAppPolicy(function(p)
		return p.getCanSeeChatTerminology()
	end)

	local v3 = useChatSettingsRetrievalStatus()
	local v4 = useSelector(function(p)
		return tonumber(p.LocalUserId) or 0
	end)

	local v5 = useSelector(function(p): boolean
		return p.Navigation ~= nil
	end)

	local v6 = useIsChatEnabled()
	local v7 = useIsChatUserMessagesEnabled()
	local isGroupChatEnabled = useIsGroupChatEnabled()

	local isLoading = v3 ~= RetrievalStatus.Done
	local isAvailable = not isLoading and v and v2 and v6 and v7
	local v8 = React.useCallback(function(conversation, allowConversationStatusLoading: boolean)
		return getConversationSendEligibilityStatus({
			allowConversationStatusLoading = allowConversationStatusLoading,
			conversation = conversation,
			currentTimestamp = DateTime.now().UnixTimestamp,
			isAvailable = isAvailable,
			isGroupChatEnabled = isGroupChatEnabled,
			scope = false,
			timeoutStore = timeoutStore
		})
	end, { isAvailable, isGroupChatEnabled, timeoutStore })

	local canSendToConversation = React.useCallback(function(p): boolean
		return v8(p, false) == "eligible"
	end, { v8 })

	local canSendToUser = React.useCallback(function(_: string): boolean
		return getUserSendEligibilityStatus({
			currentTimestamp = DateTime.now().UnixTimestamp,
			isAvailable = isAvailable,
			scope = false
		}) == "eligible"
	end, { isAvailable })

	local v9 = React.useCallback(function(object, flag2: boolean, p: string)
		return object:andThen(function(p2)
			local id = p2 and p2.id

			if p2 == nil or id == nil or id == "" or p2.source == "friends" or v8(p2, flag2) ~= "eligible" then
				return makeSendResult("failure") -- inferred equivalent call
			end

			if flag2 then
				dispatch(ReceivedConversation(p2))
			end

			return Promise.new(function(callback)
				local function sendMessage()
					dispatch(SendTextMessage(id, p, nil)):andThen(function(data)
						callback(isSuccessfulResponse(data) and makeSendResult("success", id) or makeSendResult("failure")) -- inferred equivalent call
					end, function()
						callback(makeSendResult("failure")) -- inferred equivalent call
					end)
				end

				navigateWithOsaGate({
					conversationId = id,
					dispatch = dispatch,
					onAccepted = function()
						sendMessage()
					end,
					onDeclined = function()
						callback(makeSendResult("declined")) -- inferred equivalent call
					end,
					onError = function()
						callback(makeSendResult("failure")) -- inferred equivalent call
					end
				})
			end)
		end):catch(function()
			return makeSendResult("failure") -- inferred equivalent call
		end)
	end, { dispatch, v8 })

	local sendToConversation = React.useCallback(function(p, p2: string)
		if not canSendToConversation(p) then
			return Promise.resolve(makeSendResult("failure")) -- inferred equivalent call
		end

		local v10 = p.source == "friends"
		local v11

		if not v10 then
			v11 = Promise.resolve(p)

			return v9(v11, v10, p2)
		end

		v11 = createConversationFromFriendPlaceholder(p, v4)

		if v11 == nil then
			return Promise.resolve(makeSendResult("failure")) -- inferred equivalent call
		end

		return v9(v11, v10, p2)
	end, { canSendToConversation, v4, v9 })

	local sendToUser = React.useCallback(function(p: string, p2: string)
		if canSendToUser(p) then
			return v9(dispatch(createConversation("one_to_one", { p })), true, p2)
		end

		return Promise.resolve(makeSendResult("failure")) -- inferred equivalent call
	end, { canSendToUser, dispatch, v9 })
	local v10 = React.useCallback(function(conversationId: string?)
		dispatch(NavigateIntoChat2({ conversationId = conversationId }, true))

		if conversationId == nil then
			dispatch(NavigateIntoChat({ screen = EnumScreens.ChatLanding, params = {} }))
		end
	end, { dispatch })
	local v11 = not flag and (isNavigationAvailable() or v5)

	return React.useMemo(function()
		local v12 = {
			isAvailable = isAvailable,
			isGroupChatEnabled = isGroupChatEnabled,
			isLoading = isLoading,
			canSendToConversation = canSendToConversation,
			canSendToUser = canSendToUser,
			navigateToChat = nil,
			sendToConversation = nil,
			sendToUser = nil
		}
		local navigateToChat

		if v11 then
			navigateToChat = v10
		end

		v12.navigateToChat = navigateToChat
		v12.sendToConversation = sendToConversation
		v12.sendToUser = sendToUser
		return v12
	end, {
		isAvailable,
		isGroupChatEnabled,
		isLoading,
		canSendToConversation,
		canSendToUser,
		v10,
		v11,
		sendToConversation,
		sendToUser
	})
end

return useExternalChatMessageSender
