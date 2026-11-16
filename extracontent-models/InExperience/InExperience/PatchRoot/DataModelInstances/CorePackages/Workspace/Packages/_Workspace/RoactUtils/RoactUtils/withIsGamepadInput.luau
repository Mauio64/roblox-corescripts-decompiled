local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local useIsGamepad = require(script.Parent.Hooks.useIsGamepad)

local function withIsGamepadInput(p)
	return function(p2)
		local isGamepadInput = useIsGamepad()
		return React.createElement(p, Dash.join(p2, { isGamepadInput = isGamepadInput }))
	end
end

return withIsGamepadInput
