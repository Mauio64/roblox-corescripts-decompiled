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

local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)
local FFlagAbuseReportInExpPlayerListV3 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportVoiceMute = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportVoiceMute

local function DynamicReportV2InExpContainer(t1: {[any]: any}) -- line: 63
	-- upvalues: React (copy), useIsVoiceChatReportable (copy), getIsInExpSceneSelectionAvailable (copy), useDynamicInExpConfig (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), useDeviceOrientation (copy), GuiService (copy), getUsers (copy), FFlagAbuseReportInExpPlayerListV3 (copy), recentlyLeftSignals (copy), useInExpCustomSubmit (copy), sendBoundaryErrorTelemetry (copy), DynamicReportV2InExpError (copy), AbuseReportErrorBoundary (copy), AbuseReportContentInExp (copy), FFlagAbuseReportVoiceMute (copy)
	local preselectedPlayer = t1.preselectedPlayer
	local v22 = React.useMemo(function() -- line: 66
		return (tostring(game.GameId))
	end, {})
	local v23 = useIsVoiceChatReportable(t1.voiceChatServiceManager)
	local v24 = React.useMemo(function() -- line: 72
		-- upvalues: v22 (copy), v23 (copy), getIsInExpSceneSelectionAvailable (copy), preselectedPlayer (copy)
		local t2 = {
			experienceTargetId = v22,
			isVoiceChatReportable = v23,
			isSceneSelectionAvailable = getIsInExpSceneSelectionAvailable()
		}

		if preselectedPlayer then
			t2.preselectedAbuserId = tostring(preselectedPlayer.UserId)
			t2.preselectedAbuserDisplayName = preselectedPlayer.DisplayName
			t2.preselectedAbuserUsername = preselectedPlayer.Name
		end

		return t2
	end, {
		v22,
		preselectedPlayer,
		v23
	})
	local v25 = useDynamicInExpConfig(t1.isReportTabVisible, v24)
	local config = v25.config
	local hasError = v25.hasError
	local setHasError = v25.setHasError
	local abuseVector = v25.abuseVector
	local u30 = nil
	local u31 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		local v32, v33 = React.useState(nil)

		u30 = v32
		u31 = v33
	end

	local v34 = useDeviceOrientation()
	local v35 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v36 = v34 == "Landscape" or not v35
	local v37 = React.useMemo(function() -- line: 101
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
	local v38 = React.useRef(DateTime.now().UnixTimestampMillis)

	React.useEffect(function() -- line: 122
		-- upvalues: t1 (copy), v38 (copy)
		if t1.isReportTabVisible then
			v38.current = DateTime.now().UnixTimestampMillis
		end
	end, { t1.isReportTabVisible })

	if FFlagAbuseReportInExpPlayerListV3 then
		React.useEffect(function() -- line: 134
			-- upvalues: recentlyLeftSignals (copy)
			recentlyLeftSignals.init()
		end, {})
	end

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		React.useEffect(function() -- line: 140
			-- upvalues: t1 (copy), u31 (ref)
			if not t1.isReportTabVisible and u31 then
				u31(nil)
			end
		end, {
			t1.isReportTabVisible,
			u31
		})
	end

	local v39 = useInExpCustomSubmit({
		voiceChatServiceManager = t1.voiceChatServiceManager,
		inExpChatMessagesLoader = t1.inExpChatMessagesLoader,
		menuOpenTimeRef = v38,
		reportAnythingSnapshotRef = t1.reportAnythingSnapshotRef
	})
	local v40 = React.useCallback(function() -- line: 156
		-- upvalues: setHasError (copy)
		setHasError(true)
	end, { setHasError })
	local v41 = React.useCallback(function(p1) -- line: 160
		-- upvalues: sendBoundaryErrorTelemetry (copy), abuseVector (copy), v22 (copy), setHasError (copy)
		warn("AbuseReportErrorBoundary (in-exp) caught:", p1)
		sendBoundaryErrorTelemetry(p1, {
			abuse_vector = abuseVector,
			target_id = v22
		})
		setHasError(true)
	end, {
		abuseVector,
		v22,
		setHasError
	})
	local v42 = nil

	if FFlagAbuseReportInlineAlertStateOutsideReducer then
		v42 = React.useMemo(function() -- line: 171
			-- upvalues: u31 (ref), u30 (ref)
			if u31 then
				return {
					pendingInlineAlert = u30,
					setInlineAlert = u31
				}
			end

			return nil
		end, {
			u30,
			u31
		})
	end

	if t1.isReportTabVisible and hasError then
		return React.createElement(DynamicReportV2InExpError, nil)
	end

	return if not t1.isReportTabVisible or (not config or hasError) then nil else React.createElement(AbuseReportErrorBoundary, {
		onError = v41
	}, {
		AbuseReportContentInExp = React.createElement(AbuseReportContentInExp, {
			rawConfig = config,
			abuseVector = abuseVector,
			targetId = v22,
			onClose = t1.onClose,
			open = t1.isReportTabVisible,
			onCustomSubmit = v39,
			onFinish = t1.onReportFinish,
			onResolveError = v40,
			shouldUseOverlaidControls = v36,
			loaders = v37,
			attemptTrigger = not preselectedPlayer and "onFirstAction" or "onOpen",
			inlineAlertController = v42,
			voiceChatServiceManager = if not FFlagAbuseReportInExpPlayerListV3 and not FFlagAbuseReportVoiceMute then nil else t1.voiceChatServiceManager
		})
	})
end

return React.memo(DynamicReportV2InExpContainer)
