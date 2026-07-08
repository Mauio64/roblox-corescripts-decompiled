local Parent = script:FindFirstAncestor("Navigation").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useNavigation = require(script.Parent.useNavigation)

local function useNavigationFocus() -- line: 13
	-- upvalues: useNavigation (copy), React (copy), RoactNavigation (copy)
	local v6 = useNavigation()
	local v7, v8 = React.useState(v6.isFocused())

	React.useEffect(function() -- line: 18
		-- upvalues: v6 (copy), RoactNavigation (copy), v8 (copy)
		local v9 = v6.addListener(RoactNavigation.Events.WillFocus, function() -- line: 19
			-- upvalues: v8 (copy)
			v8(true)
		end)
		local v10 = v6.addListener(RoactNavigation.Events.WillBlur, function() -- line: 22
			-- upvalues: v8 (copy)
			v8(false)
		end)

		v8(v6.isFocused())

		return function() -- line: 27
			-- upvalues: v9 (copy), v10 (copy)
			v9.remove()
			v10.remove()
		end
	end, {})

	return v7
end

return useNavigationFocus
