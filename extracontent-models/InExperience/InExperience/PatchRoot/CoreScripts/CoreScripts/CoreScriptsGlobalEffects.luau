local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local usePlayerCurrentScreenOrientation = require(RobloxGui.Modules.Common.Hooks.usePlayerCurrentScreenOrientation)

local CoreScriptsGamepadDisconnectListener = require(RobloxGui.Modules.GamepadDisconnect.CoreScriptsGamepadDisconnectListener)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)

local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType
local UiShellEvents = require(CorePackages.Workspace.Packages.UiShellEvents)
local useLogInputTypeChanged = UiShellEvents.useLogInputTypeChanged
local UiShellEvents2 = require(CorePackages.Workspace.Packages.UiShellEvents)
local useLogOrientationChanged = UiShellEvents2.useLogOrientationChanged

local EventIngestService = game:GetService("EventIngestService")
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local eventIngest = Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)
local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local UserInputService = game:GetService("UserInputService")
local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType.getInputGroup
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useExternalEvent = RoactUtils.Hooks.useExternalEvent
local defineFastFlag = game:DefineFastFlag("RemoveLoggingHookForCorescriptGlobalEffects2", false)

local v = nil

local function sendInputTypeLogging(inputType: string?)
	if v == inputType then
		return
	end

	v = inputType
	local gamepadConnected = UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1)
	local playSessionId

	if engineFeature then
		playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	if inputType ~= nil then
		eventIngest:sendEventDeferred("inputTypeChanged", "inputTypeChanged", {
			inputType = inputType,
			gamepadConnected = gamepadConnected,
			playSessionId = playSessionId
		})
	end
end

local function CoreScriptsGlobalEffects(_)
	if defineFastFlag then
		local v2 = React.useCallback(function(p)
			sendInputTypeLogging(getInputGroup(p))
		end, {})

		useExternalEvent(UserInputService.LastInputTypeChanged, v2)
	elseif engineFeature then
		useLogInputTypeChanged(eventIngest, RbxAnalyticsService:GetPlaySessionId())
	else
		useLogInputTypeChanged(eventIngest)
	end

	useLogOrientationChanged(eventIngest, (usePlayerCurrentScreenOrientation()))

	local styleOverride = { deviceType = DeviceType.Console }

	return React.createElement(CoreScriptsRootProvider, { styleOverride = styleOverride }, {
		CoreScriptsGamepadDisconnectListener = React.createElement(CoreScriptsGamepadDisconnectListener)
	})
end

Roact.mount(React.createElement(CoreScriptsGlobalEffects), CoreGui, "CoreScriptsGlobalEffects")
