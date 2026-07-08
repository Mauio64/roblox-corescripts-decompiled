local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)

local function useGetAndSetRef(p1) -- line: 5
	-- upvalues: React (copy)
	local v5 = React.useRef(p1)

	return React.useCallback(function() -- line: 7
		-- upvalues: v5 (copy)
		return v5.current
	end, {}), (React.useCallback(function(p2) -- line: 10
		-- upvalues: v5 (copy)
		if typeof(p2) == "function" then
			v5.current = p2(v5.current)

			return
		end

		v5.current = p2
	end, {}))
end

return useGetAndSetRef
