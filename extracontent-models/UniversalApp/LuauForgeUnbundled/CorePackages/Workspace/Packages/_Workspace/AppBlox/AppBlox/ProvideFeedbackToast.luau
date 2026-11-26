local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/CentralOverlay")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums")

local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useLocalization = Localization.Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local centralOverlayType = RobloxAppEnums.CentralOverlayType

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/CheckboxFeedbackFormModal")
local SnackbarWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/SnackbarWrapper")

local function ProvideFeedbackToast(props)
	local v5 = useDispatch()
	local v6 = useLocalization({
		giveFeedback = "Feature.GameDetails.Action.GiveFeedback",
		helpUsImprove = "Feature.GameDetails.Message.HelpImproveExperience"
	})

	local v7 = React.useCallback(function()
		if props.onToastActivated then
			task.spawn(props.onToastActivated)
		end

		v5(setCentralOverlay(centralOverlayType.CheckboxFeedbackFormModal, props.feedbackFormProps))
	end, { props.onToastActivated, v5, props.feedbackFormProps })

	local v8 = React.useCallback(function()
		if props.onToastDismissed then
			task.spawn(props.onToastDismissed)
		end

		v5(closeCentralOverlay())
	end, { props.onToastDismissed, v5 })

	return React.createElement(SnackbarWrapper, {
		titleText = props.toastTitle or v6.helpUsImprove,
		icon = props.toastIcon,
		buttonText = props.toastButtonText or v6.giveFeedback,
		onButtonActivated = v7,
		closeSnackbar = v8,
		autoDismissDelaySeconds = 5
	})
end

return React.memo(ProvideFeedbackToast)
