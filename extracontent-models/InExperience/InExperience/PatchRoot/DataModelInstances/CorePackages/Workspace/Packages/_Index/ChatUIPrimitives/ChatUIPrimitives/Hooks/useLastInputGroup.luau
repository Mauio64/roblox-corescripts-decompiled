local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local InputType = require(parent.InputType)
local getInputGroup = InputType.getInputGroup
local InputTypeConstants = InputType.InputTypeConstants

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function getInitialInputGroup(p) -- 1 equivalent call inferred from this helper
	if
		p.PreferredInput == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput and p.PreferredInput == Enum.PreferredInput.MicroGamepad
	then
		return InputTypeConstants.Gamepad
	end

	if p.TouchEnabled then
		return InputTypeConstants.Touch
	end

	return InputTypeConstants.MouseAndKeyboard
end

local function useLastInputGroup(p)
	local v = p or UserInputService
	local state, setState = React.useState(function()
		return getInitialInputGroup(v) -- inferred equivalent call
	end)

	React.useEffect(function()
		local lastInputTypeChangedConnection = v.LastInputTypeChanged:Connect(function(p2)
			setState(getInputGroup(p2))
		end)
		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, { v })

	return state
end

return useLastInputGroup
