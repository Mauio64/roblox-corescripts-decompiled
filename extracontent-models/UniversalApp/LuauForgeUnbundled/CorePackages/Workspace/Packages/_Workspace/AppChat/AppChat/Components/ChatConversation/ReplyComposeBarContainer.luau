local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ReplyComposeBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ReplyComposeBar")
local populateUserWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/populateUserWithState")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local GetReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore")
local GetConversationMessageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")

local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local useProfileName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileName")

local v5 = {
	LayoutOrder = 3,
	message = nil,
	close = function() end,
	inputBoxRef = nil,
	unknownUserKey = "Feature.Chat.Label.UnknownUser",
	replyingToYourselfKey = "Feature.Chat.Label.ReplyingToYourself",
	replyingToOthersKey = "Feature.Chat.Label.ReplyingToOthers"
}

function LUAUFORGE_MODULE_GLOBALS_hoS_getTargetMessageInfo(data)
	if not data then
		return {}
	end

	local v6 = {
		targetMessageSenderId = data.senderTargetId,
		targetMessageId = data.id,
		targetMessageSentAt = 0,
		targetMessageLength = 0
	}
	local v7 = if data.sent then data.sent.dateTime else nil
	v6.targetMessageSentAt = v7
	v6.targetMessageLength = data.content and #data.content or nil
	return v6
end

local function getTargetMessageInfoFromSignals(p2, p3, list)
	return {
		targetMessageSenderId = p2,
		targetMessageId = p3,
		targetMessageLength = list and #list or nil
	}
end

function LUAUFORGE_MODULE_GLOBALS_hoS_ReplyComposeBarContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useLocalUserId()
	local v7 = useTelemetry(ChatConversationTelemetryLayer.Context)

	if FFlagAppChatSignalsReplyStore then
		local v8 = GetReplyingToStore(false)
		local v9 = GetConversationMessageStore(false)

		local v10 = useSignalState(v8.getMessageId)
		local v11 = React.useMemo(function()
			if v10 == nil then
				return nil
			end

			return v9.messages(false)[v10]
		end, { v10, v9 })

		local sender_user_id = if v11 and v11.sender_user_id then tostring(v11.sender_user_id) else nil

		local content = if v11 then v11.content else nil

		React.useEffect(function()
			local v12 = content
			v7.emit(ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered, {
				targetMessageSenderId = sender_user_id,
				targetMessageId = v10,
				targetMessageLength = v12 and #v12 or nil
			})

			return function() end
		end, {})

		local v12 = useSelector(function(p3)
			local v13 = if p3 and p3.Users and sender_user_id then p3.Users[sender_user_id] else nil

			if v13 then
				return { targetUser = populateUserWithState(p3, v13) }
			end

			return {}
		end)

		local v13 = nil
		local v14 = nil

		if FFlagAppChatUseUserProfileHydration then
			v14 = useProfileName(sender_user_id)
		else
			v13 = UserProfiles.Hooks.useUserProfilesFetch({
				userIds = sender_user_id and { sender_user_id } or {},
				query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
			})
		end

		local v15

		if v12.targetUser and v12.targetUser.displayName and v12.targetUser.displayName ~= "" then
			v15 = v12.targetUser.displayName
		elseif FFlagAppChatUseUserProfileHydration then
			v15 = v14.combinedName or union.unknownUserKey
		elseif
			v13.data
			and v13.data.userProfiles
			and v13.data.userProfiles[1]
			and v13.data.userProfiles[1].names
		then
			v15 = UserProfiles.Selectors.getCombinedNameFromId(v13.data, sender_user_id)
		else
			v15 = union.unknownUserKey
		end

		local replyingToUserName = useLocalization(v15 == union.unknownUserKey and {
				replyingToUserName = v15
			} or {}).replyingToUserName
			or v15
		local v16 = v6 == sender_user_id
		local v17

		if v16 then
			v17 = union.replyingToYourselfKey
		else
			v17 = {
				union.replyingToOthersKey,
				DISPLAY_NAME = replyingToUserName
			}
		end

		local replyingToUserText = useLocalization({ replyingToUserText = v17 }).replyingToUserText

		local v18 = if not (v16 or not v12.targetUser) then sender_user_id else nil

		local v19 = React.useCallback(function()
			local v20 = content
			v7.emit(ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated, {
				targetMessageSenderId = sender_user_id,
				targetMessageId = v10,
				targetMessageLength = v20 and #v20 or nil
			})

			union.close()
		end, { union.close, v7, sender_user_id, v10, content })

		return React.createElement(ReplyComposeBar, {
			LayoutOrder = union.LayoutOrder,
			replyingToUserText = replyingToUserText,
			replyingToUserContent = content,
			replyingToUserId = v18,
			onCloseActivated = v19
		})
	else
		React.useEffect(function()
			v7.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered,
				LUAUFORGE_MODULE_GLOBALS_hoS_getTargetMessageInfo(union.message)
			)

			return function() end
		end, {})

		local v8 = useSelector(function(p3)
			local v9

			if p3 and p3.Users and union.message.senderTargetId then
				v9 = p3.Users[union.message.senderTargetId]
			end

			if v9 then
				return { targetUser = populateUserWithState(p3, v9) }
			end

			return {}
		end)

		local v9 = nil
		local v10 = nil

		if FFlagAppChatUseUserProfileHydration then
			v10 = useProfileName(union.message.senderTargetId)
		else
			v9 = UserProfiles.Hooks.useUserProfilesFetch({
				userIds = { union.message.senderTargetId },
				query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
			})
		end

		local v11

		if v8.targetUser and v8.targetUser.displayName and v8.targetUser.displayName ~= "" then
			v11 = v8.targetUser.displayName
		elseif FFlagAppChatUseUserProfileHydration then
			v11 = v10.combinedName or union.unknownUserKey
		elseif
			v9.data
			and v9.data.userProfiles
			and v9.data.userProfiles[1]
			and v9.data.userProfiles[1].names
		then
			v11 = UserProfiles.Selectors.getCombinedNameFromId(v9.data, union.message.senderTargetId)
		else
			v11 = union.unknownUserKey
		end

		local replyingToUserName = useLocalization(v11 == union.unknownUserKey and {
				replyingToUserName = v11
			} or {}).replyingToUserName
			or v11

		local v12 = v6 == union.message.senderTargetId
		local v13

		if v12 then
			v13 = union.replyingToYourselfKey
		else
			v13 = {
				union.replyingToOthersKey,
				DISPLAY_NAME = replyingToUserName
			}
		end

		local replyingToUserText = useLocalization({ replyingToUserText = v13 }).replyingToUserText

		local senderTargetId = if not (v12 or not v8.targetUser) then union.message.senderTargetId else nil

		local v14 = React.useCallback(function()
			v7.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated,
				LUAUFORGE_MODULE_GLOBALS_hoS_getTargetMessageInfo(union.message)
			)

			union.close()
		end, { union.close, v7, union.message })

		return React.createElement(ReplyComposeBar, {
			LayoutOrder = union.LayoutOrder,
			replyingToUserText = replyingToUserText,
			replyingToUserContent = union.message.content,
			replyingToUserId = senderTargetId,
			onCloseActivated = v14
		})
	end
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hoS_ReplyComposeBarContainer)
