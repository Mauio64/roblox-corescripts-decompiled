local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = Localization.Hooks.useLocalization

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local ChatPermissionsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/ChatPermissionsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FeedbackAction = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/FeedbackAction")
local UserFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/UserFeedback")
local feedbackIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/feedbackIcons")
local sendAgentTurnFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/sendAgentTurnFeedback")
local AgentRollbackSnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/AgentRollbackSnackbar")
local RestoreVersionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/RestoreVersionDialog")
local GetAgentRollbackRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentRollbackRequestStore")
local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")

local iconName = Foundation.Enums.IconName
local fFlagEnableTeamTestLua = SharedFlags.FFlagEnableTeamTestLua

local signal = Signals.createSignal(false)

local function useAgentMessageCopy(messageText)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		if messageText ~= nil and messageText ~= "" then
			default:setClipboardText({
				context = "Build-AgentMessage",
				text = messageText
			})
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

	return if state then iconName.CheckLarge else iconName.TwoStackedSquares, v5
end

local function AgentTurnFeedback(props)
	local v5

	if FFlagBuildCheckGamePermissions then
		local v6 = React.useContext(ChatPermissionsContext)
		v5 = not (v6 == nil) and not v6.canEditOnBuild
	else
		v5 = false
	end

	local turnFeedbackIds = props.turnFeedbackIds
	local placeId = if turnFeedbackIds ~= nil then turnFeedbackIds.placeId else nil
	local v6

	if turnFeedbackIds ~= nil then
		v6 = feedbackIcons.getRollbackTargetVersionNumber(turnFeedbackIds)
	end

	local v7 = React.useContext(Localization.LocalizationRoactContext)
	local v8 = useLocalization({
		revertConfirmationTitle = LocalizationStrings.CHAT_REVERT_CONFIRMATION_TITLE,
		revertConfirmationDescription = LocalizationStrings.CHAT_REVERT_CONFIRMATION_DESCRIPTION,
		revertFailure = LocalizationStrings.CHAT_REVERT_FAILURE
	})

	local revertFailure = v8.revertFailure
	local v9 = v8.revertConfirmationTitle
	local v10 = v8.revertConfirmationDescription

	if v6 ~= nil then
		local v11

		if v6 < 10 then
			v11 = LocalizationStrings.VERSION_HISTORY_VERSION_PADDED
		else
			v11 = LocalizationStrings.VERSION_HISTORY_VERSION_COMPACT
		end

		local formatted = v7:Format(v11, { VERSION_NUMBER = v6 })

		if fFlagEnableTeamTestLua then
			v10 = v7:Format(LocalizationStrings.CHAT_REVERT_TO_VERSION, { VERSION = formatted })
		else
			v9 = formatted
		end
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState("")

	local v11, v12 = useAgentMessageCopy(props.messageText)
	local v14 = React.useCallback(function(p2): boolean
		local v15 = GetPlaytestLoadingStore(p2)

		if placeId == nil then
			return false
		end

		return v15.getAgentStatusForPlaceId(placeId)(p2) == "Loading"
	end, { placeId })
	local v15 = SignalsReact.useSignalState(v14)
	local v16 = if placeId == nil then signal else GetAgentRollbackRequestStore(false).getIsPendingForPlaceId(placeId)

	local v17 = SignalsReact.useSignalState(v16)
	local v18 = React.useCallback(function()
		setState4("")
	end, {})
	local v19 = React.useCallback(function(p2)
		if turnFeedbackIds == nil then
			return
		end

		if p2.action == FeedbackAction.REVERT then
			setState(true)
			return
		end

		if p2.action == FeedbackAction.COPY then
			v12()
		else
			setState3(p2.action)
		end

		sendAgentTurnFeedback(p2.action, turnFeedbackIds)
	end, { turnFeedbackIds, v12 })

	if turnFeedbackIds == nil or turnFeedbackIds.sequenceId == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v21 = {
		Feedback = React.createElement(UserFeedback, {
			layoutOrder = props.LayoutOrder,
			icons = feedbackIcons.getFeedbackIcons({
				includeCopy = props.messageText ~= nil and props.messageText ~= "",
				copyIconName = v11,
				copyTestId = `{props.testId}-copy`,
				includeRevert = feedbackIcons.canRevert(turnFeedbackIds),
				isRevertDisabled = v15 or v17 or v5,
				isRatingDisabled = v5
			}),
			onActivated = v19,
			selectedAction = state3,
			testId = props.testId
		}),
		RevertSnackbar = 0,
		RevertDialog = 0
	}

	local v26 = if state4 ~= "" then React.createElement(AgentRollbackSnackbar, {
		title = state4,
		onClose = v18
	}) else nil
	v21.RevertSnackbar = v26
	local v27

	if state and v6 ~= nil then
		v27 = React.createElement(RestoreVersionDialog, {
			isOpen = true,
			isLoading = state2,
			title = v9,
			description = v10,
			onRestore = function()
				if v14(false) or v16(false) then
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

	v21.RevertDialog = v27
	return createElement(fragment, nil, v21)
end

return AgentTurnFeedback
