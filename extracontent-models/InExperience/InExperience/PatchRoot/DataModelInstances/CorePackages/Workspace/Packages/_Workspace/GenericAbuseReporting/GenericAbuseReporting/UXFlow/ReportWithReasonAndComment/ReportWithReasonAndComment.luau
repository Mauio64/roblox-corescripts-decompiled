local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)

local Frame = require(GenericAbuseReporting.Common.Frame)
local SimpleSubmitDialog = require(GenericAbuseReporting.Dialogs.SimpleSubmitDialog)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)

local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)
local useAnalyticsSubmitDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsSubmitDispatch)
local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)

local function ReportWithReasonAndComment(props)
	local v = useAnalyticsSubmitDispatch()
	local v2 = useAnalyticsDispatch()
	local hasPreviousSteps = props.onCloseProps and props.onCloseProps.hasPreviousSteps

	if props.localizationKeys then
		props.localizationKeys.formTitle = props.localizationKeys.formTitle or DefaultLocalizationKeys.formTitle
		props.localizationKeys.formSubmit = props.localizationKeys.formSubmit or DefaultLocalizationKeys.formSubmit
	end

	React.useEffect(function()
		v2(OnFormLoaded({
			context = props.analyticsContext,
			place_id = game.PlaceId,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		}))
	end, { v2, props.analyticsContext })

	local onSubmit = React.useCallback(function(p: string, p2: string)
		local v3

		if props.onSubmitProps.hasNextSteps then
			v3 = props.onSubmitProps.onProceedToNextStep(p, p2)
		else
			v3 = props.onSubmitProps.onSubmit(p, p2)
		end

		if v3 and not props.onSubmitProps.hasNextSteps then
			v("Submit")
		end
	end, { v, props.onSubmitProps })

	local onAbandon = React.useCallback(function()
		if not props.onCloseProps then
			v("Abandon")

			return
		end

		if props.onCloseProps.hasPreviousSteps then
			props.onCloseProps.onBackToPreviousStep()
			return
		end

		props.onCloseProps.onAbandon()
		v("Abandon")
	end, { v, props.onCloseProps })

	return React.createElement(Frame, { Size = UDim2.fromScale(1, 1) }, {
		submitDialog = React.createElement(SimpleSubmitDialog, {
			topCustomComponent = props.topCustomComponent,
			footerContent = props.footerContent,
			localizationKeys = props.localizationKeys,
			reportCategories = props.reportCategories,
			reportCategoryDefaultKey = props.reportCategoryDefaultKey,
			onSubmit = onSubmit,
			onAbandon = onAbandon,
			isDisabled = props.isDisabled,
			isReportCategoryReadonly = props.isReportCategoryReadonly,
			useBackButton = hasPreviousSteps,
			scaleDialog = props.scaleDialog
		})
	})
end

return ReportWithReasonAndComment
