local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local useIsGamepad = require(script.Parent.Hooks.useIsGamepad)

local function withIsGamepadInput(p1) -- line: 12
	-- upvalues: useIsGamepad (copy), React (copy), Dash (copy)
	return function(p2) -- line: 13
		-- upvalues: useIsGamepad (copy), React (copy), p1 (copy), Dash (copy)
		local v8 = useIsGamepad()

		return React.createElement(p1, Dash.join(p2, {
			isGamepadInput = v8
		}))
	end
end

return withIsGamepadInput
