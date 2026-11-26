local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

local abuseReportAnalyticsProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext").AbuseReportAnalyticsProvider
local AbuseReportInline = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportInline")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local arTranslationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").ArTranslationProvider
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local LoaderContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/LoaderContext")
local useAbuseSheetFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/useAbuseSheetFlow")
local voiceSpeakingSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/voiceSpeakingSignals")

local inlineSlots = LayoutSlots.inlineSlots
local layoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local overlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local loaderProvider = LoaderContext.LoaderProvider

local fFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local fFlagAbuseReportVoiceMute = SharedFlags.FFlagAbuseReportVoiceMute

local function AbuseReportContentInExp(props)
	local v5 = useAbuseSheetFlow(props.rawConfig, {
		abuseVector = props.abuseVector,
		analyticsTargetId = props.targetId,
		onClose = props.onClose,
		open = true,
		onCustomSubmit = props.onCustomSubmit,
		clientActionHandlers = props.clientActionHandlers,
		onFinish = props.onFinish,
		attemptTrigger = props.attemptTrigger,
		inlineAlertController = props.inlineAlertController
	})

	React.useEffect(function()
		if not v5 then
			props.onResolveError()
		end
	end, { v5, props.onResolveError })

	if not v5 then
		return nil
	end

	local element = React.createElement(
		arTranslationProvider,
		{ translations = v5.config.translations },
		React.createElement(
			abuseReportAnalyticsProvider,
			{ analytics = v5.analytics },
			React.createElement(
				layoutSlotsProvider,
				{ slots = inlineSlots },
				React.createElement(
					overlaidControlsProvider,
					{ value = props.shouldUseOverlaidControls },
					React.createElement(
						loaderProvider,
						{ loaders = props.loaders, open = true },
						React.createElement(AbuseReportInline, {
							abuseReportFlow = v5,
							shouldUseOverlaidControls = props.shouldUseOverlaidControls
						})
					)
				)
			)
		)
	)

	if fFlagAbuseReportInExpPlayerListV3 or fFlagAbuseReportVoiceMute then
		return React.createElement(
			voiceSpeakingSignals.VoiceChatServiceManagerContext.Provider,
			{ value = props.voiceChatServiceManager },
			element
		)
	end

	return element
end

return AbuseReportContentInExp
