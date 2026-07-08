local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

local function useViewportSize() -- line: 6
	-- upvalues: React (copy)
	local CurrentCamera = workspace.CurrentCamera
	local v5 = if not CurrentCamera then Vector2.new(1280, 720) else CurrentCamera.ViewportSize
	local v6, v7 = React.useState(v5)

	React.useEffect(function() -- line: 11
		-- upvalues: v7 (copy)
		local CurrentCamera2 = workspace.CurrentCamera

		if not CurrentCamera2 then
			return function() -- line: 14
			end
		end

		v7(CurrentCamera2.ViewportSize)

		local connection = CurrentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 17
			-- upvalues: v7 (copy), CurrentCamera2 (copy)
			v7(CurrentCamera2.ViewportSize)
		end)

		return function() -- line: 20
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v6
end

return useViewportSize
