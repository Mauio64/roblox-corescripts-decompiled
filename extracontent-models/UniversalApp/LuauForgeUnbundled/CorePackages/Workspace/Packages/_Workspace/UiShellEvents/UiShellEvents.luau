require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/uiStatusBarTappedEvent")
return {
	useLogInputTypeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Hooks/useLogInputTypeChanged"),
	useLogFocusNavigationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Hooks/useLogFocusNavigationTelemetry"),
	useLogKeyboardFocusModeEntered = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Hooks/useLogKeyboardFocusModeEntered"),
	useLogOrientationChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Hooks/useLogOrientationChanged"),
	useLogStatusBarTapped = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Hooks/useLogStatusBarTapped"),
	switchAccountScrimError = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/switchAccountScrimError"),
	createAppLaunchReactProfilerLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/createAppLaunchReactProfilerLogger")
}
