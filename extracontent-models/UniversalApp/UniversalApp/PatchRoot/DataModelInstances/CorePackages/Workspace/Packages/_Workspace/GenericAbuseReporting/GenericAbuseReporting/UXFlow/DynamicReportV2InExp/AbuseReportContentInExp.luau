local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext).AbuseReportAnalyticsProvider
local AbuseReportInline = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportInline)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

local ArTranslationProvider = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local useAbuseSheetFlow = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)
local inlineSlots = LayoutSlots.inlineSlots
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local OverlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local LoaderProvider = LoaderContext.LoaderProvider

local function AbuseReportContentInExp(t1: {[any]: any}) -- line: 52
	-- upvalues: useAbuseSheetFlow (copy), React (copy), ArTranslationProvider (copy), AbuseReportAnalyticsProvider (copy), LayoutSlotsProvider (copy), inlineSlots (copy), OverlaidControlsProvider (copy), LoaderProvider (copy), AbuseReportInline (copy)
	local v16 = useAbuseSheetFlow(t1.rawConfig, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		open = t1.open,
		onCustomSubmit = t1.onCustomSubmit,
		onFinish = t1.onFinish,
		attemptTrigger = t1.attemptTrigger,
		inlineAlertController = t1.inlineAlertController
	})

	React.useEffect(function() -- line: 64
		-- upvalues: v16 (copy), t1 (copy)
		if not v16 then
			t1.onResolveError()
		end
	end, {
		v16,
		t1.onResolveError
	})

	if not v16 then
		return nil
	end

	return React.createElement(ArTranslationProvider, {
		translations = v16.config.translations
	}, React.createElement(AbuseReportAnalyticsProvider, {
		analytics = v16.analytics
	}, React.createElement(LayoutSlotsProvider, {
		slots = inlineSlots
	}, React.createElement(OverlaidControlsProvider, {
		value = t1.shouldUseOverlaidControls
	}, React.createElement(LoaderProvider, {
		loaders = t1.loaders,
		open = t1.open
	}, React.createElement(AbuseReportInline, {
		abuseReportFlow = v16,
		shouldUseOverlaidControls = t1.shouldUseOverlaidControls
	}))))))
end

return AbuseReportContentInExp
