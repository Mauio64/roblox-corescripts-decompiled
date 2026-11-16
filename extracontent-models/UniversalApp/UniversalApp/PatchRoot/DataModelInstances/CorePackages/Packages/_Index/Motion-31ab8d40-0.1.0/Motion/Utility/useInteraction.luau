local parent = script.Parent.Parent.Parent
local React = require(parent.React)

local function useInteraction(callback)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	return {
		onInputBegan = function(_, p)
			if p.UserInputType == Enum.UserInputType.MouseButton1 then
				setState(true)
			end
		end,
		onInputEnded = function(_, p)
			if p.UserInputType == Enum.UserInputType.MouseButton1 then
				if state and state2 then
					callback()
				end

				setState(false)
			end
		end,
		onMouseEnter = function()
			setState2(true)
		end,
		onMouseLeave = function()
			setState2(false)
			setState(false)
		end
	}, state, state2
end

return useInteraction
