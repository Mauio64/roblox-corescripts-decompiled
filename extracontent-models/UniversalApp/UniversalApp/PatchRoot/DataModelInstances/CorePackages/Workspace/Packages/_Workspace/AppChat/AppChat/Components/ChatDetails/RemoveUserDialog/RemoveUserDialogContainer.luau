local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local populateUserWithState = require(AppChat.Users.populateUserWithState)

require(AppChat.types)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local RemoveUserDialogLayout = require(script.Parent.RemoveUserDialogLayout)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local t1 = {
	participantId = nil,
	titleKey = "Feature.Chat.Action.RemoveUser",
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Remove",
	failureTitleKey = "Feature.Chat.Heading.FailedToRemoveUser",
	failureButtonKey = "Feature.Chat.Action.Confirm",
	onModalClose = function() -- line: 40
	end,
	messageKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.RemoveUser" or "Feature.Chat.Message.RemoveUser.V2",
	failureBodyKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRemoveUser" or "Feature.Chat.Message.FailedToRemoveUser.V2"
}

function RemoveUserDialogContainer(t2: {[any]: any}) -- line: 57
	-- upvalues: Cryo (copy), t1 (copy), useState (copy), useDispatch (copy), useCallback (copy), AppChatNetworking (copy), useSelector (copy), populateUserWithState (copy), useLocalization (copy), React (copy), RemoveUserDialogLayout (copy)
	local v17 = Cryo.Dictionary.join(t1, t2)
	local v18, v19 = useState(true)
	local v20, v21 = useState(false)
	local v22, v23 = useState(false)
	local v24 = useDispatch()
	local v25 = useCallback(function(p1, p2) -- line: 64
		-- upvalues: v24 (copy), AppChatNetworking (copy)
		return v24(AppChatNetworking.rodux.RemoveUserFromConversation.API(p2, p1))
	end, { v24 })
	local v26 = useSelector(function(p3) -- line: 68
		-- upvalues: v17 (copy), populateUserWithState (copy)
		local v32 = p3.ChatAppReducer.Conversations[v17.conversationId] or {
			title = nil
		}
		local v33 = p3.Users[v17.participantId]

		return {
			conversationTitle = v32.title,
			targetUser = populateUserWithState(p3, v33)
		}
	end)
	local v27 = useCallback(function() -- line: 80
		-- upvalues: v21 (copy), v19 (copy), v17 (copy), v25 (copy), v23 (copy)
		v21(true)
		v19(false)

		local conversationId = v17.conversationId

		if conversationId then
			v25(v17.participantId, conversationId):andThen(function() -- line: 87
				-- upvalues: v17 (copy)
				v17.onModalClose()
			end):catch(function() -- line: 90
				-- upvalues: v21 (copy), v19 (copy), v23 (copy)
				v21(false)
				v19(true)
				v23(true)
			end)
		end

		return true
	end, {
		v17.participantId,
		v17.conversationId
	})
	local v28 = useLocalization({
		failureTitleText = "Feature.Chat.Heading.FailedToRemoveUser",
		failureButtonText = "Feature.Chat.Action.Confirm",
		titleText = v17.titleKey,
		bodyText = {
			v17.messageKey,
			USERNAME = v26.targetUser.displayName
		},
		cancelText = v17.cancelTitleKey,
		confirmText = v17.confirmationTitleKey,
		failureBodyText = {
			v17.failureBodyKey,
			USERNAME = v26.targetUser.displayName,
			CONVERSATION_TITLE = v26.conversationTitle
		}
	})

	return React.createElement(RemoveUserDialogLayout, Cryo.Dictionary.join(v17, v28, v26, {
		onActivated = v27,
		displayFailed = v22,
		isModalVisible = v18,
		isLoading = v20
	}))
end

return memo(RemoveUserDialogContainer)
