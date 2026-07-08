local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local InputType = require(ParentParent.Enums.InputType)
local React = require(ParentParentParent.React)
local useEventConnection = require(ParentParentParent.ReactUtils).useEventConnection
local t1 = {
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

local function useInputType(p1) -- line: 47
	-- upvalues: UserInputService (copy), t1 (copy), React (copy), useEventConnection (copy)
	local v10 = p1 or UserInputService

	local function getLastInputType() -- line: 50
		-- upvalues: v10 (copy), t1 (copy)
		return t1[v10:GetLastInputType()]
	end

	local v12, v13 = React.useState(t1[v10:GetLastInputType()])
	local v14 = React.useCallback(function(p2) -- line: 58
		-- upvalues: t1 (copy), v13 (copy)
		local v16 = t1[p2]

		if v16 ~= nil then
			v13(v16)
		end
	end)

	useEventConnection(v10.LastInputTypeChanged, v14)
	React.useEffect(function() -- line: 69
		-- upvalues: v13 (copy), v10 (copy), t1 (copy)
		v13(t1[v10:GetLastInputType()])
	end, {})

	return v12
end

return useInputType
