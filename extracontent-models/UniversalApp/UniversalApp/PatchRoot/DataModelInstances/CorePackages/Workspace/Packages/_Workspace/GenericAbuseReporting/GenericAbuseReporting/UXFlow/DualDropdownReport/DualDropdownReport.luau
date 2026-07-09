local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local Frame = require(GenericAbuseReporting.Common.Frame)
local DualDropdownSubmitDialog = require(GenericAbuseReporting.Dialogs.DualDropdownSubmitDialog)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)
local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)
local useAnalyticsSubmitDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsSubmitDispatch)
local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)

local function DualDropdownReport(t1: {[any]: any}) -- line: 30
	-- upvalues: useAnalyticsSubmitDispatch (copy), useAnalyticsDispatch (copy), DefaultLocalizationKeys (copy), React (copy), OnFormLoaded (copy), Frame (copy), DualDropdownSubmitDialog (copy)
	local v12 = useAnalyticsSubmitDispatch()
	local v13 = useAnalyticsDispatch()

	if t1.localizationKeys then
		t1.localizationKeys.formTitle = t1.localizationKeys.formTitle or DefaultLocalizationKeys.formTitle
		t1.localizationKeys.formSubmit = t1.localizationKeys.formSubmit or DefaultLocalizationKeys.formSubmit
	end

	React.useEffect(function() -- line: 39
		-- upvalues: v13 (copy), OnFormLoaded (copy), t1 (copy)
		v13(OnFormLoaded({
			context = t1.analyticsContext,
			place_id = game.PlaceId,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		}))
	end, {
		v13,
		t1.analyticsContext
	})

	local v14 = React.useCallback(function(s1: string, s2: string, s3: string) -- line: 48
		-- upvalues: t1 (copy), v12 (copy)
		if ((if not t1.onSubmitProps.hasNextSteps then t1.onSubmitProps.onSubmit(s1, s2, s3) else t1.onSubmitProps.onProceedToNextStep(s1, s2, s3))) and not t1.onSubmitProps.hasNextSteps then
			v12("Submit")
		end
	end, {
		v12,
		t1.onSubmitProps
	})
	local v15 = React.useCallback(function() -- line: 58
		-- upvalues: t1 (copy), v12 (copy)
		if t1.onCloseProps then
			if t1.onCloseProps.hasPreviousSteps then
				t1.onCloseProps.onBackToPreviousStep()

				return
			end

			t1.onCloseProps.onAbandon()
			v12("Abandon")

			return
		end

		v12("Abandon")
	end, {
		v12,
		t1.onCloseProps
	})

	return React.createElement(Frame, {
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		DualDropdownReport = React.createElement(DualDropdownSubmitDialog, {
			localizationKeys = t1.localizationKeys,
			reportProblems = t1.reportProblems,
			reportSurfaces = t1.reportSurfaces,
			onSubmit = v14,
			onAbandon = v15,
			footerContent = t1.footerContent
		})
	})
end

return DualDropdownReport
