local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

return function(p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: React (copy)
	local v4 = React.useRef(false)
	local v5 = React.useRef(false)

	React.useEffect(function() -- line: 14
		-- upvalues: v4 (copy), v5 (copy), p1 (copy)
		if not v4.current then
			v4.current = true

			return
		end

		if not v5.current then
			v5.current = true
		end

		if p1 then
			p1()
		end
	end)

	return v5
end
