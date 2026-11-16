local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/AppBlox")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/CentralOverlay")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/Localization")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/PinShortcut/LoggingProtocol")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/RoactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/SharedFlags")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/UniversalAppPolicy")

local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local enums = Foundation.Enums
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local snackbarWrapper = AppBlox.SnackbarWrapper
local TelemetryCounters = require("@game/CorePackages/Workspace/Packages/_Index/PinShortcut/PinShortcut/TelemetryCounters")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local fFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy
local FFlagPinShortcutSnackbarTelemetryEnabled = require("@game/CorePackages/Workspace/Packages/_Index/PinShortcut/PinShortcut/Flags/FFlagPinShortcutSnackbarTelemetryEnabled")

local function PinExperienceResultSnackbar(props)
	local v5 = useDispatch()

	local v6 = React.useCallback(function()
		v5(closeCentralOverlay())
	end, { v5 })

	local v7 = props.status == Enum.PinExperienceStatus.Success

	local v8 = props.status == Enum.PinExperienceStatus.AlreadyExists
	local experienceName = props.experienceName

	local v9 = useLocalization({
		successDesktop = {
			"InstantApps.Shortcuts.Label.SuccessAddingExperienceToDesktop",
			experience_name = experienceName
		},
		successHomeScreen = {
			"InstantApps.Shortcuts.Label.SuccessAddingExperienceToHomeScreen",
			experience_name = experienceName
		},
		alreadyExists = {
			"InstantApps.Shortcuts.Label.ShortcutAlreadyExists",
			experience_name = experienceName
		},
		failedDesktop = {
			"InstantApps.Shortcuts.Label.FailedToAddExperienceToDesktop",
			experience_name = experienceName
		},
		failedHomeScreen = {
			"InstantApps.Shortcuts.Label.FailedToAddExperienceToHomeScreen",
			experience_name = experienceName
		},
		viewShortcut = { "InstantApps.Shortcuts.Label.ViewShortcut" },
		tryAgain = { "InstantApps.Shortcuts.Label.TryAgain" }
	})

	local v10 = not fFlagAddPinExperienceTargetDestinationGUACPolicy and "HomeScreen"
		or getAppFeaturePolicies().getPinExperienceTargetDestination()
	local v11, v12

	if v7 then
		v11 = if v10 == "Desktop" then v9.successDesktop else v9.successHomeScreen

		v12 = { name = enums.IconName.CircleCheck, variant = enums.IconVariant.Filled }
	elseif v8 then
		v11 = v9.alreadyExists
		v12 = { name = enums.IconName.CircleI }
	else
		v11 = if v10 == "Desktop" then v9.failedDesktop else v9.failedHomeScreen

		v12 = { name = enums.IconName.TriangleExclamation }
	end

	if FFlagPinShortcutSnackbarTelemetryEnabled then
		React.useEffect(function()
			LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarShown, 1, {
				action = v7 and "Success" or v8 and "AlreadyExists" or "Failure"
			})
		end, {})
	end

	local v13 = nil
	local onButtonActivated

	if v7 and props.onViewShortcut then
		v13 = v9.viewShortcut
		onButtonActivated = function()
			if FFlagPinShortcutSnackbarTelemetryEnabled then
				LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarButtonPressed, 1, {
					action = "ViewShortcut"
				})
			end

			v6()
			props.onViewShortcut()
		end
	elseif not v7 and not v8 and props.onRetry then
		v13 = v9.tryAgain
		onButtonActivated = function()
			if FFlagPinShortcutSnackbarTelemetryEnabled then
				LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarButtonPressed, 1, {
					action = "TryAgain"
				})
			end

			v6()
			props.onRetry()
		end
	end

	local v14 = v7 or v8

	return React.createElement(snackbarWrapper, {
		titleText = v11,
		icon = v12,
		buttonText = v13,
		onButtonActivated = onButtonActivated,
		closeSnackbar = v6,
		autoDismissDelaySeconds = v14 and 5 or nil,
		hideCloseAffordance = v14 and true or false
	})
end

return React.memo(PinExperienceResultSnackbar)
