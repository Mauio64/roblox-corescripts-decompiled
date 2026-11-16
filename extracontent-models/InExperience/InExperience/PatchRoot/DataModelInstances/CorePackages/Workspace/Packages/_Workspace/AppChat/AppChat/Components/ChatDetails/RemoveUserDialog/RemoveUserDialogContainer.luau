local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local populateUserWithState = require(AppChat.Users.populateUserWithState)
require(AppChat.types)

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local useState = React.useState

local RemoveUserDialogLayout = require(script.Parent.RemoveUserDialogLayout)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local v = {
	participantId = nil,
	onModalClose = function() end,
	titleKey = "Feature.Chat.Action.RemoveUser",
	messageKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.RemoveUser.V2" or "Feature.Chat.Message.RemoveUser",
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Remove",
	failureTitleKey = "Feature.Chat.Heading.FailedToRemoveUser",
	failureBodyKey = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRemoveUser.V2" or "Feature.Chat.Message.FailedToRemoveUser",
	failureButtonKey = "Feature.Chat.Action.Confirm"
}

function RemoveUserDialogContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local state, setState = useState(true)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)

	local v2 = useDispatch()
	local v3 = useCallback(function(p2, p3)
		return v2(AppChatNetworking.rodux.RemoveUserFromConversation.API(p3, p2))
	end, { v2 })

	local v4 = useSelector(function(p2)
		local v4 = p2.ChatAppReducer.Conversations[joined.conversationId] or { title = nil }

		local user = p2.Users[joined.participantId]

		return {
			conversationTitle = v4.title,
			targetUser = populateUserWithState(p2, user)
		}
	end)

	local onActivated = useCallback(function(): boolean
		setState2(true)
		setState(false)

		local conversationId = joined.conversationId

		if conversationId then
			v3(joined.participantId, conversationId):andThen(function()
				joined.onModalClose()
			end):catch(function()
				setState2(false)
				setState(true)
				setState3(true)
			end)
		end

		return true
	end, { joined.participantId, joined.conversationId })

	local v5 = useLocalization({
		titleText = joined.titleKey,
		bodyText = {
			joined.messageKey,
			USERNAME = v4.targetUser.displayName
		},
		cancelText = joined.cancelTitleKey,
		confirmText = joined.confirmationTitleKey,
		failureTitleText = "Feature.Chat.Heading.FailedToRemoveUser",
		failureBodyText = {
			joined.failureBodyKey,
			USERNAME = v4.targetUser.displayName,
			CONVERSATION_TITLE = v4.conversationTitle
		},
		failureButtonText = "Feature.Chat.Action.Confirm"
	})

	return React.createElement(
		RemoveUserDialogLayout,
		Cryo.Dictionary.join(joined, v5, v4, {
			onActivated = onActivated,
			displayFailed = state3,
			isModalVisible = state,
			isLoading = state2
		})
	)
end

return memo(RemoveUserDialogContainer)
