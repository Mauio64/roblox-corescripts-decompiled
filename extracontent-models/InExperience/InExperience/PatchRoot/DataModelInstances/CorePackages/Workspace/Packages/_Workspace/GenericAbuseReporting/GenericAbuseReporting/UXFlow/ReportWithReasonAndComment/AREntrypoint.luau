local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AnalyticsProvider = require(GenericAbuseReporting.Analytics.AnalyticsProvider)
local LayerCollectorProvider = require(GenericAbuseReportingParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationKeysProvider = require(GenericAbuseReporting.LocalizationKeys.LocalizationKeysProvider)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ReportWithReasonAndComment = require(script.Parent.ReportWithReasonAndComment)
local ReportCompleteDialog = require(GenericAbuseReporting.Dialogs.ReportCompleteDialog)
local ReportFailedDialog = require(GenericAbuseReporting.Dialogs.ReportFailedDialog)

require(GenericAbuseReporting.Analytics.submitAnalytics)

local useActiveDialog = require(script.Parent.useActiveDialog)
local _ = {
	Form = "Form",
	Complete = "Complete",
	Error = "Error"
}

local function AREntrypoint(t1: {[any]: any}) -- line: 58
	-- upvalues: useActiveDialog (copy), React (copy), LayerCollectorProvider (copy), FoundationProvider (copy), Foundation (copy), AnalyticsProvider (copy), LocalizationKeysProvider (copy), ReportWithReasonAndComment (copy), ReportCompleteDialog (copy), ReportFailedDialog (copy)
	local v16, v17 = useActiveDialog()
	local v18 = React.useCallback(function(s1: string, s2: string) -- line: 61
		-- upvalues: t1 (copy), v17 (copy)
		local v23 = if not t1.onSubmitProps.hasNextSteps then t1.onSubmitProps.onSubmit(s1, s2) else t1.onSubmitProps.onProceedToNextStep(s1, s2)

		if v23 then
			v17("Complete")

			return v23
		end

		v17("Error")

		return v23
	end, { t1.onSubmitProps })
	local v19 = React.useCallback(function() -- line: 73
		-- upvalues: v17 (copy)
		v17("Form")
	end, {})
	local v20 = React.useCallback(function() -- line: 77
		-- upvalues: t1 (copy)
		if t1.onComplete then
			t1.onComplete()
		end
	end, { t1.onComplete })

	return React.createElement(LayerCollectorProvider, {}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			analytics = React.createElement(AnalyticsProvider, {
				onBeforeSubmitAnalytics = t1.onBeforeSubmitAnalytics,
				onSubmitAnalytics = t1.onSubmitAnalytics
			}, {
				localizationKeys = React.createElement(LocalizationKeysProvider, {
					localizationKeys = t1.localizationKeys
				}, {
					submitDialog = v16 == "Form" and React.createElement(ReportWithReasonAndComment, {
						analyticsContext = t1.analyticsContext,
						topCustomComponent = t1.topCustomComponent,
						footerContent = t1.footerContent,
						reportCategories = t1.reportCategories,
						onCloseProps = t1.onCloseProps,
						onSubmitProps = if not t1.onSubmitProps.hasNextSteps then {
							hasNextSteps = t1.onSubmitProps.hasNextSteps,
							onSubmit = v18
						} else {
							hasNextSteps = t1.onSubmitProps.hasNextSteps,
							onProceedToNextStep = v18
						},
						reportCategoryDefaultKey = t1.reportCategoryDefaultKey,
						isDisabled = t1.isDisabled,
						isReportCategoryReadonly = t1.isReportCategoryReadonly,
						scaleDialog = t1.scaleDialog
					}),
					completeDialog = v16 == "Complete" and React.createElement(ReportCompleteDialog, {
						onDismiss = v20
					}),
					errorDialog = v16 == "Error" and React.createElement(ReportFailedDialog, {
						onDismiss = v19
					})
				})
			})
		})
	})
end

return AREntrypoint
