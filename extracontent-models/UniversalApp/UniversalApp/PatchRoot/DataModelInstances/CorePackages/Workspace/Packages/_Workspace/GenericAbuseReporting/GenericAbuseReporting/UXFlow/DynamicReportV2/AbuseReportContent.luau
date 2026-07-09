local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local FFlagEnableInlineSurveyOnUserReport = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableInlineSurveyOnUserReport
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext).AbuseReportAnalyticsProvider
local AbuseReportDialog = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportDialog)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

local ArTranslationProvider = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local useAbuseSheetFlow = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local LoaderProvider = LoaderContext.LoaderProvider
local sheetSlots = LayoutSlots.sheetSlots

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 50
	-- upvalues: useAbuseSheetFlow (copy), FFlagEnableInlineSurveyOnUserReport (copy), React (copy), AbuseReportDialog (copy), ArTranslationProvider (copy), AbuseReportAnalyticsProvider (copy), LoaderProvider (copy), LayoutSlotsProvider (copy), sheetSlots (copy)
	local v16 = useAbuseSheetFlow(t1.rawConfig, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		open = t1.open,
		onFinish = if not FFlagEnableInlineSurveyOnUserReport then nil else t1.onFinish
	})

	React.useImperativeHandle(p1, function() -- line: 59
		-- upvalues: v16 (copy)
		return {
			requestClose = function() -- line: 61
				-- upvalues: v16 (copy)
				if v16 then
					v16.onClose()
				end
			end
		}
	end, { v16 })
	React.useEffect(function() -- line: 69
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

	local v17 = React.createElement(AbuseReportDialog, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		abuseReportFlow = v16,
		takeoverFocus = t1.takeoverFocus
	})

	return React.createElement(ArTranslationProvider, {
		translations = v16.config.translations
	}, React.createElement(AbuseReportAnalyticsProvider, {
		analytics = v16.analytics
	}, React.createElement(LoaderProvider, {
		loaders = {},
		open = t1.open
	}, React.createElement(LayoutSlotsProvider, {
		slots = sheetSlots
	}, v17))))
end))
