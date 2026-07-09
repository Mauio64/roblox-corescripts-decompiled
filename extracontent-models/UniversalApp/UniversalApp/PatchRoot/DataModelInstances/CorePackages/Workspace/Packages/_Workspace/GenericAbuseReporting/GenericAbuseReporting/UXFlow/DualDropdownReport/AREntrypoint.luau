local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AnalyticsProvider = require(GenericAbuseReporting.Analytics.AnalyticsProvider)
local LayerCollectorProvider = require(GenericAbuseReportingParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationKeysProvider = require(GenericAbuseReporting.LocalizationKeys.LocalizationKeysProvider)
local FoundationProvider = require(GenericAbuseReportingParent.Foundation).FoundationProvider
local DualDropdownReport = require(script.Parent.DualDropdownReport)
local ReportCompleteDialog = require(GenericAbuseReporting.Dialogs.ReportCompleteDialog)
local ReportFailedDialog = require(GenericAbuseReporting.Dialogs.ReportFailedDialog)

require(GenericAbuseReporting.Analytics.submitAnalytics)

local useActiveDialog = require(script.Parent.useActiveDialog)
local _ = {
	Form = "Form",
	Complete = "Complete",
	Error = "Error"
}

local function AREntrypoint(t1: {[any]: any}) -- line: 52
	-- upvalues: useActiveDialog (copy), React (copy), LayerCollectorProvider (copy), FoundationProvider (copy), AnalyticsProvider (copy), LocalizationKeysProvider (copy), DualDropdownReport (copy), ReportCompleteDialog (copy), ReportFailedDialog (copy)
	local v15, v16 = useActiveDialog()
	local v17 = React.useCallback(function(s1: string, s2: string, s3: string) -- line: 55
		-- upvalues: t1 (copy), v16 (copy)
		local v23 = if not t1.onSubmitProps.hasNextSteps then t1.onSubmitProps.onSubmit(s1, s2, s3) else t1.onSubmitProps.onProceedToNextStep(s1, s2, s3)

		if v23 then
			v16("Complete")

			return v23
		end

		v16("Error")

		return v23
	end, { t1.onSubmitProps })
	local v18 = React.useCallback(function() -- line: 67
		-- upvalues: v16 (copy)
		v16("Form")
	end, {})
	local v19 = React.useCallback(function() -- line: 71
		-- upvalues: t1 (copy)
		if t1.onComplete then
			t1.onComplete()
		end
	end, { t1.onComplete })

	return React.createElement(LayerCollectorProvider, {}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = "Dark"
		}, {
			analytics = React.createElement(AnalyticsProvider, {
				onBeforeSubmitAnalytics = t1.onBeforeSubmitAnalytics,
				onSubmitAnalytics = t1.onSubmitAnalytics
			}, {
				localizationKeys = React.createElement(LocalizationKeysProvider, {
					localizationKeys = t1.localizationKeys
				}, {
					submitDialog = v15 == "Form" and React.createElement(DualDropdownReport, {
						analyticsContext = t1.analyticsContext,
						reportProblems = t1.reportProblems,
						reportSurfaces = t1.reportSurfaces,
						onSubmitProps = if not t1.onSubmitProps.hasNextSteps then {
							hasNextSteps = t1.onSubmitProps.hasNextSteps,
							onSubmit = v17
						} else {
							hasNextSteps = t1.onSubmitProps.hasNextSteps,
							onProceedToNextStep = v17
						},
						onCloseProps = t1.onCloseProps
					}),
					completeDialog = v15 == "Complete" and React.createElement(ReportCompleteDialog, {
						onDismiss = v19
					}),
					errorDialog = v15 == "Error" and React.createElement(ReportFailedDialog, {
						onDismiss = v18
					})
				})
			})
		})
	})
end

return AREntrypoint
