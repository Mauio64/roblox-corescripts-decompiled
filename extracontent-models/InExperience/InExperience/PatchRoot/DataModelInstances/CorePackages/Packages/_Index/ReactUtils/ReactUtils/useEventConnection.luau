local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useEventConnection(p1, p2: ((...any) -> ...any), t1: {[any]: any}?) -- line: 7
	-- upvalues: React (copy)
	local v7 = React.useMemo(function() -- line: 8
		-- upvalues: p2 (copy)
		return p2
	end, t1)

	React.useEffect(function() -- line: 12
		-- upvalues: p1 (copy), v7 (copy)
		if p1 == nil then
			return nil
		end

		local connection = p1:Connect(v7)

		return function() -- line: 19
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		p1,
		v7
	})
end

return useEventConnection
