local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local GuiService = game:GetService("GuiService")
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReportingParent.RobloxAppEnums)

local useDeviceOrientation = require(GenericAbuseReportingParent.RobloxAppHooks).useDeviceOrientation
local AbuseReportErrorBoundary = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportErrorBoundary)
local getIsInExpSceneSelectionAvailable = require(GenericAbuseReporting.BeduiV2.Components.Nodes.getIsInExpSceneSelectionAvailable)
local getUsers = require(GenericAbuseReporting.BeduiV2.Loaders.getUsers)

require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)

local sendBoundaryErrorTelemetry = require(GenericAbuseReporting.BeduiV2.Analytics.sendBoundaryErrorTelemetry)
local useInExpCustomSubmit = require(GenericAbuseReporting.BeduiV2.Hooks.useInExpCustomSubmit).useInExpCustomSubmit

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)

local DynamicReportV2InExpError = require(script.Parent.DynamicReportV2InExpError)
local AbuseReportContentInExp = require(script.Parent.AbuseReportContentInExp)
local useDynamicInExpConfig = require(script.Parent.useDynamicInExpConfig).useDynamicInExpConfig

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)

local useIsVoiceChatReportable = require(script.Parent.useIsVoiceChatReportable).useIsVoiceChatReportable

require(GenericAbuseReporting.BeduiV2.Utils.appendReportAnythingTags)

local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)
local FFlagAbuseReportVoiceSpeakingIcon = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportVoiceSpeakingIcon
local FFlagAbuseReportVoiceMute = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportVoiceMute

local function DynamicReportV2InExpContainer(t1: {[any]: any}) -- line: 61
	-- upvalues: React (copy), useIsVoiceChatReportable (copy), getIsInExpSceneSelectionAvailable (copy), useDynamicInExpConfig (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), useDeviceOrientation (copy), GuiService (copy), getUsers (copy), useInExpCustomSubmit (copy), sendBoundaryErrorTelemetry (copy), DynamicReportV2InExpError (copy), AbuseReportErrorBoundary (copy), AbuseReportContentInExp (copy), FFlagAbuseReportVoiceSpeakingIcon (copy), FFlagAbuseReportVoiceMute (copy)
	local preselectedPlayer = t1.preselectedPlayer
	local v21 = React.useMemo(function() -- line: 64
		return (tostring(game.GameId))
	end, {})
	local v22 = useIsVoiceChatReportable(t1.voiceChatServiceManager)
	local v23 = React.useMemo(function() -- line: 70
		-- upvalues: v21 (copy), v22 (copy), getIsInExpSceneSelectionAvailable (copy), preselectedPlayer (copy)
		local t2 = {
			experienceTargetId = v21,
			isVoiceChatReportable = v22,
			isSceneSelectionAvailable = getIsInExpSceneSelectionAvailable()
		}

		if preselectedPlayer then
			t2.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			t2.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			t2.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return t2
	end, {
		v21,
		preselectedPlayer,
		v22
	})
	local v24 = useDynamicInExpConfig(t1.isReportTabVisible, v23)
	local config = v24.config
	local hasError = v24.hasError
	local setHasError = v24.setHasError
	local abuseVector = v24.abuseVector
	local u29 = nil
	local u30 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		local v31, v32 = React.useState(nil)

		u29 = v31
		u30 = v32
	end

	local v33 = useDeviceOrientation()
	local v34 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v35 = v33 == "Landscape" or not v34
	local v36 = React.useMemo(function() -- line: 99
		-- upvalues: getUsers (copy), t1 (copy)
		local t3 = {
			users = {
				type = "listItem",
				fetch = getUsers
			}
		}

		if t1.inExpChatMessagesLoader then
			t3.inExpChatMessages = t1.inExpChatMessagesLoader
		end

		if t1.inExpVoiceUsersLoader then
			t3.voiceUsers = t1.inExpVoiceUsersLoader
		end

		return t3
	end, {
		t1.inExpChatMessagesLoader,
		t1.inExpVoiceUsersLoader
	})
	local v37 = React.useRef(DateTime.now().UnixTimestampMillis)

	React.useEffect(function() -- line: 120
		-- upvalues: t1 (copy), v37 (copy)
		if t1.isReportTabVisible then
			v37.current = DateTime.now().UnixTimestampMillis
		end
	end, { t1.isReportTabVisible })

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		React.useEffect(function() -- line: 127
			-- upvalues: t1 (copy), u30 (ref)
			if not t1.isReportTabVisible and u30 then
				u30(nil)
			end
		end, {
			t1.isReportTabVisible,
			u30
		})
	end

	local v38 = useInExpCustomSubmit({
		voiceChatServiceManager = t1.voiceChatServiceManager,
		inExpChatMessagesLoader = t1.inExpChatMessagesLoader,
		menuOpenTimeRef = v37,
		reportAnythingSnapshotRef = t1.reportAnythingSnapshotRef
	})
	local v39 = React.useCallback(function() -- line: 143
		-- upvalues: setHasError (copy)
		setHasError(true)
	end, { setHasError })
	local v40 = React.useCallback(function(p1) -- line: 147
		-- upvalues: sendBoundaryErrorTelemetry (copy), abuseVector (copy), v21 (copy), setHasError (copy)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p1)
		sendBoundaryErrorTelemetry(p1, {
			abuse_vector = abuseVector,
			target_id = v21
		})
		setHasError(true)
	end, {
		abuseVector,
		v21,
		setHasError
	})
	local v41 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		v41 = React.useMemo(function() -- line: 158
			-- upvalues: u30 (ref), u29 (ref)
			if u30 then
				return {
					pendingInlineAlert = u29,
					setInlineAlert = u30
				}
			end

			return nil
		end, {
			u29,
			u30
		})
	end

	if t1.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	return if not t1.isReportTabVisible or (not config or hasError) then nil else React.createElement(AbuseReportErrorBoundary, {
		onError = v40
	}, {
		AbuseReportContentInExp = React.createElement(AbuseReportContentInExp, {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v21,
			onClose = t1.onClose,
			open = t1.isReportTabVisible,
			onCustomSubmit = v38,
			onFinish = t1.onReportFinish,
			onResolveError = v39,
			shouldUseOverlaidControls = v35,
			loaders = v36,
			attemptTrigger = not preselectedPlayer and "onFirstAction" or "onOpen",
			inlineAlertController = v41,
			voiceChatServiceManager = if not FFlagAbuseReportVoiceSpeakingIcon and not FFlagAbuseReportVoiceMute then nil else t1.voiceChatServiceManager
		})
	})
end

return React.memo(DynamicReportV2InExpContainer)
