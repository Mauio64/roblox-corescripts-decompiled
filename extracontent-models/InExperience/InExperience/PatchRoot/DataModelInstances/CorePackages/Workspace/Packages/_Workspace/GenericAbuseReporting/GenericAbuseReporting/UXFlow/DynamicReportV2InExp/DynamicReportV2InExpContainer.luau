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

local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)
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

local FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen = require(GenericAbuseReporting.Flags.FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen)
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)
local FFlagAbuseReportInExpPlayerListV3 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportVoiceMute = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportVoiceMute

local function DynamicReportV2InExpContainer(t1: {[any]: any}) -- line: 65
	-- upvalues: React (copy), useIsVoiceChatReportable (copy), FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen (copy), getIsInExpSceneSelectionAvailable (copy), useDynamicInExpConfig (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), useDeviceOrientation (copy), GuiService (copy), getUsers (copy), FFlagAbuseReportInExpPlayerListV3 (copy), recentlyLeftSignals (copy), useInExpCustomSubmit (copy), sendBoundaryErrorTelemetry (copy), DynamicReportV2InExpError (copy), AbuseReportErrorBoundary (copy), AbuseReportContentInExp (copy), FFlagAbuseReportVoiceMute (copy)
	local preselectedPlayer = t1.preselectedPlayer
	local v23 = React.useMemo(function() -- line: 68
		return (tostring(game.GameId))
	end, {})
	local v24 = useIsVoiceChatReportable(t1.voiceChatServiceManager)
	local u25 = nil

	if FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen then
		u25 = React.useMemo(function() -- line: 79
			-- upvalues: t1 (copy), getIsInExpSceneSelectionAvailable (copy)
			return t1.isReportTabVisible and getIsInExpSceneSelectionAvailable()
		end, { t1.isReportTabVisible })
	end

	local v26 = React.useMemo(function() -- line: 84
		-- upvalues: v23 (copy), v24 (copy), FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen (copy), u25 (ref), getIsInExpSceneSelectionAvailable (copy), preselectedPlayer (copy)
		local t2 = {
			experienceTargetId = v23,
			isVoiceChatReportable = v24,
			isSceneSelectionAvailable = if not FFlagAbuseReportCheckSceneSelectionAvailabilityOnOpen then getIsInExpSceneSelectionAvailable() else u25
		}

		if preselectedPlayer then
			t2.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			t2.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			t2.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return t2
	end, {
		v23,
		preselectedPlayer,
		v24,
		u25
	})
	local v27 = useDynamicInExpConfig(t1.isReportTabVisible, v26)
	local config = v27.config
	local hasError = v27.hasError
	local setHasError = v27.setHasError
	local abuseVector = v27.abuseVector
	local u32 = nil
	local u33 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		local v34, v35 = React.useState(nil)

		u32 = v34
		u33 = v35
	end

	local v36 = useDeviceOrientation()
	local v37 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v38 = v36 == "Landscape" or not v37
	local v39 = React.useMemo(function() -- line: 115
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
	local v40 = React.useRef(DateTime.now().UnixTimestampMillis)

	React.useEffect(function() -- line: 136
		-- upvalues: t1 (copy), v40 (copy)
		if t1.isReportTabVisible then
			v40.current = DateTime.now().UnixTimestampMillis
		end
	end, { t1.isReportTabVisible })

	if FFlagAbuseReportInExpPlayerListV3 then
		React.useEffect(function() -- line: 148
			-- upvalues: recentlyLeftSignals (copy)
			recentlyLeftSignals.init()
		end, {})
	end

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		React.useEffect(function() -- line: 154
			-- upvalues: t1 (copy), u33 (ref)
			if not t1.isReportTabVisible and u33 then
				u33(nil)
			end
		end, {
			t1.isReportTabVisible,
			u33
		})
	end

	local v41 = useInExpCustomSubmit({
		voiceChatServiceManager = t1.voiceChatServiceManager,
		inExpChatMessagesLoader = t1.inExpChatMessagesLoader,
		menuOpenTimeRef = v40,
		reportAnythingSnapshotRef = t1.reportAnythingSnapshotRef
	})
	local v42 = React.useCallback(function() -- line: 170
		-- upvalues: setHasError (copy)
		setHasError(true)
	end, { setHasError })
	local v43 = React.useCallback(function(p1) -- line: 174
		-- upvalues: sendBoundaryErrorTelemetry (copy), abuseVector (copy), v23 (copy), setHasError (copy)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p1)
		sendBoundaryErrorTelemetry(p1, {
			abuse_vector = abuseVector,
			target_id = v23
		})
		setHasError(true)
	end, {
		abuseVector,
		v23,
		setHasError
	})
	local v44 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		v44 = React.useMemo(function() -- line: 185
			-- upvalues: u33 (ref), u32 (ref)
			if u33 then
				return {
					pendingInlineAlert = u32,
					setInlineAlert = u33
				}
			end

			return nil
		end, {
			u32,
			u33
		})
	end

	if t1.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	return if not t1.isReportTabVisible or (not config or hasError) then nil else React.createElement(AbuseReportErrorBoundary, {
		onError = v43
	}, {
		AbuseReportContentInExp = React.createElement(AbuseReportContentInExp, {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v23,
			onClose = t1.onClose,
			open = t1.isReportTabVisible,
			onCustomSubmit = v41,
			onFinish = t1.onReportFinish,
			onResolveError = v42,
			shouldUseOverlaidControls = v38,
			loaders = v39,
			attemptTrigger = not preselectedPlayer and "onFirstAction" or "onOpen",
			inlineAlertController = v44,
			voiceChatServiceManager = if not FFlagAbuseReportInExpPlayerListV3 and not FFlagAbuseReportVoiceMute then nil else t1.voiceChatServiceManager
		})
	})
end

return React.memo(DynamicReportV2InExpContainer)
