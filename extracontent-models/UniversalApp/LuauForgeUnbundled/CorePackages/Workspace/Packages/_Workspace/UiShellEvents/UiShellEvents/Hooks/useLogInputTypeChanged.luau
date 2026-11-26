local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/React")
local logInputTypeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/logInputTypeChanged")
local useInputType = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RoactUtils").Hooks.useInputType
local useIsTvRemoteDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RoactUtils").Hooks.useIsTvRemoteDevice

local defineFastFlag = game:DefineFastFlag("LogInputTypeChangedTvRemote1", false)

local function getConnectedGamepadTypes(connectedGamepads)
	if connectedGamepads == nil then
		return nil
	end

	local result = {}

	for k, item in connectedGamepads do
		if UserInputService:GamepadSupports(item, Enum.KeyCode.Return) then
			table.insert(result, "tv_remote")
		else
			table.insert(result, "full_gamepad")
		end
	end

	return result
end

local function anyFullGamepadConnected(connectedGamepads): nil | boolean
	if connectedGamepads == nil then
		return nil
	end

	for k, item in connectedGamepads do
		if not UserInputService:GamepadSupports(item, Enum.KeyCode.Return) then
			return true
		end
	end

	return false
end

local function useLogInputTypeChanged(p2, p3)
	local v5 = useInputType()
	local v6 = if defineFastFlag then useIsTvRemoteDevice() else nil

	local connectedGamepads = if defineFastFlag then UserInputService:GetConnectedGamepads() else nil

	local v7 = if defineFastFlag then anyFullGamepadConnected(connectedGamepads) else nil

	local v8 = if defineFastFlag then getConnectedGamepadTypes(connectedGamepads) else nil

	local joined = if v8 then table.concat(v8, ",") else nil

	React.useEffect(function()
		logInputTypeChanged(p2, "inputTypeChanged", {
			inputType = v5,
			gamepadConnected = UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1),
			anyFullGamepadConnected = v7,
			connectedGamepads = joined,
			isTvRemote = v6,
			playSessionId = p3
		})
	end, { v5, joined })
end

return useLogInputTypeChanged
