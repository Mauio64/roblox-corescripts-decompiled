local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local ChatPermissionsContext = require(BuildExperience.Chat.ChatPermissionsContext)
require(BuildExperience.Chat.chatTypes)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FeedbackAction = require(BuildExperience.Components.MessageUtilities.FeedbackAction)
local UserFeedback = require(BuildExperience.Components.MessageUtilities.UserFeedback)
local feedbackIcons = require(BuildExperience.Components.MessageUtilities.feedbackIcons)
local sendAgentTurnFeedback = require(BuildExperience.Components.MessageUtilities.sendAgentTurnFeedback)
local AgentRollbackSnackbar = require(BuildExperience.Components.VersionHistory.AgentRollbackSnackbar)
local RestoreVersionDialog = require(BuildExperience.Components.VersionHistory.RestoreVersionDialog)
local GetAgentRollbackRequestStore = require(BuildExperience.Stores.GetAgentRollbackRequestStore)
local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)

local IconName = Foundation.Enums.IconName
local FFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local signal = Signals.createSignal(false)

local function useAgentMessageCopy(messageText: string?)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v = React.useCallback(function()
		if messageText ~= nil and messageText ~= "" then
			default:setClipboardText({ context = "Build-AgentMessage", text = messageText })
		end

		setState(true)

		if ref.current ~= nil then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState(false)
		end)
	end, { messageText })

	React.useEffect(function()
		return function()
			if ref.current ~= nil then
				task.cancel(ref.current)
			end
		end
	end, {})
	local v2

	if state then
		v2 = IconName.CheckLarge
	else
		v2 = IconName.TwoStackedSquares
	end

	return v2, v
end

local function AgentTurnFeedback(props)
	local isRatingDisabled

	if FFlagBuildCheckGamePermissions then
		local v = React.useContext(ChatPermissionsContext)

		if v == nil then
			isRatingDisabled = false
		else
			isRatingDisabled = not v.canEditOnBuild
		end
	else
		isRatingDisabled = false
	end

	local turnFeedbackIds = props.turnFeedbackIds
	local placeId

	if turnFeedbackIds == nil then
		placeId = nil
	else
		placeId = turnFeedbackIds.placeId
	end

	local v

	if turnFeedbackIds ~= nil then
		v = feedbackIcons.getRollbackTargetVersionNumber(turnFeedbackIds)
	end

	local v2 = React.useContext(Localization.LocalizationRoactContext)
	local v3 = useLocalization({
		revertConfirmationTitle = LocalizationStrings.CHAT_REVERT_CONFIRMATION_TITLE,
		revertConfirmationDescription = LocalizationStrings.CHAT_REVERT_CONFIRMATION_DESCRIPTION,
		revertFailure = LocalizationStrings.CHAT_REVERT_FAILURE
	})

	local revertFailure = v3.revertFailure
	local title = v3.revertConfirmationTitle
	local description = v3.revertConfirmationDescription

	if v ~= nil then
		local v4

		if v < 10 then
			v4 = LocalizationStrings.VERSION_HISTORY_VERSION_PADDED
		else
			v4 = LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
		end

		local formatted = v2:Format(v4, { VERSION_NUMBER = v })

		if FFlagEnableTeamTestLua then
			description = v2:Format(LocalizationStrings.CHAT_REVERT_TO_VERSION, {
				VERSION = formatted
			})
		else
			title = formatted
		end
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState("")

	local copyIconName, v4 = useAgentMessageCopy(props.messageText)
	local v5 = React.useCallback(function(p): boolean
		local playtestLoadingStore = GetPlaytestLoadingStore(p)

		return placeId ~= nil and playtestLoadingStore.getAgentStatusForPlaceId(placeId)(p) == "Loading"
	end, { placeId })
	local v6 = SignalsReact.useSignalState(v5)
	local v7

	if placeId == nil then
		v7 = signal
	else
		v7 = GetAgentRollbackRequestStore(false).getIsPendingForPlaceId(placeId)
	end

	local v8 = SignalsReact.useSignalState(v7)
	local onClose = React.useCallback(function()
		setState4("")
	end, {})
	local onActivated = React.useCallback(function(p)
		if turnFeedbackIds == nil then
			return
		end

		if p.action == FeedbackAction.REVERT then
			setState(true)
			return
		end

		if p.action == FeedbackAction.COPY then
			v4()
		else
			setState3(p.action)
		end

		sendAgentTurnFeedback(p.action, turnFeedbackIds)
	end, { turnFeedbackIds, v4 })

	if turnFeedbackIds == nil or turnFeedbackIds.sequenceId == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v9 = {
		Feedback = React.createElement(UserFeedback, {
			layoutOrder = props.LayoutOrder,
			icons = feedbackIcons.getFeedbackIcons({
				includeCopy = props.messageText ~= nil and props.messageText ~= "",
				copyIconName = copyIconName,
				copyTestId = `{props.testId}-copy`,
				includeRevert = feedbackIcons.canRevert(turnFeedbackIds),
				isRevertDisabled = v6 or v8 or isRatingDisabled,
				isRatingDisabled = isRatingDisabled
			}),
			onActivated = onActivated,
			selectedAction = state3,
			testId = props.testId
		}),
		RevertSnackbar = 0,
		RevertDialog = 0
	}
	local revertSnackbar

	if state4 ~= "" then
		revertSnackbar = React.createElement(AgentRollbackSnackbar, {
			title = state4,
			onClose = onClose
		})
	end

	v9.RevertSnackbar = revertSnackbar
	local revertDialog

	if state and v ~= nil then
		revertDialog = React.createElement(RestoreVersionDialog, {
			isOpen = true,
			isLoading = state2,
			title = title,
			description = description,
			onRestore = function()
				if v5(false) or v7(false) then
					return
				end

				setState3(FeedbackAction.REVERT)
				sendAgentTurnFeedback(FeedbackAction.REVERT, turnFeedbackIds)
				setState2(true)

				setState4("")

				feedbackIcons.requestAgentRollback(turnFeedbackIds):andThen(function()
					setState2(false)
					setState(false)
				end):catch(function()
					setState2(false)
					setState4(revertFailure)
				end)
			end,
			onCancel = function()
				setState(false)
			end
		})
	end

	v9.RevertDialog = revertDialog
	return createElement(fragment, nil, v9)
end

return AgentTurnFeedback
