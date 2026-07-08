local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useForwardRef(p1, p2: ((...any) -> ...any)) -- line: 29
	-- upvalues: React (copy)
	local v6 = React.useRef(nil)
	local v7 = React.useRef(nil)
	local v8 = React.useCallback(function(p3) -- line: 33
		-- upvalues: v7 (copy), v6 (copy), p2 (copy)
		if v7.current then
			v7.current()
			v7.current = nil
		end

		if p3 then
			v6.current = p3
			v7.current = p2(p3)
		end
	end, { p2 })

	React.useImperativeHandle(p1, function() -- line: 44
		-- upvalues: v6 (copy)
		return v6.current
	end)

	return v8
end

return useForwardRef
