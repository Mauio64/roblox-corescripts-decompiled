local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)

local AnalyticsProvider = require(GenericAbuseReporting.Analytics.AnalyticsProvider)
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationKeysProvider = require(GenericAbuseReporting.LocalizationKeys.LocalizationKeysProvider)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local ReportWithReasonAndComment = require(script.Parent.ReportWithReasonAndComment)
local ReportCompleteDialog = require(GenericAbuseReporting.Dialogs.ReportCompleteDialog)
local ReportFailedDialog = require(GenericAbuseReporting.Dialogs.ReportFailedDialog)

require(GenericAbuseReporting.Analytics.submitAnalytics)
local useActiveDialog = require(script.Parent.useActiveDialog)

local _ = { Form = "Form", Complete = "Complete", Error = "Error" }

local function AREntrypoint(props)
	local v, v2 = useActiveDialog()

	local v3 = React.useCallback(function(p: string, p2: string)
		local selected

		if props.onSubmitProps.hasNextSteps then
			selected = props.onSubmitProps.onProceedToNextStep(p, p2)
		else
			selected = props.onSubmitProps.onSubmit(p, p2)
		end

		if selected then
			v2("Complete")
			return selected
		end

		v2("Error")

		return selected
	end, { props.onSubmitProps })

	local onDismiss = React.useCallback(function()
		v2("Form")
	end, {})

	local onDismiss2 = React.useCallback(function()
		if props.onComplete then
			props.onComplete()
		end
	end, { props.onComplete })

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v4 = { colorMode = Foundation.Enums.ColorMode.Dark }

	local createElement3 = React.createElement
	local v5 = {
		onBeforeSubmitAnalytics = props.onBeforeSubmitAnalytics,
		onSubmitAnalytics = props.onSubmitAnalytics
	}

	local createElement4 = React.createElement
	local v6 = { localizationKeys = props.localizationKeys }
	local submitDialog

	if v == "Form" then
		local createElement5 = React.createElement
		local v7 = {
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
		local onSubmitProps

		if props.onSubmitProps.hasNextSteps then
			onSubmitProps = {
				hasNextSteps = props.onSubmitProps.hasNextSteps,
				onProceedToNextStep = v3
			}
		else
			onSubmitProps = { hasNextSteps = props.onSubmitProps.hasNextSteps, onSubmit = v3 }
		end

		v7.onSubmitProps = onSubmitProps

		v7.reportCategoryDefaultKey = props.reportCategoryDefaultKey
		v7.isDisabled = props.isDisabled
		v7.isReportCategoryReadonly = props.isReportCategoryReadonly
		v7.scaleDialog = props.scaleDialog
		submitDialog = createElement5(ReportWithReasonAndComment, v7)
	else
		submitDialog = false
	end

	return createElement(LayerCollectorProvider, {}, {
		FoundationProvider = createElement2(FoundationProvider, v4, {
			analytics = createElement3(AnalyticsProvider, v5, {
				localizationKeys = createElement4(LocalizationKeysProvider, v6, {
					submitDialog = submitDialog,
					completeDialog = v == "Complete" and React.createElement(ReportCompleteDialog, {
						onDismiss = onDismiss2
					}),
					errorDialog = v == "Error" and React.createElement(ReportFailedDialog, {
						onDismiss = onDismiss
					})
				})
			})
		})
	})
end

return AREntrypoint
