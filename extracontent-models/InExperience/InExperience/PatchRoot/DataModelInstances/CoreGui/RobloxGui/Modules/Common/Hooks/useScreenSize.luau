local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function() -- line: 4
	-- upvalues: React (copy)
	local connection = nil
	local u4 = nil
	local v5, v6 = React.useState(Vector2.new(0, 0))

	local function v7() -- line: 9
		-- upvalues: v6 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			v6(Vector2.new(CurrentCamera.ViewportSize.X, CurrentCamera.ViewportSize.Y))
		end
	end
	local function v8() -- line: 16
		-- upvalues: u4 (ref), v7 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if u4 then
			pcall(function() -- line: 20
				-- upvalues: u4 (ref)
				u4:Disconnect()
			end)
			u4 = nil
		end

		if CurrentCamera then
			u4 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v7)
		end
	end

	React.useEffect(function() -- line: 31
		-- upvalues: connection (ref), v8 (copy), v6 (copy), u4 (ref)
		connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v8)
		v8()

		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			v6(Vector2.new(CurrentCamera.ViewportSize.X, CurrentCamera.ViewportSize.Y))
		end

		return function() -- line: 36
			-- upvalues: connection (ref), u4 (ref)
			if connection then
				connection:Disconnect()
			end

			if u4 then
				u4:Disconnect()
			end
		end
	end, {})

	return v5
end
