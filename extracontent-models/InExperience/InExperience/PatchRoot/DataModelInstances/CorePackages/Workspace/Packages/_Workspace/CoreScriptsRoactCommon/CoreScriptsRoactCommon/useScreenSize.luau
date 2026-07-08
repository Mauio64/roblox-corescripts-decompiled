local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

return function() -- line: 6
	-- upvalues: React (copy)
	local v3, v4 = React.useState(Vector2.new(0, 0))
	local v5, v6 = React.useState(workspace.CurrentCamera)

	React.useEffect(function() -- line: 10
		-- upvalues: v6 (copy)
		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 11
			-- upvalues: v6 (copy)
			v6(workspace.CurrentCamera)
		end)

		v6(workspace.CurrentCamera)

		return function() -- line: 17
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 22
		-- upvalues: v5 (copy), v4 (copy)
		if not v5 then
			return
		end

		v4(v5.ViewportSize)

		local connection = v5:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 28
			-- upvalues: v4 (copy), v5 (copy)
			v4(v5.ViewportSize)
		end)

		return function() -- line: 32
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v5 })

	return v3
end
