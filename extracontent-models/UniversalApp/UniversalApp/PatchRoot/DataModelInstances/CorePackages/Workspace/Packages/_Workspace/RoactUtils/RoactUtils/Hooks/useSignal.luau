local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

require(Parent.AppCommonLib)

local function useSignal(p1, p2: ((...any) -> ...any)) -- line: 15
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 16
		-- upvalues: p1 (copy), p2 (copy)
		if not p1 then
			return
		end

		assert(p1 ~= nil, "signal is not nil")

		local v6 = p1:connect(p2)

		return function() -- line: 23
			-- upvalues: v6 (copy)
			v6:disconnect()
		end
	end, {
		p1,
		p2
	})
end

return useSignal
