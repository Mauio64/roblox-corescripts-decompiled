local ParentParent = script:FindFirstAncestor("TiltLoadingScreen").Parent.Parent
local React = require(ParentParent.React)

local function useScreenSize() -- line: 7
	-- upvalues: React (copy)
	local v4, v5 = React.useState(function() -- line: 8
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			return CurrentCamera.ViewportSize
		end

		return (Vector2.new(0, 0))
	end)
	local v6, v7 = React.useState(workspace.CurrentCamera)

	React.useEffect(function() -- line: 14
		-- upvalues: v7 (copy)
		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 15
			-- upvalues: v7 (copy)
			v7(workspace.CurrentCamera)
		end)

		v7(workspace.CurrentCamera)

		return function() -- line: 21
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 26
		-- upvalues: v6 (copy), v5 (copy)
		if not v6 then
			return
		end

		v5(v6.ViewportSize)

		local connection = v6:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 32
			-- upvalues: v5 (copy), v6 (copy)
			v5(v6.ViewportSize)
		end)

		return function() -- line: 36
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v6 })

	return v4
end

return useScreenSize
