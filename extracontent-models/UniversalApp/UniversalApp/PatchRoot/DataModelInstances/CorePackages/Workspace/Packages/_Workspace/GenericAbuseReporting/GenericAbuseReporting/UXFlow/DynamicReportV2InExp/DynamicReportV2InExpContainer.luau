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

local function DynamicReportV2InExpContainer(t1: {[any]: any}) -- line: 59
	-- upvalues: React (copy), useIsVoiceChatReportable (copy), getIsInExpSceneSelectionAvailable (copy), useDynamicInExpConfig (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), useDeviceOrientation (copy), GuiService (copy), getUsers (copy), useInExpCustomSubmit (copy), sendBoundaryErrorTelemetry (copy), DynamicReportV2InExpError (copy), AbuseReportErrorBoundary (copy), AbuseReportContentInExp (copy)
	local preselectedPlayer = t1.preselectedPlayer
	local v19 = React.useMemo(function() -- line: 62
		return (tostring(game.GameId))
	end, {})
	local v20 = useIsVoiceChatReportable(t1.voiceChatServiceManager)
	local v21 = React.useMemo(function() -- line: 68
		-- upvalues: v19 (copy), v20 (copy), getIsInExpSceneSelectionAvailable (copy), preselectedPlayer (copy)
		local t2 = {
			experienceTargetId = v19,
			isVoiceChatReportable = v20,
			isSceneSelectionAvailable = getIsInExpSceneSelectionAvailable()
		}

		if preselectedPlayer then
			t2.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			t2.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			t2.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return t2
	end, {
		v19,
		preselectedPlayer,
		v20
	})
	local v22 = useDynamicInExpConfig(t1.isReportTabVisible, v21)
	local config = v22.config
	local hasError = v22.hasError
	local setHasError = v22.setHasError
	local abuseVector = v22.abuseVector
	local u27 = nil
	local u28 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		local v29, v30 = React.useState(nil)

		u27 = v29
		u28 = v30
	end

	local v31 = useDeviceOrientation()
	local v32 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v33 = v31 == "Landscape" or not v32
	local v34 = React.useMemo(function() -- line: 97
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
	local v35 = React.useRef(DateTime.now().UnixTimestampMillis)

	React.useEffect(function() -- line: 118
		-- upvalues: t1 (copy), v35 (copy)
		if t1.isReportTabVisible then
			v35.current = DateTime.now().UnixTimestampMillis
		end
	end, { t1.isReportTabVisible })

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		React.useEffect(function() -- line: 125
			-- upvalues: t1 (copy), u28 (ref)
			if not t1.isReportTabVisible and u28 then
				u28(nil)
			end
		end, {
			t1.isReportTabVisible,
			u28
		})
	end

	local v36 = useInExpCustomSubmit({
		voiceChatServiceManager = t1.voiceChatServiceManager,
		inExpChatMessagesLoader = t1.inExpChatMessagesLoader,
		menuOpenTimeRef = v35,
		reportAnythingSnapshotRef = t1.reportAnythingSnapshotRef
	})
	local v37 = React.useCallback(function() -- line: 141
		-- upvalues: setHasError (copy)
		setHasError(true)
	end, { setHasError })
	local v38 = React.useCallback(function(p1) -- line: 145
		-- upvalues: sendBoundaryErrorTelemetry (copy), abuseVector (copy), v19 (copy), setHasError (copy)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p1)
		sendBoundaryErrorTelemetry(p1, {
			abuse_vector = abuseVector,
			target_id = v19
		})
		setHasError(true)
	end, {
		abuseVector,
		v19,
		setHasError
	})
	local v39 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		v39 = React.useMemo(function() -- line: 156
			-- upvalues: u28 (ref), u27 (ref)
			if u28 then
				return {
					pendingInlineAlert = u27,
					setInlineAlert = u28
				}
			end

			return nil
		end, {
			u27,
			u28
		})
	end

	if t1.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	return if not t1.isReportTabVisible or (not config or hasError) then nil else React.createElement(AbuseReportErrorBoundary, {
		onError = v38
	}, {
		AbuseReportContentInExp = React.createElement(AbuseReportContentInExp, {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v19,
			onClose = t1.onClose,
			open = t1.isReportTabVisible,
			onCustomSubmit = v36,
			onFinish = t1.onReportFinish,
			onResolveError = v37,
			shouldUseOverlaidControls = v33,
			loaders = v34,
			attemptTrigger = not preselectedPlayer and "onFirstAction" or "onOpen",
			inlineAlertController = v39
		})
	})
end

return React.memo(DynamicReportV2InExpContainer)
