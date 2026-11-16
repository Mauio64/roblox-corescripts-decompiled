local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local retrievalStatus = Http.Enum.RetrievalStatus
local statusCodes = Http.StatusCodes
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoChat")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local SendTextMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendTextMessage")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local createConversationFromFriendPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/createConversationFromFriendPlaceholder")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local GetChatModerationStatusDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local getConversationSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationSendEligibilityStatus")
local getUserSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUserSendEligibilityStatus")
local navigateWithOsaGate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/navigateWithOsaGate")
local module16 = require("@luauforge/bundled/gsb")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useIsChatUserMessagesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")
local useChatSettingsRetrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatSettingsRetrievalStatus")
local useIsGroupChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGroupChatEnabled")
local isNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").isNavigationAvailable
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagShareSheetFriendsSort

local v5 = { Success = "success", Failure = "failure", Declined = "declined" }

local function makeSendResult(p2, p3)
	return { conversationId = p3, status = p2 }
end

local function isSuccessfulResponse(data): boolean
	if data then
		if data.responseCode == statusCodes.OK then
			data = data.responseBody and data.responseBody.messages and data.responseBody.messages[1]
		else
			data = false
		end
	end

	local status = data and data.status

	return data ~= nil
		and (status == nil or status == "" or status == AppChatNetworking.Constants.ResponseStatus.SUCCESS)
end

local function useExternalChatMessageSender(p2)
	local v6 = useDispatch()
	local v7 = GetChatModerationStatusDataHydration()
	local v8 = module16(function(p3)
		return p3.getCanUsePlatformChat()
	end)

	local v9 = module16(function(p3)
		return p3.getCanSeeChatTerminology()
	end)

	local v10 = useChatSettingsRetrievalStatus()
	local v11 = useSelector(function(p3)
		return tonumber(p3.LocalUserId) or 0
	end)

	local v12 = useSelector(function(p3): boolean
		return p3.Navigation ~= nil
	end)

	local v13 = useIsChatEnabled()
	local v14 = useIsChatUserMessagesEnabled()
	local v15 = useIsGroupChatEnabled()

	local v16 = v10 ~= retrievalStatus.Done
	local v17 = not v16 and v8 and v9 and v13 and v14
	local v18 = React.useCallback(function(p3, p4)
		return getConversationSendEligibilityStatus({
			allowConversationStatusLoading = p4,
			conversation = p3,
			currentTimestamp = DateTime.now().UnixTimestamp,
			isAvailable = v17,
			isGroupChatEnabled = v15,
			scope = false,
			timeoutStore = v7
		})
	end, { v17, v15, v7 })

	local v19 = React.useCallback(function(p3): boolean
		return v18(p3, false) == "eligible"
	end, { v18 })

	local v20 = React.useCallback(function(p3): boolean
		return getUserSendEligibilityStatus({
			currentTimestamp = DateTime.now().UnixTimestamp,
			isAvailable = v17,
			scope = false
		}) == "eligible"
	end, { v17 })

	local v21 = React.useCallback(function(object, p3, p4)
		return object:andThen(function(p5)
			local id = p5 and p5.id

			if
				p5 == nil
				or id == nil
				or id == ""
				or p5.source == "friends"
				or v18(p5, p3) ~= "eligible"
			then
				return { conversationId = nil, status = "failure" }
			end

			if p3 then
				v6(ReceivedConversation(p5))
			end

			return Promise.new(function(callback)
				local function sendMessage()
					v6(SendTextMessage(id, p4, nil)):andThen(function(data)
						if data then
							if data.responseCode == statusCodes.OK then
								data = data.responseBody
									and data.responseBody.messages
									and data.responseBody.messages[1]
							else
								data = false
							end
						end

						local status = data and data.status
						callback(data ~= nil and (status == nil or status == "" or status == AppChatNetworking.Constants.ResponseStatus.SUCCESS) and {
							conversationId = id,
							status = "success"
						} or { conversationId = nil, status = "failure" })
					end, function()
						callback({ conversationId = nil, status = "failure" })
					end)
				end

				navigateWithOsaGate({
					conversationId = id,
					dispatch = v6,
					onAccepted = function()
						sendMessage()
					end,
					onDeclined = function()
						callback({ conversationId = nil, status = "declined" })
					end,
					onError = function()
						callback({ conversationId = nil, status = "failure" })
					end
				})
			end)
		end):catch(function()
			return { conversationId = nil, status = "failure" }
		end)
	end, { v6, v18 })

	local v22 = React.useCallback(function(p3, p4)
		if not v19(p3) then
			return Promise.resolve({ conversationId = nil, status = "failure" })
		end

		local v23 = p3.source == "friends"
		local v24

		if v23 then
			v24 = createConversationFromFriendPlaceholder(p3, v11)

			if v24 == nil then
				return Promise.resolve({ conversationId = nil, status = "failure" })
			end
		else
			v24 = Promise.resolve(p3)
		end

		if fFlagShareSheetFriendsSort then
			return v21(v24, v23, p4)
		end

		return v24:andThen(function(p5)
			local id = p5 and p5.id

			if
				p5 == nil
				or id == nil
				or id == ""
				or p5.source == "friends"
				or v18(p5, v23) ~= "eligible"
			then
				return { conversationId = nil, status = "failure" }
			end

			if v23 then
				v6(ReceivedConversation(p5))
			end

			return Promise.new(function(callback)
				local function sendMessage()
					v6(SendTextMessage(id, p4, nil)):andThen(function(data)
						if data then
							if data.responseCode == statusCodes.OK then
								data = data.responseBody
									and data.responseBody.messages
									and data.responseBody.messages[1]
							else
								data = false
							end
						end

						local status = data and data.status
						callback(data ~= nil and (status == nil or status == "" or status == AppChatNetworking.Constants.ResponseStatus.SUCCESS) and {
							conversationId = id,
							status = "success"
						} or { conversationId = nil, status = "failure" })
					end, function()
						callback({ conversationId = nil, status = "failure" })
					end)
				end

				navigateWithOsaGate({
					conversationId = id,
					dispatch = v6,
					onAccepted = function()
						sendMessage()
					end,
					onDeclined = function()
						callback({ conversationId = nil, status = "declined" })
					end,
					onError = function()
						callback({ conversationId = nil, status = "failure" })
					end
				})
			end)
		end):catch(function()
			return { conversationId = nil, status = "failure" }
		end)
	end, { v19, v6, v18, v11, v21 })

	local v23 = React.useCallback(function(p3, p4)
		if v20(p3) then
			return v21(v6(createConversation("one_to_one", { p3 })), true, p4)
		end

		return Promise.resolve({ conversationId = nil, status = "failure" })
	end, { v20, v6, v21 })
	local v24 = React.useCallback(function(p3)
		v6(module6({ conversationId = p3 }, true))

		if p3 == nil then
			v6(NavigateIntoChat({ screen = EnumScreens.ChatLanding, params = {} }))
		end
	end, { v6 })
	local v25 = not p2 and (isNavigationAvailable() or v12)

	return React.useMemo(function()
		return {
			isAvailable = v17,
			isGroupChatEnabled = v15,
			isLoading = v16,
			canSendToConversation = v19,
			canSendToUser = v20,
			navigateToChat = if v25 then v24 else nil,
			sendToConversation = v22,
			sendToUser = v23
		}
	end, {
		v17,
		v15,
		v16,
		v19,
		v20,
		v24,
		v25,
		v22,
		v23
	})
end

return useExternalChatMessageSender
