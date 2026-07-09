local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)

return function() -- line: 21
	-- upvalues: React (copy)
	local v3, v4 = React.useState(function() -- line: 22
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			return CurrentCamera.ViewportSize
		end

		return (Vector2.new(1e999, 1e999))
	end)
	local v5, v6 = React.useState(workspace.CurrentCamera)

	React.useEffect(function() -- line: 28
		-- upvalues: v4 (copy), v6 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			v4(CurrentCamera.ViewportSize)
		end

		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 34
			-- upvalues: v6 (copy)
			v6(workspace.CurrentCamera)
		end)

		return function() -- line: 38
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 43
		-- upvalues: v5 (copy), v4 (copy)
		if not v5 then
			return
		end

		v4(v5.ViewportSize)

		local connection = v5:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 54
			-- upvalues: v5 (copy), v4 (copy)
			if v5 then
				v4(v5.ViewportSize)
			end
		end)

		return function() -- line: 60
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v5 })

	return v3
end
