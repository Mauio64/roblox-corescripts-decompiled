local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local Frame = require(GenericAbuseReporting.Common.Frame)
local SimpleSubmitDialog = require(GenericAbuseReporting.Dialogs.SimpleSubmitDialog)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)
local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)
local useAnalyticsSubmitDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsSubmitDispatch)
local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)

local function ReportWithReasonAndComment(t1: {[any]: any}) -- line: 34
	-- upvalues: useAnalyticsSubmitDispatch (copy), useAnalyticsDispatch (copy), DefaultLocalizationKeys (copy), React (copy), OnFormLoaded (copy), Frame (copy), SimpleSubmitDialog (copy)
	local v12 = useAnalyticsSubmitDispatch()
	local v13 = useAnalyticsDispatch()
	local v14 = t1.onCloseProps and t1.onCloseProps.hasPreviousSteps

	if t1.localizationKeys then
		t1.localizationKeys.formTitle = t1.localizationKeys.formTitle or DefaultLocalizationKeys.formTitle
		t1.localizationKeys.formSubmit = t1.localizationKeys.formSubmit or DefaultLocalizationKeys.formSubmit
	end

	React.useEffect(function() -- line: 44
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

	local v15 = React.useCallback(function(s1: string, s2: string) -- line: 53
		-- upvalues: t1 (copy), v12 (copy)
		if ((if not t1.onSubmitProps.hasNextSteps then t1.onSubmitProps.onSubmit(s1, s2) else t1.onSubmitProps.onProceedToNextStep(s1, s2))) and not t1.onSubmitProps.hasNextSteps then
			v12("Submit")
		end
	end, {
		v12,
		t1.onSubmitProps
	})
	local v16 = React.useCallback(function() -- line: 63
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
		Size = UDim2.fromScale(1, 1)
	}, {
		submitDialog = React.createElement(SimpleSubmitDialog, {
			topCustomComponent = t1.topCustomComponent,
			footerContent = t1.footerContent,
			localizationKeys = t1.localizationKeys,
			reportCategories = t1.reportCategories,
			reportCategoryDefaultKey = t1.reportCategoryDefaultKey,
			onSubmit = v15,
			onAbandon = v16,
			isDisabled = t1.isDisabled,
			isReportCategoryReadonly = t1.isReportCategoryReadonly,
			useBackButton = v14,
			scaleDialog = t1.scaleDialog
		})
	})
end

return ReportWithReasonAndComment
