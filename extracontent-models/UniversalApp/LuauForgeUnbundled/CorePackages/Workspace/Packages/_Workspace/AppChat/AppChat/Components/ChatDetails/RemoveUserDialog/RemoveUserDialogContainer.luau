local populateUserWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/populateUserWithState")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useState = React.useState

local RemoveUserDialogLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/RemoveUserDialogLayout")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled

local v5 = {
	participantId = nil,
	onModalClose = function() end,
	titleKey = "Feature.Chat.Action.RemoveUser",
	messageKey = getFFlagIsSquadEnabled() and "Feature.Chat.Message.RemoveUser.V2" or "Feature.Chat.Message.RemoveUser",
	cancelTitleKey = "Feature.Chat.Action.Cancel",
	confirmationTitleKey = "Feature.Chat.Action.Remove",
	failureTitleKey = "Feature.Chat.Heading.FailedToRemoveUser",
	failureBodyKey = getFFlagIsSquadEnabled() and "Feature.Chat.Message.FailedToRemoveUser.V2" or "Feature.Chat.Message.FailedToRemoveUser",
	failureButtonKey = "Feature.Chat.Action.Confirm"
}

function LUAUFORGE_MODULE_GLOBALS_hpg_RemoveUserDialogContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local state, setState = useState(true)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)

	local v6 = useDispatch()
	local v7 = useCallback(function(p3, p4)
		return v6(AppChatNetworking.rodux.RemoveUserFromConversation.API(p4, p3))
	end, { v6 })

	local v8 = useSelector(function(p3)
		local v9 = p3.ChatAppReducer.Conversations[joined.conversationId] or {
			title = nil
		}

		local user = p3.Users[joined.participantId]

		return { conversationTitle = v9.title, targetUser = populateUserWithState(p3, user) }
	end)

	local v9 = useCallback(function(): boolean
		setState2(true)
		setState(false)

		local conversationId = joined.conversationId

		if conversationId then
			v7(joined.participantId, conversationId):andThen(function()
				joined.onModalClose()
			end):catch(function()
				setState2(false)
				setState(true)
				setState3(true)
			end)
		end

		return true
	end, { joined.participantId, joined.conversationId })

	local v10 = useLocalization({
		titleText = joined.titleKey,
		bodyText = {
			joined.messageKey,
			USERNAME = v8.targetUser.displayName
		},
		cancelText = joined.cancelTitleKey,
		confirmText = joined.confirmationTitleKey,
		failureTitleText = "Feature.Chat.Heading.FailedToRemoveUser",
		failureBodyText = {
			joined.failureBodyKey,
			USERNAME = v8.targetUser.displayName,
			CONVERSATION_TITLE = v8.conversationTitle
		},
		failureButtonText = "Feature.Chat.Action.Confirm"
	})

	return React.createElement(
		RemoveUserDialogLayout,
		Cryo.Dictionary.join(joined, v10, v8, {
			onActivated = v9,
			displayFailed = state3,
			isModalVisible = state,
			isLoading = state2
		})
	)
end

return memo(LUAUFORGE_MODULE_GLOBALS_hpg_RemoveUserDialogContainer)
