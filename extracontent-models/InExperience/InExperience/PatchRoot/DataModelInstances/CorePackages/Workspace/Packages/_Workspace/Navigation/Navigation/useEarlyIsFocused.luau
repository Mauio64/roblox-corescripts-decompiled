local parent = script:FindFirstAncestor("Navigation").Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local useNavigation = require(script.Parent.useNavigation)

local function useEarlyIsFocused()
	local v = useNavigation()

	local state, setState = React.useState(v.isFocused())

	React.useEffect(function()
		setState(v.isFocused())

		local v2 = v.addListener(RoactNavigation.Events.WillFocus, function()
			setState(true)
		end)

		local v3 = v.addListener(RoactNavigation.Events.WillBlur, function()
			setState(false)
		end)

		return function()
			v2.remove()
			v3.remove()
		end
	end, { v })

	return state
end

return useEarlyIsFocused
