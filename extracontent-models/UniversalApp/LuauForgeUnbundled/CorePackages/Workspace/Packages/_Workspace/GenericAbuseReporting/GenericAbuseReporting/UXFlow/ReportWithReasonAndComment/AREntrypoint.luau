local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AnalyticsProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/AnalyticsProvider")
local layerCollectorProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox").Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationKeysProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/LocalizationKeysProvider")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local foundationProvider = Foundation.FoundationProvider

local ReportWithReasonAndComment = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/ReportWithReasonAndComment/ReportWithReasonAndComment")
local ReportCompleteDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/ReportCompleteDialog")
local ReportFailedDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/ReportFailedDialog")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/submitAnalytics")
local useActiveDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DualDropdownReport/useActiveDialog")

local v5 = { Form = "Form", Complete = "Complete", Error = "Error" }

local function AREntrypoint(props)
	local v6, v7 = useActiveDialog()

	local v8 = React.useCallback(function(p2, p3)
		local v9

		if props.onSubmitProps.hasNextSteps then
			v9 = props.onSubmitProps.onProceedToNextStep(p2, p3)
		else
			v9 = props.onSubmitProps.onSubmit(p2, p3)
		end

		if v9 then
			v7("Complete")
			return v9
		end

		v7("Error")

		return v9
	end, { props.onSubmitProps })

	local v9 = React.useCallback(function()
		v7("Form")
	end, {})

	local v10 = React.useCallback(function()
		if props.onComplete then
			props.onComplete()
		end
	end, { props.onComplete })

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v15 = { colorMode = Foundation.Enums.ColorMode.Dark }

	local createElement3 = React.createElement
	local v18 = {
		onBeforeSubmitAnalytics = props.onBeforeSubmitAnalytics,
		onSubmitAnalytics = props.onSubmitAnalytics
	}

	local createElement4 = React.createElement
	local v21 = { localizationKeys = props.localizationKeys }
	local v23

	if v6 == "Form" then
		local createElement5 = React.createElement
		local v25 = {
			analyticsContext = props.analyticsContext,
			topCustomComponent = props.topCustomComponent,
			footerContent = props.footerContent,
			reportCategories = props.reportCategories,
			onCloseProps = props.onCloseProps,
			onSubmitProps = 0,
			reportCategoryDefaultKey = 0,
			isDisabled = 0,
			isReportCategoryReadonly = 0,
			scaleDialog = 0
		}
		local v26 = if props.onSubmitProps.hasNextSteps then {
			hasNextSteps = props.onSubmitProps.hasNextSteps,
			onProceedToNextStep = v8
		} else { hasNextSteps = props.onSubmitProps.hasNextSteps, onSubmit = v8 }
		v25.onSubmitProps = v26

		v25.reportCategoryDefaultKey = props.reportCategoryDefaultKey
		v25.isDisabled = props.isDisabled
		v25.isReportCategoryReadonly = props.isReportCategoryReadonly
		v25.scaleDialog = props.scaleDialog
		v23 = createElement5(ReportWithReasonAndComment, v25)
	else
		v23 = false
	end

	return createElement(layerCollectorProvider, {}, {
		FoundationProvider = createElement2(foundationProvider, v15, {
			analytics = createElement3(AnalyticsProvider, v18, {
				localizationKeys = createElement4(LocalizationKeysProvider, v21, {
					submitDialog = v23,
					completeDialog = v6 == "Complete" and React.createElement(ReportCompleteDialog, {
						onDismiss = v10
					}),
					errorDialog = v6 == "Error" and React.createElement(ReportFailedDialog, {
						onDismiss = v9
					})
				})
			})
		})
	})
end

return AREntrypoint
