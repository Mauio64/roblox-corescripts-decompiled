local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppEnums")
local useDeviceOrientation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useDeviceOrientation

local InlineEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/InlineEventType")
local InlineSurvey = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/InlineSurvey")
local InlineSurveyPreset = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/InlineSurveyPreset")

local AbuseReportErrorBoundary = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportErrorBoundary")
local getIsInExpSceneSelectionAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/getIsInExpSceneSelectionAvailable")
local getUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/getUsers")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/LoaderContext")
local recentlyLeftSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/recentlyLeftSignals")
local sendBoundaryErrorTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/sendBoundaryErrorTelemetry")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useInExpCustomSubmit")
local useInExpCustomSubmit = module10.useInExpCustomSubmit
local useInExpClientActionHandlers = module10.useInExpClientActionHandlers

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/fetchConfigWithAttributes")
local DynamicReportV2InExpError = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/DynamicReportV2InExpError")
local DynamicReportV2InExpLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/DynamicReportV2InExpLoading")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/AbuseReportContentInExp")
local useDynamicInExpConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/useDynamicInExpConfig").useDynamicInExpConfig
local useInExpConfigLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/useInExpConfigLoadingSkeleton").useInExpConfigLoadingSkeleton
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/useAbuseSheetFlow")
local useIsVoiceChatReportable = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2InExp/useIsVoiceChatReportable").useIsVoiceChatReportable
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/appendReportAnythingTags")

local FFlagAbuseReportInExpShowConfigLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportInExpShowConfigLoadingSkeleton")
local FFlagInlineSurveyOnInExpReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagInlineSurveyOnInExpReport")
local fFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportInExpPlayerListV3
local fFlagAbuseReportSubmissionTargetV4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportSubmissionTargetV4
local fFlagAbuseReportVoiceMute = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportVoiceMute

local function DynamicReportV2InExpContainer(props)
	local preselectedPlayer = props.preselectedPlayer

	local v5 = React.useMemo(function()
		return (tostring(game.GameId))
	end, {})

	local v6 = useIsVoiceChatReportable(props.voiceChatServiceManager)

	local v7 = React.useMemo(function()
		return props.isReportTabVisible and getIsInExpSceneSelectionAvailable()
	end, { props.isReportTabVisible })

	local v8 = React.useMemo(function()
		local v9 = {
			experienceTargetId = v5,
			isVoiceChatReportable = v6,
			isSceneSelectionAvailable = v7
		}

		if preselectedPlayer then
			v9.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			v9.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			v9.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return v9
	end, { v5, preselectedPlayer, v6, v7 })

	local v9 = useDynamicInExpConfig(props.isReportTabVisible, v8)
	local config = v9.config
	local hasError = v9.hasError
	local setHasError = v9.setHasError
	local abuseVector = v9.abuseVector

	local state, setState = React.useState(nil)

	local v10 = useDeviceOrientation()
	local v11 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v12 = v10 == "Landscape" or not v11
	local v13 = props.isReportTabVisible

	if v13 then
		v13 = config == nil and not hasError
	end

	local v14 = if FFlagAbuseReportInExpShowConfigLoadingSkeleton then useInExpConfigLoadingSkeleton(props.isReportTabVisible, v13) else false

	local v15 = React.useMemo(function()
		local v16 = {
			users = { type = "listItem", fetch = getUsers }
		}

		if props.inExpChatMessagesLoader then
			v16.inExpChatMessages = props.inExpChatMessagesLoader
		end

		if props.inExpVoiceUsersLoader then
			v16.voiceUsers = props.inExpVoiceUsersLoader
		end

		return v16
	end, { props.inExpChatMessagesLoader, props.inExpVoiceUsersLoader })

	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	React.useEffect(function()
		if props.isReportTabVisible then
			ref.current = DateTime.now().UnixTimestampMillis
		end
	end, { props.isReportTabVisible })

	if fFlagAbuseReportInExpPlayerListV3 then
		React.useEffect(function()
			recentlyLeftSignals.init()
		end, {})
	end

	React.useEffect(function()
		if not props.isReportTabVisible then
			setState(nil)
		end
	end, { props.isReportTabVisible, setState })

	local v16 = {
		voiceChatServiceManager = props.voiceChatServiceManager,
		inExpChatMessagesLoader = props.inExpChatMessagesLoader,
		menuOpenTimeRef = ref,
		reportAnythingSnapshotRef = props.reportAnythingSnapshotRef
	}

	local v17 = nil
	local v18 = nil

	if fFlagAbuseReportSubmissionTargetV4 then
		v18 = useInExpClientActionHandlers(v16)
	else
		v17 = useInExpCustomSubmit(v16)
	end

	local state2 = nil
	local v19 = nil
	local v20, v21

	if FFlagInlineSurveyOnInExpReport then
		local setState2
		state2, setState2 = React.useState(false)
		v19 = setState2

		local onReportFinish = props.onReportFinish
		v20 = React.useCallback(function(p2)
			if p2.didSubmit and v19 then
				v19(true)
			end

			if onReportFinish then
				onReportFinish(p2)
			end
		end, { onReportFinish, v19 })

		v21 = React.useCallback(function()
			if v19 then
				v19(false)
			end
		end, { v19 })
	end

	local v22 = React.useCallback(function()
		setHasError(true)
	end, { setHasError })

	local v23 = React.useCallback(function(p2)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p2)
		sendBoundaryErrorTelemetry(p2, { abuse_vector = abuseVector, target_id = v5 })

		setHasError(true)
	end, { abuseVector, v5, setHasError })

	local v24 = React.useMemo(function()
		return { pendingInlineAlert = state, setInlineAlert = setState }
	end, { state, setState })

	if v14 then
		return React.createElement(DynamicReportV2InExpLoading, { shouldUseOverlaidControls = v12 })
	end

	if props.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	local v25

	if FFlagInlineSurveyOnInExpReport and state2 then
		v25 = React.createElement(InlineSurvey, {
			eventType = InlineEventType.InExperienceReportButtonClicked,
			preset = InlineSurveyPreset.ModalInviteToModalSurvey,
			onClose = v21
		})
	end

	local v26

	if props.isReportTabVisible and config and not hasError then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v31 = {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v5,
			onClose = props.onClose,
			onCustomSubmit = 0,
			clientActionHandlers = 0,
			onFinish = 0,
			onResolveError = 0,
			shouldUseOverlaidControls = 0,
			loaders = 0,
			attemptTrigger = 0,
			inlineAlertController = 0,
			voiceChatServiceManager = 0
		}

		if fFlagAbuseReportSubmissionTargetV4 then
			v17 = nil
		end

		v31.onCustomSubmit = v17

		if not fFlagAbuseReportSubmissionTargetV4 then
			v18 = nil
		end

		v31.clientActionHandlers = v18

		if not FFlagInlineSurveyOnInExpReport then
			v20 = props.onReportFinish
		end

		v31.onFinish = v20
		v31.onResolveError = v22
		v31.shouldUseOverlaidControls = v12
		v31.loaders = v15
		v31.attemptTrigger = preselectedPlayer and "onOpen" or "onFirstAction"
		v31.inlineAlertController = v24

		local v32 = if fFlagAbuseReportInExpPlayerListV3 or fFlagAbuseReportVoiceMute then props.voiceChatServiceManager else nil
		v31.voiceChatServiceManager = v32
		v26 = createElement(AbuseReportErrorBoundary, { onError = v23 }, {
			AbuseReportContentInExp = createElement2(module13, v31)
		})
	end

	if not FFlagInlineSurveyOnInExpReport then
		return v26
	end

	if v26 == nil and v25 == nil then
		return nil
	end

	return React.createElement(React.Fragment, nil, { Content = v26, Survey = v25 })
end

return React.memo(DynamicReportV2InExpContainer)
