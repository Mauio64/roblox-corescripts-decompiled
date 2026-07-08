local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)

local function useToggleState(p1) -- line: 14
	-- upvalues: React (copy)
	local v5, v6 = React.useState(p1 or false)
	local v7 = React.useCallback(function() -- line: 17
		-- upvalues: v6 (copy)
		v6(true)
	end, {})
	local v8 = React.useCallback(function() -- line: 21
		-- upvalues: v6 (copy)
		v6(false)
	end, {})
	local v9 = React.useCallback(function() -- line: 25
		-- upvalues: v6 (copy)
		v6(function(p2) -- line: 26
			return not p2
		end)
	end, {})

	return {
		enabled = v5,
		enable = v7,
		disable = v8,
		toggle = v9,
		set = v6
	}
end

return useToggleState
