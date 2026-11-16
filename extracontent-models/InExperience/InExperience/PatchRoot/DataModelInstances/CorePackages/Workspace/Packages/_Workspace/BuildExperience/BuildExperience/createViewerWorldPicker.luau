local function toScreenPoint(p) -- 3 equivalent calls inferred from this helper
	return Vector2.new(p.Position.X, p.Position.Y)
end

local function raycast(camera, world, vector2: Vector2)
	local screenPointToRay = camera:ScreenPointToRay(vector2.X, vector2.Y)
	local filterDescendantsInstances = {}
	local terrain = world:FindFirstChildWhichIsA("Terrain")

	if terrain ~= nil then
		table.insert(filterDescendantsInstances, terrain)
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.BruteForceAllSlow = true

	for _ = 1, 50 do
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		local raycastResult = world:Raycast(screenPointToRay.Origin, screenPointToRay.Direction * 1000, raycastParams)

		if raycastResult == nil then
			return nil
		end

		local instance = raycastResult.Instance

		if instance:IsA("BasePart") and instance.Transparency < 1 then
			return instance
		end

		table.insert(filterDescendantsInstances, instance)
	end

	return nil
end

local function createViewerWorldPicker(data)
	local v = {}

	local function pick(input) -- 2 equivalent calls inferred from this helper
		local v2 = raycast(data.camera, data.world, toScreenPoint(input))

		if v2 ~= nil then
			data.onPick(v2)
		elseif data.onMiss ~= nil then
			data.onMiss()
		end
	end

	local v2 = {
		data.userInputService.InputBegan:Connect(function(input, gameProcessed: boolean)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not (gameProcessed or data.isBlocked()) then
					pick(input) -- inferred equivalent call
				end
			elseif input.UserInputType == Enum.UserInputType.Touch then
				local isGesture = gameProcessed or data.isBlocked() or next(v) ~= nil

				for _, v2 in v do
					v2.isGesture = true
				end

				v[input] = { start = toScreenPoint(input), isGesture = isGesture } -- inferred equivalent call
			end
		end),
		data.userInputService.InputChanged:Connect(function(input)
			local v2 = v[input]

			if v2 ~= nil and (toScreenPoint(input) - v2.start).Magnitude > 12 then -- inferred equivalent call
				v2.isGesture = true
			end
		end),
		data.userInputService.InputEnded:Connect(function(input, gameProcessed: boolean)
			local v2 = v[input]

			if v2 == nil then
				return
			end

			v[input] = nil

			if
				v2.isGesture
				or gameProcessed
				or input.UserInputState == Enum.UserInputState.Cancel
				or (toScreenPoint(input) - v2.start).Magnitude > 12 -- inferred equivalent call
				or data.isBlocked()
			then
				return
			end

			pick(input) -- inferred equivalent call
		end)
	}

	return function()
		for _, connection in v2 do
			connection:Disconnect()
		end

		table.clear(v)
	end
end

return createViewerWorldPicker
