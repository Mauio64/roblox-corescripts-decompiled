local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local usePlayerCurrentScreenOrientation = require(RobloxGui.Modules.Common.Hooks.usePlayerCurrentScreenOrientation)
local CoreScriptsGamepadDisconnectListener = require(RobloxGui.Modules.GamepadDisconnect.CoreScriptsGamepadDisconnectListener)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local DeviceType = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceType
local useLogInputTypeChanged = require(CorePackages.Workspace.Packages.UiShellEvents).useLogInputTypeChanged
local useLogOrientationChanged = require(CorePackages.Workspace.Packages.UiShellEvents).useLogOrientationChanged
local EventIngestService = game:GetService("EventIngestService")
local v14 = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local UserInputService = game:GetService("UserInputService")
local getInputGroup = require(CorePackages.Workspace.Packages.InputType).getInputGroup
local useExternalEvent = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useExternalEvent
local v19 = game:DefineFastFlag("RemoveLoggingHookForCorescriptGlobalEffects2", false)
local u20 = nil

local function sendInputTypeLogging(s1: string?) -- line: 28
	-- upvalues: u20 (ref), UserInputService (copy), EngineFeature (copy), RbxAnalyticsService (copy), v14 (copy)
	if s1 == u20 then
		return
	end

	u20 = s1

	local GamepadConnected = UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1)
	local v25 = if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId()

	if s1 ~= nil then
		v14:sendEventDeferred("inputTypeChanged", "inputTypeChanged", {
			inputType = s1,
			gamepadConnected = GamepadConnected,
			playSessionId = v25
		})
	end
end
local function CoreScriptsGlobalEffects(_) -- line: 47
	-- upvalues: v19 (copy), React (copy), sendInputTypeLogging (copy), getInputGroup (copy), useExternalEvent (copy), UserInputService (copy), EngineFeature (copy), useLogInputTypeChanged (copy), v14 (copy), RbxAnalyticsService (copy), usePlayerCurrentScreenOrientation (copy), useLogOrientationChanged (copy), DeviceType (copy), CoreScriptsRootProvider (copy), CoreScriptsGamepadDisconnectListener (copy)
	if v19 then
		local v27 = React.useCallback(function(p2) -- line: 49
			-- upvalues: sendInputTypeLogging (copy), getInputGroup (copy)
			sendInputTypeLogging(getInputGroup(p2))
		end, {})

		useExternalEvent(UserInputService.LastInputTypeChanged, v27)
	elseif EngineFeature then
		useLogInputTypeChanged(v14, RbxAnalyticsService:GetPlaySessionId())
	else
		useLogInputTypeChanged(v14)
	end

	local v28 = usePlayerCurrentScreenOrientation()

	useLogOrientationChanged(v14, v28)

	local t1 = {
		deviceType = DeviceType.Console
	}

	return React.createElement(CoreScriptsRootProvider, {
		styleOverride = t1
	}, {
		CoreScriptsGamepadDisconnectListener = React.createElement(CoreScriptsGamepadDisconnectListener)
	})
end

Roact.mount(React.createElement(CoreScriptsGlobalEffects), CoreGui, "CoreScriptsGlobalEffects")
