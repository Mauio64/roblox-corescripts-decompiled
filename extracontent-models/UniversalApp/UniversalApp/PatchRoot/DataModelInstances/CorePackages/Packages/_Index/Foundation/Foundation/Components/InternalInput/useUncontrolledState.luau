local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function useUncontrolledState(b1: boolean?, p1: ((...any) -> ...any)) -- line: 6
	-- upvalues: React (copy)
	local v6, v7 = React.useState(b1 or false)

	React.useEffect(function() -- line: 8
		-- upvalues: b1 (copy), v7 (copy)
		if b1 ~= nil then
			v7(b1)
		end
	end, { b1 })

	return v6, (React.useCallback(function(b2: boolean) -- line: 14
		-- upvalues: b1 (copy), v7 (copy), p1 (copy)
		if b1 == nil then
			v7(b2)
		end

		p1(b2)
	end, {
		b1,
		p1
	}))
end

return useUncontrolledState
