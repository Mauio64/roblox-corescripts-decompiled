local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local AbuseReportAnalyticsProvider = AbuseReportAnalyticsContext.AbuseReportAnalyticsProvider
local AbuseReportInline = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportInline)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local arTranslationProvider = arTranslation.ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local useAbuseSheetFlow = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)

local inlineSlots = LayoutSlots.inlineSlots
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local OverlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local LoaderProvider = LoaderContext.LoaderProvider

local FFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportVoiceMute = SharedFlags.FFlagAbuseReportVoiceMute

local function AbuseReportContentInExp(props)
	local abuseReportFlow = useAbuseSheetFlow(props.rawConfig, {
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
		if not abuseReportFlow then
			props.onResolveError()
		end
	end, { abuseReportFlow, props.onResolveError })

	if not abuseReportFlow then
		return nil
	end

	local element = React.createElement(
		arTranslationProvider,
		{ translations = abuseReportFlow.config.translations },
		React.createElement(
			AbuseReportAnalyticsProvider,
			{ analytics = abuseReportFlow.analytics },
			React.createElement(
				LayoutSlotsProvider,
				{ slots = inlineSlots },
				React.createElement(
					OverlaidControlsProvider,
					{ value = props.shouldUseOverlaidControls },
					React.createElement(
						LoaderProvider,
						{ loaders = props.loaders, open = true },
						React.createElement(AbuseReportInline, {
							abuseReportFlow = abuseReportFlow,
							shouldUseOverlaidControls = props.shouldUseOverlaidControls
						})
					)
				)
			)
		)
	)

	if FFlagAbuseReportInExpPlayerListV3 or FFlagAbuseReportVoiceMute then
		return React.createElement(
			voiceSpeakingSignals.VoiceChatServiceManagerContext.Provider,
			{ value = props.voiceChatServiceManager },
			element
		)
	end

	return element
end

return AbuseReportContentInExp
