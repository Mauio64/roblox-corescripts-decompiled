local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)
local Frame = require(GenericAbuseReporting.Common.Frame)
local DualDropdownSubmitDialog = require(GenericAbuseReporting.Dialogs.DualDropdownSubmitDialog)
local DefaultLocalizationKeys = require(GenericAbuseReporting.LocalizationKeys.DefaultLocalizationKeys)

local OnFormLoaded = require(GenericAbuseReporting.Analytics.Actions.OnFormLoaded)
local useAnalyticsSubmitDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsSubmitDispatch)
local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)

local function DualDropdownReport(props)
	local v = useAnalyticsSubmitDispatch()
	local v2 = useAnalyticsDispatch()

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

	local onSubmit = React.useCallback(function(p: string, p2: string, p3: string)
		local v3

		if props.onSubmitProps.hasNextSteps then
			v3 = props.onSubmitProps.onProceedToNextStep(p, p2, p3)
		else
			v3 = props.onSubmitProps.onSubmit(p, p2, p3)
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

	return React.createElement(Frame, { Size = UDim2.new(1, 0, 1, 0) }, {
		DualDropdownReport = React.createElement(DualDropdownSubmitDialog, {
			localizationKeys = props.localizationKeys,
			reportProblems = props.reportProblems,
			reportSurfaces = props.reportSurfaces,
			onSubmit = onSubmit,
			onAbandon = onAbandon,
			footerContent = props.footerContent
		})
	})
end

return DualDropdownReport
