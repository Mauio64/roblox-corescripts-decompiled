local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext).AbuseReportAnalyticsProvider
local AbuseReportInline = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportInline)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

local ArTranslationProvider = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).ArTranslationProvider
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

local function AbuseReportContentInExp(t1: {[any]: any}) -- line: 58
	-- upvalues: useAbuseSheetFlow (copy), React (copy), ArTranslationProvider (copy), AbuseReportAnalyticsProvider (copy), LayoutSlotsProvider (copy), inlineSlots (copy), OverlaidControlsProvider (copy), LoaderProvider (copy), AbuseReportInline (copy), FFlagAbuseReportInExpPlayerListV3 (copy), FFlagAbuseReportVoiceMute (copy), voiceSpeakingSignals (copy)
	local v20 = useAbuseSheetFlow(t1.rawConfig, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		open = t1.open,
		onCustomSubmit = t1.onCustomSubmit,
		onFinish = t1.onFinish,
		attemptTrigger = t1.attemptTrigger,
		inlineAlertController = t1.inlineAlertController
	})

	React.useEffect(function() -- line: 70
		-- upvalues: v20 (copy), t1 (copy)
		if not v20 then
			t1.onResolveError()
		end
	end, {
		v20,
		t1.onResolveError
	})

	if not v20 then
		return nil
	end

	local v21 = React.createElement(ArTranslationProvider, {
		translations = v20.config.translations
	}, React.createElement(AbuseReportAnalyticsProvider, {
		analytics = v20.analytics
	}, React.createElement(LayoutSlotsProvider, {
		slots = inlineSlots
	}, React.createElement(OverlaidControlsProvider, {
		value = t1.shouldUseOverlaidControls
	}, React.createElement(LoaderProvider, {
		loaders = t1.loaders,
		open = t1.open
	}, React.createElement(AbuseReportInline, {
		abuseReportFlow = v20,
		shouldUseOverlaidControls = t1.shouldUseOverlaidControls
	}))))))

	if FFlagAbuseReportInExpPlayerListV3 or FFlagAbuseReportVoiceMute then
		return React.createElement(voiceSpeakingSignals.VoiceChatServiceManagerContext.Provider, {
			value = t1.voiceChatServiceManager
		}, v21)
	end

	return v21
end

return AbuseReportContentInExp
