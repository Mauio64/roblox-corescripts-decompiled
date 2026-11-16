local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local GuiService = game:GetService("GuiService")

local React = require(parent.React)

require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local InlineEventType = require(parent.OnPlatformSurveys.InlineEventType)
local InlineSurvey = require(parent.OnPlatformSurveys.InlineSurvey)
local InlineSurveyPreset = require(parent.OnPlatformSurveys.InlineSurveyPreset)

local AbuseReportErrorBoundary = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportErrorBoundary)
local getIsInExpSceneSelectionAvailable = require(GenericAbuseReporting.BeduiV2.Components.Nodes.getIsInExpSceneSelectionAvailable)
local getUsers = require(GenericAbuseReporting.BeduiV2.Loaders.getUsers)
require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)
local sendBoundaryErrorTelemetry = require(GenericAbuseReporting.BeduiV2.Analytics.sendBoundaryErrorTelemetry)
local useInExpCustomSubmit = require(GenericAbuseReporting.BeduiV2.Hooks.useInExpCustomSubmit)
local useInExpCustomSubmit2 = useInExpCustomSubmit.useInExpCustomSubmit
local useInExpClientActionHandlers = useInExpCustomSubmit.useInExpClientActionHandlers

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)
local DynamicReportV2InExpError = require(script.Parent.DynamicReportV2InExpError)
local DynamicReportV2InExpLoading = require(script.Parent.DynamicReportV2InExpLoading)
local AbuseReportContentInExp = require(script.Parent.AbuseReportContentInExp)
local useDynamicInExpConfig = require(script.Parent.useDynamicInExpConfig)
local useDynamicInExpConfig2 = useDynamicInExpConfig.useDynamicInExpConfig
local useInExpConfigLoadingSkeleton = require(script.Parent.useInExpConfigLoadingSkeleton)
local useInExpConfigLoadingSkeleton2 = useInExpConfigLoadingSkeleton.useInExpConfigLoadingSkeleton
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)
local useIsVoiceChatReportable = require(script.Parent.useIsVoiceChatReportable)
local useIsVoiceChatReportable2 = useIsVoiceChatReportable.useIsVoiceChatReportable
require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)

local FFlagAbuseReportInExpShowConfigLoadingSkeleton = require(GenericAbuseReporting.Flags.FFlagAbuseReportInExpShowConfigLoadingSkeleton)
local FFlagInlineSurveyOnInExpReport = require(GenericAbuseReporting.Flags.FFlagInlineSurveyOnInExpReport)
local SharedFlags = require(parent.SharedFlags)
local FFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAbuseReportSubmissionTargetV4 = SharedFlags2.FFlagAbuseReportSubmissionTargetV4
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAbuseReportVoiceMute = SharedFlags3.FFlagAbuseReportVoiceMute

local function DynamicReportV2InExpContainer(props)
	local preselectedPlayer = props.preselectedPlayer

	local v = React.useMemo(function()
		return (tostring(game.GameId))
	end, {})

	local isVoiceChatReportable = useIsVoiceChatReportable2(props.voiceChatServiceManager)

	local isSceneSelectionAvailable = React.useMemo(function()
		return props.isReportTabVisible and getIsInExpSceneSelectionAvailable()
	end, { props.isReportTabVisible })

	local v2 = React.useMemo(function()
		local v2 = {
			experienceTargetId = v,
			isVoiceChatReportable = isVoiceChatReportable,
			isSceneSelectionAvailable = isSceneSelectionAvailable
		}

		if preselectedPlayer then
			v2.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			v2.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			v2.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return v2
	end, { v, preselectedPlayer, isVoiceChatReportable, isSceneSelectionAvailable })

	local v3 = useDynamicInExpConfig2(props.isReportTabVisible, v2)
	local config = v3.config
	local hasError = v3.hasError
	local setHasError = v3.setHasError
	local abuseVector = v3.abuseVector

	local state, setState = React.useState(nil)

	local v4 = useDeviceOrientation()
	local v5 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local shouldUseOverlaidControls = v4 == "Landscape" or not v5
	local v6 = props.isReportTabVisible

	if v6 then
		if config == nil then
			v6 = not hasError
		else
			v6 = false
		end
	end

	local v7

	if FFlagAbuseReportInExpShowConfigLoadingSkeleton then
		v7 = useInExpConfigLoadingSkeleton2(props.isReportTabVisible, v6)
	else
		v7 = false
	end

	local loaders = React.useMemo(function()
		local v8 = {
			users = { type = "listItem", fetch = getUsers }
		}

		if props.inExpChatMessagesLoader then
			v8.inExpChatMessages = props.inExpChatMessagesLoader
		end

		if props.inExpVoiceUsersLoader then
			v8.voiceUsers = props.inExpVoiceUsersLoader
		end

		return v8
	end, { props.inExpChatMessagesLoader, props.inExpVoiceUsersLoader })

	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	React.useEffect(function()
		if props.isReportTabVisible then
			ref.current = DateTime.now().UnixTimestampMillis
		end
	end, { props.isReportTabVisible })

	if FFlagAbuseReportInExpPlayerListV3 then
		React.useEffect(function()
			recentlyLeftSignals.init()
		end, {})
	end

	React.useEffect(function()
		if not props.isReportTabVisible then
			setState(nil)
		end
	end, { props.isReportTabVisible, setState })

	local v8 = {
		voiceChatServiceManager = props.voiceChatServiceManager,
		inExpChatMessagesLoader = props.inExpChatMessagesLoader,
		menuOpenTimeRef = ref,
		reportAnythingSnapshotRef = props.reportAnythingSnapshotRef
	}

	local onCustomSubmit = nil
	local clientActionHandlers = nil

	if FFlagAbuseReportSubmissionTargetV4 then
		clientActionHandlers = useInExpClientActionHandlers(v8)
	else
		onCustomSubmit = useInExpCustomSubmit2(v8)
	end

	local state2 = nil
	local v9 = nil
	local onFinish, onClose

	if FFlagInlineSurveyOnInExpReport then
		local setState2
		state2, setState2 = React.useState(false)
		v9 = setState2

		local onReportFinish = props.onReportFinish
		onFinish = React.useCallback(function(p)
			if p.didSubmit and v9 then
				v9(true)
			end

			if onReportFinish then
				onReportFinish(p)
			end
		end, { onReportFinish, v9 })

		onClose = React.useCallback(function()
			if v9 then
				v9(false)
			end
		end, { v9 })
	end

	local onResolveError = React.useCallback(function()
		setHasError(true)
	end, { setHasError })

	local onError = React.useCallback(function(p)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p)
		sendBoundaryErrorTelemetry(p, { abuse_vector = abuseVector, target_id = v })

		setHasError(true)
	end, { abuseVector, v, setHasError })

	local inlineAlertController = React.useMemo(function()
		return { pendingInlineAlert = state, setInlineAlert = setState }
	end, { state, setState })

	if v7 then
		return React.createElement(DynamicReportV2InExpLoading, {
			shouldUseOverlaidControls = shouldUseOverlaidControls
		})
	end

	if props.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	local survey

	if FFlagInlineSurveyOnInExpReport and state2 then
		survey = React.createElement(InlineSurvey, {
			eventType = InlineEventType.InExperienceReportButtonClicked,
			preset = InlineSurveyPreset.ModalInviteToModalSurvey,
			onClose = onClose
		})
	end

	local content

	if props.isReportTabVisible and config and not hasError then
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v10 = {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v,
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

		if FFlagAbuseReportSubmissionTargetV4 then
			onCustomSubmit = nil
		end

		v10.onCustomSubmit = onCustomSubmit

		if not FFlagAbuseReportSubmissionTargetV4 then
			clientActionHandlers = nil
		end

		v10.clientActionHandlers = clientActionHandlers

		if not FFlagInlineSurveyOnInExpReport then
			onFinish = props.onReportFinish
		end

		v10.onFinish = onFinish
		v10.onResolveError = onResolveError
		v10.shouldUseOverlaidControls = shouldUseOverlaidControls
		v10.loaders = loaders
		v10.attemptTrigger = preselectedPlayer and "onOpen" or "onFirstAction"
		v10.inlineAlertController = inlineAlertController
		local voiceChatServiceManager

		if FFlagAbuseReportInExpPlayerListV3 or FFlagAbuseReportVoiceMute then
			voiceChatServiceManager = props.voiceChatServiceManager
		end

		v10.voiceChatServiceManager = voiceChatServiceManager
		content = createElement(AbuseReportErrorBoundary, { onError = onError }, {
			AbuseReportContentInExp = createElement2(AbuseReportContentInExp, v10)
		})
	end

	if not FFlagInlineSurveyOnInExpReport then
		return content
	end

	if content == nil and survey == nil then
		return nil
	end

	return React.createElement(React.Fragment, nil, { Content = content, Survey = survey })
end

return React.memo(DynamicReportV2InExpContainer)
