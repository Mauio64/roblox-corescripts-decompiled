local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/Frame")
local SimpleSubmitDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Dialogs/SimpleSubmitDialog")
local DefaultLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/DefaultLocalizationKeys")

local OnFormLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormLoaded")
local useAnalyticsSubmitDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/useAnalyticsSubmitDispatch")
local useAnalyticsDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/useAnalyticsDispatch")

local function ReportWithReasonAndComment(props)
	local v5 = useAnalyticsSubmitDispatch()
	local v6 = useAnalyticsDispatch()
	local hasPreviousSteps = props.onCloseProps and props.onCloseProps.hasPreviousSteps

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

	local v7 = React.useCallback(function(p2, p3)
		local v8

		if props.onSubmitProps.hasNextSteps then
			v8 = props.onSubmitProps.onProceedToNextStep(p2, p3)
		else
			v8 = props.onSubmitProps.onSubmit(p2, p3)
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

	return React.createElement(Frame, { Size = UDim2.fromScale(1, 1) }, {
		submitDialog = React.createElement(SimpleSubmitDialog, {
			topCustomComponent = props.topCustomComponent,
			footerContent = props.footerContent,
			localizationKeys = props.localizationKeys,
			reportCategories = props.reportCategories,
			reportCategoryDefaultKey = props.reportCategoryDefaultKey,
			onSubmit = v7,
			onAbandon = v8,
			isDisabled = props.isDisabled,
			isReportCategoryReadonly = props.isReportCategoryReadonly,
			useBackButton = hasPreviousSteps,
			scaleDialog = props.scaleDialog
		})
	})
end

return ReportWithReasonAndComment
