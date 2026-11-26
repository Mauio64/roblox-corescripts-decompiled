local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local fFlagEnableInlineSurveyOnUserReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagEnableInlineSurveyOnUserReport

local abuseReportAnalyticsProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext").AbuseReportAnalyticsProvider
local AbuseReportDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportDialog")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local arTranslationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").ArTranslationProvider
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local LoaderContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Loaders/LoaderContext")
local useAbuseSheetFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/useAbuseSheetFlow")

local layoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local loaderProvider = LoaderContext.LoaderProvider
local sheetSlots = LayoutSlots.sheetSlots

return (React.forwardRef(function(props, p2)
	local rawConfig = props.rawConfig
	local v6 = {
		abuseVector = props.abuseVector,
		analyticsTargetId = props.analyticsTargetId,
		onClose = props.onClose,
		open = props.open,
		onCustomSubmit = props.onCustomSubmit,
		clientActionHandlers = props.clientActionHandlers,
		onFinish = 0
	}
	local v7 = if fFlagEnableInlineSurveyOnUserReport then props.onFinish else nil
	v6.onFinish = v7
	local v8 = useAbuseSheetFlow(rawConfig, v6)

	React.useImperativeHandle(p2, function()
		return {
			requestClose = function()
				if v8 then
					v8.onClose()
				end
			end
		}
	end, { v8 })

	React.useEffect(function()
		if not v8 then
			props.onResolveError()
		end
	end, { v8, props.onResolveError })

	if not v8 then
		return nil
	end

	local element = React.createElement(AbuseReportDialog, {
		abuseVector = props.abuseVector,
		onClose = props.onClose,
		abuseReportFlow = v8,
		takeoverFocus = props.takeoverFocus
	})

	return React.createElement(
		arTranslationProvider,
		{ translations = v8.config.translations },
		React.createElement(
			abuseReportAnalyticsProvider,
			{ analytics = v8.analytics },
			React.createElement(
				loaderProvider,
				{ loaders = {}, open = props.open },
				React.createElement(layoutSlotsProvider, { slots = sheetSlots }, element)
			)
		)
	)
end))
