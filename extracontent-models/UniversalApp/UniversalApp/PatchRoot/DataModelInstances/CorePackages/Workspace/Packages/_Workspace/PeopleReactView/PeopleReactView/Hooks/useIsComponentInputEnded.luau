local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local React = require(Parent.React)

return function(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy)
	local v4, v5 = React.useState(false)

	React.useEffect(function() -- line: 13
		-- upvalues: t1 (copy), v5 (copy)
		local connection = nil
		local connection2 = nil

		if t1.current then
			connection = t1.current.InputBegan:Connect(function() -- line: 18
				-- upvalues: v5 (copy)
				v5(false)
			end)
			connection2 = t1.current.InputEnded:Connect(function() -- line: 21
				-- upvalues: v5 (copy)
				v5(true)
			end)
		end

		return function() -- line: 26
			-- upvalues: connection (ref), connection2 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {})

	return v4
end
