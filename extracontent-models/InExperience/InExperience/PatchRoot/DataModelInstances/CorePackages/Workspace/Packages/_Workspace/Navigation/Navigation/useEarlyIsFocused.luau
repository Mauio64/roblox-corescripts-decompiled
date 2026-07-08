local Parent = script:FindFirstAncestor("Navigation").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useNavigation = require(script.Parent.useNavigation)

local function useEarlyIsFocused() -- line: 15
	-- upvalues: useNavigation (copy), React (copy), RoactNavigation (copy)
	local v6 = useNavigation()
	local v7, v8 = React.useState(v6.isFocused())

	React.useEffect(function() -- line: 20
		-- upvalues: v8 (copy), v6 (copy), RoactNavigation (copy)
		v8(v6.isFocused())

		local v9 = v6.addListener(RoactNavigation.Events.WillFocus, function() -- line: 24
			-- upvalues: v8 (copy)
			v8(true)
		end)
		local v10 = v6.addListener(RoactNavigation.Events.WillBlur, function() -- line: 28
			-- upvalues: v8 (copy)
			v8(false)
		end)

		return function() -- line: 32
			-- upvalues: v9 (copy), v10 (copy)
			v9.remove()
			v10.remove()
		end
	end, { v6 })

	return v7
end

return useEarlyIsFocused
