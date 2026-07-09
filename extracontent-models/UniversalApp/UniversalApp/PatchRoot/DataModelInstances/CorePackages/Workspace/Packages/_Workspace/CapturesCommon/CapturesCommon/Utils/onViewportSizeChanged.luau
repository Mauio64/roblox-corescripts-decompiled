return function(p1: ((...any) -> ...any)) -- line: 1
	local u2 = nil
	local u3 = nil

	local function fireCallback(vector2: Vector2) -- line: 6
		-- upvalues: u2 (ref), p1 (copy)
		if vector2 ~= u2 then
			u2 = vector2
			p1(vector2)
		end
	end
	local function onViewportSizeChanged() -- line: 13
		-- upvalues: u2 (ref), p1 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			local ViewportSize = CurrentCamera.ViewportSize

			if ViewportSize ~= u2 then
				u2 = ViewportSize
				p1(ViewportSize)
			end
		end
	end
	local function onCurrentCameraChanged() -- line: 20
		-- upvalues: u3 (ref), onViewportSizeChanged (copy), u2 (ref), p1 (copy)
		if u3 then
			u3:Disconnect()
			u3 = nil
		end

		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			u3 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

			local CurrentCamera2 = workspace.CurrentCamera

			if CurrentCamera2 then
				local ViewportSize = CurrentCamera2.ViewportSize

				if ViewportSize ~= u2 then
					u2 = ViewportSize
					p1(ViewportSize)
				end
			end
		end
	end

	local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

	if u3 then
		u3:Disconnect()
		u3 = nil
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		u3 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)

		local CurrentCamera3 = workspace.CurrentCamera

		if CurrentCamera3 then
			local ViewportSize = CurrentCamera3.ViewportSize

			if ViewportSize ~= u2 then
				u2 = ViewportSize
				p1(ViewportSize)
			end
		end
	end

	return function() -- line: 37
		-- upvalues: connection (ref), u3 (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if u3 then
			u3:Disconnect()
			u3 = nil
		end
	end
end
