local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local UIBlox = require(AppChatParent.UIBlox)
local ReplyComposeBar = require(script.Parent.ReplyComposeBar)
local ReplyComposeBarConstants = require(script.Parent.ReplyComposeBarConstants)
local populateUserWithState = require(AppChat.Users.populateUserWithState)
local UserProfiles = require(AppChatParent.UserProfiles)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local GetConversationMessageStore = require(AppChat.Stores.GetConversationMessageStore)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local FFlagAppChatReplyComposeBarContainer = require(AppChat.Flags.FFlagAppChatReplyComposeBarContainer)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local t1 = {
	LayoutOrder = 3,
	message = nil,
	inputBoxRef = nil,
	unknownUserKey = "Feature.Chat.Label.UnknownUser",
	replyingToYourselfKey = "Feature.Chat.Label.ReplyingToYourself",
	replyingToOthersKey = "Feature.Chat.Label.ReplyingToOthers",
	close = function() -- line: 53
	end,
	setReplyComposeBarHeight = function(_) -- line: 56
	end
}

function getTargetMessageInfo(p2) -- line: 63
	if not p2 then
		return {}
	end

	return {
		targetMessageSenderId = p2.senderTargetId,
		targetMessageId = p2.id,
		targetMessageSentAt = if not p2.sent then nil else p2.sent.dateTime,
		targetMessageLength = if not p2.content then nil else #p2.content
	}
end

local function getTargetMessageInfoFromSignals(s1: string?, s2: string?, s3: string?) -- line: 75
	return {
		targetMessageSenderId = s1,
		targetMessageId = s2,
		targetMessageLength = if not s3 then nil else #s3
	}
end

function ReplyComposeBarContainer(t2: {[any]: any}) -- line: 83
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useLocalUserId (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), GetConversationMessageStore (copy), useSignalState (copy), React (copy), FFlagAppChatReplyComposeBarContainer (copy), ReplyComposeBarConstants (copy), ChatConversationTelemetryEvents (copy), useSelector (copy), populateUserWithState (copy), UserProfiles (copy), useLocalization (copy), ReplyComposeBar (copy)
	local v30 = Cryo.Dictionary.union(t1, t2)
	local v31 = useStyle()
	local v32 = useLocalUserId()
	local v33 = useTelemetry(ChatConversationTelemetryLayer.Context)

	if FFlagAppChatSignalsReplyStore then
		local v34 = GetReplyingToStore(false)
		local v35 = GetConversationMessageStore(false)
		local v36 = useSignalState(v34.getMessageId)
		local v37 = React.useMemo(function() -- line: 94
			-- upvalues: v36 (copy), v35 (copy)
			if v36 == nil then
				return nil
			end

			return v35.messages(false)[v36]
		end, {
			v36,
			v35
		})
		local v38 = if not v37 or not v37.sender_user_id then nil else tostring(v37.sender_user_id)
		local v39 = if not v37 then nil else v37.content
		local v40 = if not FFlagAppChatReplyComposeBarContainer then v31.Tokens.Size.Size_1400 + ReplyComposeBarConstants.VERTICAL_PADDING * 2 + ReplyComposeBarConstants.BORDER_HEIGHT else nil

		React.useEffect(function() -- line: 114
			-- upvalues: v33 (copy), ChatConversationTelemetryEvents (copy), v38 (copy), v36 (copy), v39 (copy), FFlagAppChatReplyComposeBarContainer (copy), v30 (copy), v40 (copy)
			local emit = v33.emit
			local ConversationInputBarReplyComposeRendered = ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered
			local v62 = v38
			local v63 = v36
			local v64 = v39

			emit(ConversationInputBarReplyComposeRendered, {
				targetMessageSenderId = v62,
				targetMessageId = v63,
				targetMessageLength = if not v64 then nil else #v64
			})

			if FFlagAppChatReplyComposeBarContainer then
				return function() -- line: 120
				end
			end

			v30.setReplyComposeBarHeight(v40)

			return function() -- line: 123
				-- upvalues: v30 (copy)
				v30.setReplyComposeBarHeight(0)
			end
		end, {})

		local v41 = useSelector(function(p3) -- line: 130
			-- upvalues: v38 (copy), populateUserWithState (copy)
			local v66 = if not p3 or (not p3.Users or not v38) then nil else p3.Users[v38]

			if v66 then
				return {
					targetUser = populateUserWithState(p3, v66)
				}
			end

			return {}
		end)
		local v42 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = if not v38 then {} else { v38 },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
		local v43 = if not v41.targetUser or (not v41.targetUser.displayName or v41.targetUser.displayName == "") then if not v42.data or (not v42.data.userProfiles or (not v42.data.userProfiles[1] or not v42.data.userProfiles[1].names)) then v30.unknownUserKey else UserProfiles.Selectors.getCombinedNameFromId(v42.data, v38) else v41.targetUser.displayName
		local v44 = useLocalization((if v43 ~= v30.unknownUserKey then {} else {
			replyingToUserName = v43
		})).replyingToUserName or v43
		local v45 = v32 == v38
		local v46 = if not v45 then {
			v30.replyingToOthersKey,
			DISPLAY_NAME = v44
		} else v30.replyingToYourselfKey
		local replyingToUserText = useLocalization({
			replyingToUserText = v46
		}).replyingToUserText
		local v48 = if v45 or not v41.targetUser then nil else v38
		local v49 = React.useCallback(function() -- line: 172
			-- upvalues: v33 (copy), ChatConversationTelemetryEvents (copy), v38 (copy), v36 (copy), v39 (copy), v30 (copy)
			local emit = v33.emit
			local ConversationInputBarReplyComposeCancelBtnActivated = ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated
			local v69 = v38
			local v70 = v36
			local v71 = v39

			emit(ConversationInputBarReplyComposeCancelBtnActivated, {
				targetMessageSenderId = v69,
				targetMessageId = v70,
				targetMessageLength = if not v71 then nil else #v71
			})
			v30.close()
		end, {
			v30.close,
			v33,
			v38,
			v36,
			v39
		})

		return React.createElement(ReplyComposeBar, {
			LayoutOrder = v30.LayoutOrder,
			totalHeight = if not FFlagAppChatReplyComposeBarContainer then v40 else nil,
			replyingToUserText = replyingToUserText,
			replyingToUserContent = v39,
			replyingToUserId = v48,
			onCloseActivated = v49
		})
	end

	local v50 = if not FFlagAppChatReplyComposeBarContainer then v31.Tokens.Size.Size_1400 + ReplyComposeBarConstants.VERTICAL_PADDING * 2 + ReplyComposeBarConstants.BORDER_HEIGHT else nil

	React.useEffect(function() -- line: 202
		-- upvalues: v33 (copy), ChatConversationTelemetryEvents (copy), v30 (copy), FFlagAppChatReplyComposeBarContainer (copy), v50 (copy)
		v33.emit(ChatConversationTelemetryEvents.ConversationInputBarReplyComposeRendered, getTargetMessageInfo(v30.message))

		if FFlagAppChatReplyComposeBarContainer then
			return function() -- line: 208
			end
		end

		v30.setReplyComposeBarHeight(v50)

		return function() -- line: 211
			-- upvalues: v30 (copy)
			v30.setReplyComposeBarHeight(0)
		end
	end, {})

	local v51 = useSelector(function(p4) -- line: 218
		-- upvalues: v30 (copy), populateUserWithState (copy)
		local v73 = if not p4 or (not p4.Users or not v30.message.senderTargetId) then nil else p4.Users[v30.message.senderTargetId]

		if v73 then
			return {
				targetUser = populateUserWithState(p4, v73)
			}
		end

		return {}
	end)
	local v52 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v30.message.senderTargetId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v53 = if not v51.targetUser or (not v51.targetUser.displayName or v51.targetUser.displayName == "") then if not v52.data or (not v52.data.userProfiles or (not v52.data.userProfiles[1] or not v52.data.userProfiles[1].names)) then v30.unknownUserKey else UserProfiles.Selectors.getCombinedNameFromId(v52.data, v30.message.senderTargetId) else v51.targetUser.displayName
	local v54 = useLocalization((if v53 ~= v30.unknownUserKey then {} else {
		replyingToUserName = v53
	})).replyingToUserName or v53
	local v55 = v32 == v30.message.senderTargetId
	local v56 = if not v55 then {
		v30.replyingToOthersKey,
		DISPLAY_NAME = v54
	} else v30.replyingToYourselfKey
	local replyingToUserText = useLocalization({
		replyingToUserText = v56
	}).replyingToUserText
	local v58 = if v55 or not v51.targetUser then nil else v30.message.senderTargetId
	local v59 = React.useCallback(function() -- line: 272
		-- upvalues: v33 (copy), ChatConversationTelemetryEvents (copy), v30 (copy)
		v33.emit(ChatConversationTelemetryEvents.ConversationInputBarReplyComposeCancelBtnActivated, getTargetMessageInfo(v30.message))
		v30.close()
	end, {
		v30.close,
		v33,
		v30.message
	})

	return React.createElement(ReplyComposeBar, {
		LayoutOrder = v30.LayoutOrder,
		totalHeight = if not FFlagAppChatReplyComposeBarContainer then v50 else nil,
		replyingToUserText = replyingToUserText,
		replyingToUserContent = v30.message.content,
		replyingToUserId = v58,
		onCloseActivated = v59
	})
end

return React.memo(ReplyComposeBarContainer)
