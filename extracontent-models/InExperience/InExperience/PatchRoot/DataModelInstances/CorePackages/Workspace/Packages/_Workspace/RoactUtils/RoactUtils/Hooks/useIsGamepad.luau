local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local isGamepadInput = require(script.Parent.Parent.isGamepadInput)

local function useIsGamepad(p)
	local v = p or UserInputService

	local function wasLastInputGamepad()
		return isGamepadInput((v:GetLastInputType()))
	end

	local state, setState = React.useState(wasLastInputGamepad)

	local v2 = React.useCallback(function(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= nil then
			setState(gamepadInput)
		end
	end)

	useExternalEvent(v.LastInputTypeChanged, v2)

	React.useEffect(function()
		setState(wasLastInputGamepad())
	end, {})

	return state
end

return useIsGamepad
