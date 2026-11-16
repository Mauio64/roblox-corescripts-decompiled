require(script.Analytics.uiStatusBarTappedEvent)
local useLogInputTypeChanged = require(script.Hooks.useLogInputTypeChanged)
local useLogFocusNavigationTelemetry = require(script.Hooks.useLogFocusNavigationTelemetry)
local useLogKeyboardFocusModeEntered = require(script.Hooks.useLogKeyboardFocusModeEntered)
local useLogOrientationChanged = require(script.Hooks.useLogOrientationChanged)
local useLogStatusBarTapped = require(script.Hooks.useLogStatusBarTapped)
local switchAccountScrimError = require(script.Analytics.switchAccountScrimError)
local createAppLaunchReactProfilerLogger = require(script.createAppLaunchReactProfilerLogger)

return {
	["jest.config"] = script["jest.config"],
	useLogInputTypeChanged = useLogInputTypeChanged,
	useLogFocusNavigationTelemetry = useLogFocusNavigationTelemetry,
	useLogKeyboardFocusModeEntered = useLogKeyboardFocusModeEntered,
	useLogOrientationChanged = useLogOrientationChanged,
	useLogStatusBarTapped = useLogStatusBarTapped,
	switchAccountScrimError = switchAccountScrimError,
	createAppLaunchReactProfilerLogger = createAppLaunchReactProfilerLogger
}
