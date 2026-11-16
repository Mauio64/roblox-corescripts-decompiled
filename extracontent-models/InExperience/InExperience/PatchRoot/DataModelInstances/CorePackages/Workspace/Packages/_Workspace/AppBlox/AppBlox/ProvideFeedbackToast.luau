local parent = script:FindFirstAncestor("AppBlox").Parent

local CentralOverlay = require(parent.CentralOverlay)
require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

require(script.Parent.CheckboxFeedbackFormModal)
local SnackbarWrapper = require(script.Parent.SnackbarWrapper)

local function ProvideFeedbackToast(props)
	local v = useDispatch()
	local v2 = useLocalization({
		giveFeedback = "Feature.GameDetails.Action.GiveFeedback",
		helpUsImprove = "Feature.GameDetails.Message.HelpImproveExperience"
	})

	local onButtonActivated = React.useCallback(function()
		if props.onToastActivated then
			task.spawn(props.onToastActivated)
		end

		v(SetCentralOverlay(CentralOverlayType.CheckboxFeedbackFormModal, props.feedbackFormProps))
	end, { props.onToastActivated, v, props.feedbackFormProps })

	local closeSnackbar = React.useCallback(function()
		if props.onToastDismissed then
			task.spawn(props.onToastDismissed)
		end

		v(CloseCentralOverlay())
	end, { props.onToastDismissed, v })

	return React.createElement(SnackbarWrapper, {
		titleText = props.toastTitle or v2.helpUsImprove,
		icon = props.toastIcon,
		buttonText = props.toastButtonText or v2.giveFeedback,
		onButtonActivated = onButtonActivated,
		closeSnackbar = closeSnackbar,
		autoDismissDelaySeconds = 5
	})
end

return React.memo(ProvideFeedbackToast)
