local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ReplyComposeBar = require(script.Parent.ReplyComposeBar)
local populateUserWithState = require(AppChat.Users.populateUserWithState)
local UserProfiles = require(parent.UserProfiles)

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)

local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local useProfileName = require(AppChat.Hooks.useProfileName)

local v = {
	LayoutOrder = 3,
	message = nil,
	close = function() end,
	inputBoxRef = nil,
	unknownUserKey = "Feature.Chat.Label.UnknownUser",
	replyingToYourselfKey = "Feature.Chat.Label.ReplyingToYourself",
	replyingToOthersKey = "Feature.Chat.Label.ReplyingToOthers"
}

function getTargetMessageInfo(data)
	if not data then
		return {}
	end

	local v2 = {
		targetMessageSenderId = data.senderTargetId,
		targetMessageId = data.id,
		targetMessageSentAt = 0,
		targetMessageLength = 0
	}
	local targetMessageSentAt

	if data.sent then
		targetMessageSentAt = data.sent.dateTime
	end

	v2.targetMessageSentAt = targetMessageSentAt
	v2.targetMessageLength = data.content and #data.content or nil
	return v2
end

local function getTargetMessageInfoFromSignals(sender_user_id: string?, targetMessageId: string?, content: string?) -- 2 equivalent calls inferred from this helper
	return {
		targetMessageSenderId = sender_user_id,
		targetMessageId = targetMessageId,
		targetMessageLength = content and #content or nil
	}
end

function ReplyComposeBarContainer(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useLocalUserId()
	local v3 = useTelemetry(ChatConversationTelemetryLayer.Context)

	if FFlagAppChatSignalsReplyStore then
		local replyingToStore = GetReplyingToStore(false)
		local conversationMessageStore = GetConversationMessageStore(false)

		local targetMessageId = useSignalState(replyingToStore.getMessageId)
		local v4 = React.useMemo(function()
			if targetMessageId == nil then
				return nil
			end

			return conversationMessageStore.messages(false)[targetMessageId]
		end, { targetMessageId, conversationMessageStore })
		local sender_user_id

		if v4 and v4.sender_user_id then
			sender_user_id = tostring(v4.sender_user_id)
		else
			sender_user_id = nil
		end

		local content

		if v4 then
			content = v4.content
		else
			content = nil
		end

		React.useEffect(function()
			v3.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered,
				getTargetMessageInfoFromSignals(sender_user_id, targetMessageId, content) -- inferred equivalent call
			)

			return function() end
		end, {})

		local v5 = useSelector(function(p2)
			local v5

			if p2 and p2.Users and sender_user_id then
				v5 = p2.Users[sender_user_id]
			end

			if v5 then
				return { targetUser = populateUserWithState(p2, v5) }
			end

			return {}
		end)

		local v6 = nil
		local v7 = nil

		if FFlagAppChatUseUserProfileHydration then
			v7 = useProfileName(sender_user_id)
		else
			v6 = UserProfiles.Hooks.useUserProfilesFetch({
				userIds = sender_user_id and { sender_user_id } or {},
				query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
			})
		end

		local replyingToUserName2

		if v5.targetUser and v5.targetUser.displayName and v5.targetUser.displayName ~= "" then
			replyingToUserName2 = v5.targetUser.displayName
		elseif FFlagAppChatUseUserProfileHydration then
			replyingToUserName2 = v7.combinedName or union.unknownUserKey
		elseif v6.data and v6.data.userProfiles and v6.data.userProfiles[1] and v6.data.userProfiles[1].names then
			replyingToUserName2 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, sender_user_id)
		else
			replyingToUserName2 = union.unknownUserKey
		end

		local replyingToUserName = useLocalization(replyingToUserName2 == union.unknownUserKey and {
				replyingToUserName = replyingToUserName2
			} or {}).replyingToUserName
			or replyingToUserName2
		local v8 = v2 == sender_user_id
		local replyingToUserText2

		if v8 then
			replyingToUserText2 = union.replyingToYourselfKey
		else
			replyingToUserText2 = {
				union.replyingToOthersKey,
				DISPLAY_NAME = replyingToUserName
			}
		end

		local replyingToUserText = useLocalization({ replyingToUserText = replyingToUserText2 }).replyingToUserText
		local replyingToUserId

		if not (v8 or not v5.targetUser) then
			replyingToUserId = sender_user_id
		end

		local onCloseActivated = React.useCallback(function()
			v3.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated,
				getTargetMessageInfoFromSignals(sender_user_id, targetMessageId, content) -- inferred equivalent call
			)

			union.close()
		end, { union.close, v3, sender_user_id, targetMessageId, content })

		return React.createElement(ReplyComposeBar, {
			LayoutOrder = union.LayoutOrder,
			replyingToUserText = replyingToUserText,
			replyingToUserContent = content,
			replyingToUserId = replyingToUserId,
			onCloseActivated = onCloseActivated
		})
	else
		React.useEffect(function()
			v3.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered,
				getTargetMessageInfo(union.message)
			)

			return function() end
		end, {})

		local v4 = useSelector(function(p2)
			local v4

			if p2 and p2.Users and union.message.senderTargetId then
				v4 = p2.Users[union.message.senderTargetId]
			end

			if v4 then
				return { targetUser = populateUserWithState(p2, v4) }
			end

			return {}
		end)

		local v5 = nil
		local v6 = nil

		if FFlagAppChatUseUserProfileHydration then
			v6 = useProfileName(union.message.senderTargetId)
		else
			v5 = UserProfiles.Hooks.useUserProfilesFetch({
				userIds = { union.message.senderTargetId },
				query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
			})
		end

		local replyingToUserName2

		if v4.targetUser and v4.targetUser.displayName and v4.targetUser.displayName ~= "" then
			replyingToUserName2 = v4.targetUser.displayName
		elseif FFlagAppChatUseUserProfileHydration then
			replyingToUserName2 = v6.combinedName or union.unknownUserKey
		elseif v5.data and v5.data.userProfiles and v5.data.userProfiles[1] and v5.data.userProfiles[1].names then
			replyingToUserName2 = UserProfiles.Selectors.getCombinedNameFromId(v5.data, union.message.senderTargetId)
		else
			replyingToUserName2 = union.unknownUserKey
		end

		local replyingToUserName = useLocalization(replyingToUserName2 == union.unknownUserKey and {
				replyingToUserName = replyingToUserName2
			} or {}).replyingToUserName
			or replyingToUserName2

		local v7 = v2 == union.message.senderTargetId
		local replyingToUserText2

		if v7 then
			replyingToUserText2 = union.replyingToYourselfKey
		else
			replyingToUserText2 = {
				union.replyingToOthersKey,
				DISPLAY_NAME = replyingToUserName
			}
		end

		local replyingToUserText = useLocalization({ replyingToUserText = replyingToUserText2 }).replyingToUserText
		local senderTargetId

		if not (v7 or not v4.targetUser) then
			senderTargetId = union.message.senderTargetId
		end

		local onCloseActivated = React.useCallback(function()
			v3.emit(
				ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated,
				getTargetMessageInfo(union.message)
			)

			union.close()
		end, { union.close, v3, union.message })

		return React.createElement(ReplyComposeBar, {
			LayoutOrder = union.LayoutOrder,
			replyingToUserText = replyingToUserText,
			replyingToUserContent = union.message.content,
			replyingToUserId = senderTargetId,
			onCloseActivated = onCloseActivated
		})
	end
end

return React.memo(ReplyComposeBarContainer)
