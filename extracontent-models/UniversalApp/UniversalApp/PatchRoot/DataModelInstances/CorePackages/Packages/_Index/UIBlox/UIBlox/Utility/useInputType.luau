local UserInputService = game:GetService("UserInputService")
local parent = script.Parent.Parent
local parent2 = parent.Parent

local InputType = require(parent.Enums.InputType)
local React = require(parent2.React)

local ReactUtils = require(parent2.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local v = {
	[Enum.UserInputType.Gamepad1] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad2] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad3] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad4] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad5] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad6] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad7] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad8] = InputType.Gamepad,
	[Enum.UserInputType.MouseButton1] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.MouseButton2] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.MouseButton3] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.MouseWheel] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.MouseMovement] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.Keyboard] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.TextInput] = InputType.MouseAndKeyboard,
	[Enum.UserInputType.Touch] = InputType.Touch
}

local function useInputType(p)
	local v2 = p or UserInputService

	local function getLastInputType() -- 2 equivalent calls inferred from this helper
		return v[v2:GetLastInputType()]
	end

	local state, setState = React.useState(getLastInputType()) -- inferred equivalent call

	local v3 = React.useCallback(function(p2)
		local v3 = v[p2]

		if v3 ~= nil then
			setState(v3)
		end
	end)

	useEventConnection(v2.LastInputTypeChanged, v3)

	React.useEffect(function()
		setState(getLastInputType()) -- inferred equivalent call
	end, {})

	return state
end

return useInputType
