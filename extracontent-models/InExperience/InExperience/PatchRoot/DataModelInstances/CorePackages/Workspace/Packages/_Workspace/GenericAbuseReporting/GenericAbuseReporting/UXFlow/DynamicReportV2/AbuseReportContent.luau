local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableInlineSurveyOnUserReport = SharedFlags.FFlagEnableInlineSurveyOnUserReport

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local AbuseReportAnalyticsProvider = AbuseReportAnalyticsContext.AbuseReportAnalyticsProvider
local AbuseReportDialog = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportDialog)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local arTranslationProvider = arTranslation.ArTranslationProvider
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local LoaderContext = require(GenericAbuseReporting.BeduiV2.Loaders.LoaderContext)
local useAbuseSheetFlow = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)

local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local LoaderProvider = LoaderContext.LoaderProvider
local sheetSlots = LayoutSlots.sheetSlots

return (React.forwardRef(function(props, p)
	local rawConfig = props.rawConfig
	local v = {
		abuseVector = props.abuseVector,
		analyticsTargetId = props.analyticsTargetId,
		onClose = props.onClose,
		open = props.open,
		onCustomSubmit = props.onCustomSubmit,
		clientActionHandlers = props.clientActionHandlers,
		onFinish = 0
	}
	local onFinish

	if FFlagEnableInlineSurveyOnUserReport then
		onFinish = props.onFinish
	end

	v.onFinish = onFinish
	local abuseReportFlow = useAbuseSheetFlow(rawConfig, v)

	React.useImperativeHandle(p, function()
		return {
			requestClose = function()
				if abuseReportFlow then
					abuseReportFlow.onClose()
				end
			end
		}
	end, { abuseReportFlow })

	React.useEffect(function()
		if not abuseReportFlow then
			props.onResolveError()
		end
	end, { abuseReportFlow, props.onResolveError })

	if not abuseReportFlow then
		return nil
	end

	local element = React.createElement(AbuseReportDialog, {
		abuseVector = props.abuseVector,
		onClose = props.onClose,
		abuseReportFlow = abuseReportFlow,
		takeoverFocus = props.takeoverFocus
	})

	return React.createElement(
		arTranslationProvider,
		{ translations = abuseReportFlow.config.translations },
		React.createElement(
			AbuseReportAnalyticsProvider,
			{ analytics = abuseReportFlow.analytics },
			React.createElement(
				LoaderProvider,
				{ loaders = {}, open = props.open },
				React.createElement(LayoutSlotsProvider, { slots = sheetSlots }, element)
			)
		)
	)
end))
