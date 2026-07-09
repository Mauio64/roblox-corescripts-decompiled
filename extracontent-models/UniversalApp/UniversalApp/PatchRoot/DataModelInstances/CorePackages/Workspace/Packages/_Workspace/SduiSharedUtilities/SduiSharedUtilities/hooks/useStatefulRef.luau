local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)

local function useStatefulRef(p1) -- line: 5
	-- upvalues: React (copy)
	local v5, v6 = React.useState(nil)

	return v5, (React.useCallback(function(p2) -- line: 7
		-- upvalues: p1 (copy), v6 (copy)
		if typeof(p1) == "function" then
			p1(p2)
		elseif typeof(p1) == "table" then
			p1.current = p2
		end

		v6(p2)
	end, { p1 }))
end

return useStatefulRef
