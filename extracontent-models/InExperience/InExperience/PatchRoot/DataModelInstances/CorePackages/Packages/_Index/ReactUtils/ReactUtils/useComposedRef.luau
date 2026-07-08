local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function forwardRefValue(p1, p2) -- line: 9
	if type(p1) == "function" then
		p1(p2)

		return
	end

	if type(p1) == "table" then
		p1.current = p2
	end
end
local function useComposedRef(p3, p4) -- line: 22
	-- upvalues: React (copy)
	return (React.useCallback(function(p5) -- line: 23
		-- upvalues: p3 (copy), p4 (copy)
		local v10 = p3

		if type(v10) == "function" then
			v10(p5)
		elseif type(v10) == "table" then
			v10.current = p5
		end

		local v11 = p4

		if type(v11) == "function" then
			v11(p5)

			return
		end

		if type(v11) == "table" then
			v11.current = p5
		end
	end, {
		p3,
		p4
	}))
end

return useComposedRef
