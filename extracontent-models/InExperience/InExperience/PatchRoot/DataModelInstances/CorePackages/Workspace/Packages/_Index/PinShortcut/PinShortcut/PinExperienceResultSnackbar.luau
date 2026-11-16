local parent = script:FindFirstAncestor("PinShortcut").Parent

local AppBlox = require(parent.AppBlox)
local CentralOverlay = require(parent.CentralOverlay)
local Localization = require(parent.Localization)
local LoggingProtocol = require(parent.LoggingProtocol)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Enums = Foundation.Enums
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local SnackbarWrapper = AppBlox.SnackbarWrapper
local TelemetryCounters = require(script.Parent.TelemetryCounters)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local FFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy
local FFlagPinShortcutSnackbarTelemetryEnabled = require(script.Parent.Flags.FFlagPinShortcutSnackbarTelemetryEnabled)

local function PinExperienceResultSnackbar(props)
	local v = useDispatch()

	local closeSnackbar = React.useCallback(function()
		v(CloseCentralOverlay())
	end, { v })

	local v2 = props.status == Enum.PinExperienceStatus.Success

	local v3 = props.status == Enum.PinExperienceStatus.AlreadyExists
	local experienceName = props.experienceName

	local v4 = useLocalization({
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

	local v5 = not FFlagAddPinExperienceTargetDestinationGUACPolicy and "HomeScreen"
		or getAppFeaturePolicies().getPinExperienceTargetDestination()
	local titleText, icon

	if v2 then
		if v5 == "Desktop" then
			titleText = v4.successDesktop
		else
			titleText = v4.successHomeScreen
		end

		icon = { name = Enums.IconName.CircleCheck, variant = Enums.IconVariant.Filled }
	elseif v3 then
		titleText = v4.alreadyExists
		icon = { name = Enums.IconName.CircleI }
	else
		if v5 == "Desktop" then
			titleText = v4.failedDesktop
		else
			titleText = v4.failedHomeScreen
		end

		icon = { name = Enums.IconName.TriangleExclamation }
	end

	if FFlagPinShortcutSnackbarTelemetryEnabled then
		React.useEffect(function()
			LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarShown, 1, {
				action = v2 and "Success" or v3 and "AlreadyExists" or "Failure"
			})
		end, {})
	end

	local buttonText = nil
	local onButtonActivated

	if v2 and props.onViewShortcut then
		buttonText = v4.viewShortcut
		onButtonActivated = function()
			if FFlagPinShortcutSnackbarTelemetryEnabled then
				LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarButtonPressed, 1, {
					action = "ViewShortcut"
				})
			end

			closeSnackbar()
			props.onViewShortcut()
		end
	elseif not v2 and not v3 and props.onRetry then
		buttonText = v4.tryAgain
		onButtonActivated = function()
			if FFlagPinShortcutSnackbarTelemetryEnabled then
				LoggingProtocol.default:logRobloxTelemetryCounter(TelemetryCounters.SnackbarButtonPressed, 1, {
					action = "TryAgain"
				})
			end

			closeSnackbar()
			props.onRetry()
		end
	end

	local v6 = v2 or v3

	return React.createElement(SnackbarWrapper, {
		titleText = titleText,
		icon = icon,
		buttonText = buttonText,
		onButtonActivated = onButtonActivated,
		closeSnackbar = closeSnackbar,
		autoDismissDelaySeconds = v6 and 5 or nil,
		hideCloseAffordance = v6 and true or false
	})
end

return React.memo(PinExperienceResultSnackbar)
