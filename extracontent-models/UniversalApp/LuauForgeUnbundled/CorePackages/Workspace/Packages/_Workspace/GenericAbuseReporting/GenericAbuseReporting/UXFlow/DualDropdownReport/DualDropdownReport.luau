local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/Frame")
local DualDropdownSubmitDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/DualDropdownSubmitDialog")
local DefaultLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/DefaultLocalizationKeys")

local OnFormLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormLoaded")
local useAnalyticsSubmitDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/useAnalyticsSubmitDispatch")
local useAnalyticsDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/useAnalyticsDispatch")

local function DualDropdownReport(props)
	local v5 = useAnalyticsSubmitDispatch()
	local v6 = useAnalyticsDispatch()

	if props.localizationKeys then
		props.localizationKeys.formTitle = props.localizationKeys.formTitle or DefaultLocalizationKeys.formTitle
		props.localizationKeys.formSubmit = props.localizationKeys.formSubmit or DefaultLocalizationKeys.formSubmit
	end

	React.useEffect(function()
		v6(OnFormLoaded({
			context = props.analyticsContext,
			place_id = game.PlaceId,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		}))
	end, { v6, props.analyticsContext })

	local v7 = React.useCallback(function(p2, p3, p4)
		local v8

		if props.onSubmitProps.hasNextSteps then
			v8 = props.onSubmitProps.onProceedToNextStep(p2, p3, p4)
		else
			v8 = props.onSubmitProps.onSubmit(p2, p3, p4)
		end

		if v8 and not props.onSubmitProps.hasNextSteps then
			v5("Submit")
		end
	end, { v5, props.onSubmitProps })

	local v8 = React.useCallback(function()
		if not props.onCloseProps then
			v5("Abandon")

			return
		end

		if props.onCloseProps.hasPreviousSteps then
			props.onCloseProps.onBackToPreviousStep()
			return
		end

		props.onCloseProps.onAbandon()
		v5("Abandon")
	end, { v5, props.onCloseProps })

	return React.createElement(Frame, { Size = UDim2.new(1, 0, 1, 0) }, {
		DualDropdownReport = React.createElement(DualDropdownSubmitDialog, {
			localizationKeys = props.localizationKeys,
			reportProblems = props.reportProblems,
			reportSurfaces = props.reportSurfaces,
			onSubmit = v7,
			onAbandon = v8,
			footerContent = props.footerContent
		})
	})
end

return DualDropdownReport
