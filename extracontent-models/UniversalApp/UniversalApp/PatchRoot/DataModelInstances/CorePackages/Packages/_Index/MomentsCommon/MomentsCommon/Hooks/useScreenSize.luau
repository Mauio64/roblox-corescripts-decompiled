local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)

return function() -- line: 6
	-- upvalues: React (copy)
	local v3, v4 = React.useState(Vector2.new(1e999, 1e999))
	local v5, v6 = React.useState(workspace.CurrentCamera)

	React.useEffect(function() -- line: 10
		-- upvalues: v6 (copy), v5 (copy), v4 (copy)
		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 11
			-- upvalues: v6 (copy)
			v6(workspace.CurrentCamera)
		end)

		if v5 then
			v4(v5.ViewportSize)
		end

		return function() -- line: 19
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 24
		-- upvalues: v5 (copy), v4 (copy)
		if not v5 then
			return
		end

		local connection = v5:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 29
			-- upvalues: v5 (copy), v4 (copy)
			if v5 then
				v4(v5.ViewportSize)
			end
		end)

		return function() -- line: 35
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v5 })

	return v3
end
