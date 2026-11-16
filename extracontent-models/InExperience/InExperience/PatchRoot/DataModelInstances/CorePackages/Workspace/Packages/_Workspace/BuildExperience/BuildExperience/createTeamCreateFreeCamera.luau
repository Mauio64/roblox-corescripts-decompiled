local function createInputAction(parent, name: string, p, items)
	local inputAction = Instance.new("InputAction")
	inputAction.Name = name
	inputAction.Type = p

	for _, item in items do
		local inputBinding = Instance.new("InputBinding")
		inputBinding.KeyCode = item.KeyCode or Enum.KeyCode.None
		inputBinding.PrimaryModifier = item.PrimaryModifier or Enum.KeyCode.None
		inputBinding.Up = item.Up or Enum.KeyCode.None
		inputBinding.Down = item.Down or Enum.KeyCode.None
		inputBinding.Left = item.Left or Enum.KeyCode.None
		inputBinding.Right = item.Right or Enum.KeyCode.None
		inputBinding.Vector2Scale = item.Vector2Scale or Vector2.one
		inputBinding.Parent = inputAction
	end

	inputAction.Parent = parent
	return inputAction
end

local function getFocusCFrame(position: Vector3, p: number, rect: Rect?, viewportSize: Vector2, fieldOfView: number, model, flag: boolean)
	local rotation = CFrame.lookAt(Vector3.new(0.5, 0.5, 1), Vector3.new(0, 0, 0)).Rotation

	if rect == nil or viewportSize.X <= 1 or viewportSize.Y <= 1 then
		local v = math.max(10, p * 2.5)
		return CFrame.lookAt(position + Vector3.new(v * 0.5, v * 0.5, v), position)
	end

	local width = rect.Width
	local height = rect.Height

	if width <= 1 or height <= 1 then
		return nil
	end

	local v = math.min(32, width / 4, height / 4)
	local v2 = math.tan(math.rad(fieldOfView) / 2) * 2 / viewportSize.Y
	local v3 = (rect.Min.X + v - viewportSize.X / 2) * v2
	local v4 = (rect.Max.X - v - viewportSize.X / 2) * v2
	local v5 = (viewportSize.Y / 2 - rect.Max.Y + v) * v2
	local v6 = (viewportSize.Y / 2 - rect.Min.Y - v) * v2
	local midpoint = (v3 + v4) / 2
	local midpoint2 = (v5 + v6) / 2
	local v7 = math.max(
		10,
		p * math.sqrt(1 + v3 * v3) / (midpoint - v3),
		p * math.sqrt(1 + v4 * v4) / (v4 - midpoint),
		p * math.sqrt(1 + v5 * v5) / (midpoint2 - v5),
		p * math.sqrt(1 + v6 * v6) / (v6 - midpoint2)
	)

	if flag and model ~= nil then
		local boundingBox, v8 = model:GetBoundingBox()
		local v9 = 10

		for i = -1, 1, 2 do
			for j = -1, 1, 2 do
				for k = -1, 1, 2 do
					local vectorToObjectSpace = rotation:VectorToObjectSpace(boundingBox:PointToWorldSpace(v8 * Vector3.new(i, j, k) / 2) - position)
					v9 = math.max(
						v9,
						vectorToObjectSpace.Z + 1,
						(-vectorToObjectSpace.X - v3 * vectorToObjectSpace.Z) / (midpoint - v3),
						(vectorToObjectSpace.X + v4 * vectorToObjectSpace.Z) / (v4 - midpoint),
						(-vectorToObjectSpace.Y - v5 * vectorToObjectSpace.Z) / (midpoint2 - v5),
						(vectorToObjectSpace.Y + v6 * vectorToObjectSpace.Z) / (v6 - midpoint2)
					)
				end
			end
		end

		v7 = math.max(v7 / 1.5, v9)
	end

	local vectorToWorldSpace = rotation:VectorToWorldSpace((Vector3.new(midpoint * v7, midpoint2 * v7, -v7)))
	return CFrame.new(position - vectorToWorldSpace) * rotation
end

local function getRecenteredCFrame(vector3: Vector3, cframe: CFrame, rect: Rect, viewportSize: Vector2, fieldOfView: number)
	local v = -cframe:PointToObjectSpace(vector3).Z

	if v <= 0 or rect.Width <= 1 or rect.Height <= 1 or viewportSize.X <= 1 or viewportSize.Y <= 1 then
		return nil
	end

	local v2 = math.tan(math.rad(fieldOfView) / 2) * 2 / viewportSize.Y
	local midpoint = (rect.Min + rect.Max) / 2
	local rotation = cframe.Rotation
	local vectorToWorldSpace = rotation:VectorToWorldSpace((Vector3.new(
		(midpoint.X - viewportSize.X / 2) * v2 * v,
		(viewportSize.Y / 2 - midpoint.Y) * v2 * v,
		-v
	)))

	return CFrame.new(vector3 - vectorToWorldSpace) * rotation
end

local function createTeamCreateFreeCamera(state, object, data, p, callback)
	local v = p or game:GetService("GuiService")
	local v2 = callback or createInputAction
	state.CameraType = Enum.CameraType.Scriptable
	state.CFrame = CFrame.new(0, 150, 300) * CFrame.Angles(-0.2617993877991494, 0, 0)

	local v3 = 0
	local v4, v5 = state.CFrame:ToEulerAnglesYXZ()
	local position = nil
	local v6 = 0
	local model = nil
	local v7 = false
	local flag = false
	local v8 = nil
	local v9 = nil
	local v10 = state.ViewportSize
	local fieldOfView = state.FieldOfView
	local total = 0
	local v11 = false
	local v12 = nil
	local v13 = nil
	local v14 = {}
	local flag2 = false

	local function isInputBlocked() -- 2 equivalent calls inferred from this helper
		return data.getIsOpen() or object:GetFocusedTextBox() ~= nil
	end

	local function isChatUsingInput(): boolean
		if not data.getIsChatOpen() then
			return false
		end

		if v.SelectedObject ~= nil then
			return true
		end

		local worldChatTop = data.getWorldChatTop()
		local worldChatLeft = data.getWorldChatLeft()
		local guiInset = v:GetGuiInset()
		local mouseLocation = object:GetMouseLocation()

		if worldChatTop == nil or not (mouseLocation.Y >= worldChatTop + guiInset.Y) then
			if worldChatLeft == nil then
				return false
			end

			return mouseLocation.X >= worldChatLeft + guiInset.X
		end

		return true
	end

	local teamCreateFreeCamera = Instance.new("InputContext")
	teamCreateFreeCamera.Name = "TeamCreateFreeCamera"
	teamCreateFreeCamera.Priority = 1000
	teamCreateFreeCamera.Sink = true
	teamCreateFreeCamera.Enabled = not data.getIsOpen() and object:GetFocusedTextBox() == nil

	teamCreateFreeCamera.Parent = game:GetService("CoreGui")

	local v15 = v2(teamCreateFreeCamera, "Move", Enum.InputActionType.Direction2D, {
		{
			Up = Enum.KeyCode.W,
			Down = Enum.KeyCode.S,
			Left = Enum.KeyCode.A,
			Right = Enum.KeyCode.D
		},
		{
			Up = Enum.KeyCode.Up,
			Down = Enum.KeyCode.Down,
			Left = Enum.KeyCode.Left,
			Right = Enum.KeyCode.Right
		},
		{ KeyCode = Enum.KeyCode.Thumbstick1 }
	})

	local v16 = v2(teamCreateFreeCamera, "Elevate", Enum.InputActionType.Direction1D, {
		{ Up = Enum.KeyCode.E, Down = Enum.KeyCode.Q },
		{ Up = Enum.KeyCode.ButtonR2, Down = Enum.KeyCode.ButtonL2 }
	})

	local v17 = v2(teamCreateFreeCamera, "Sprint", Enum.InputActionType.Bool, {
		{ KeyCode = Enum.KeyCode.LeftShift },
		{ KeyCode = Enum.KeyCode.RightShift }
	})

	local v18 = v2(teamCreateFreeCamera, "Look", Enum.InputActionType.Bool, {
		{ KeyCode = Enum.KeyCode.MouseRightButton }
	})

	local v19 = v2(teamCreateFreeCamera, "Pan", Enum.InputActionType.Direction2D, {
		{
			KeyCode = Enum.KeyCode.MouseDelta,
			PrimaryModifier = Enum.KeyCode.MouseRightButton,
			Vector2Scale = Vector2.new(-0.003, -0.003)
		},
		{ KeyCode = Enum.KeyCode.TrackpadPan, Vector2Scale = Vector2.new(-0.042, -0.042) },
		{ KeyCode = Enum.KeyCode.Thumbstick2, Vector2Scale = Vector2.new(-2.5, 2.5) }
	})

	local function isTouchGestureBlocked(flag3: boolean)
		for _, v20 in v14 do
			if v20 then
				return true
			end
		end

		return flag3
	end

	local touchStartedConnection = object.TouchStarted:Connect(function(p2, flag3: boolean)
		if flag2 then
			return
		end

		v14[p2] = flag3 or isInputBlocked() -- inferred equivalent call

		if v14[p2] then
			v13 = nil
			v12 = nil
		end
	end)

	local touchEndedConnection = object.TouchEnded:Connect(function(otherPart)
		v14[otherPart] = nil
	end)

	local touchPanConnection = object.TouchPan:Connect(function(list, vector2: Vector2, _: Vector2, p2, flag3: boolean)
		if not flag2 then
			for _, v20 in v14 do
				if v20 then
					flag3 = true
					break
				end
			end

			if
				not flag3
				and not data.getIsOpen()
				and object:GetFocusedTextBox() == nil
				and #list == 1
				and v12 == nil
				and p2 ~= Enum.UserInputState.End
				and p2 ~= Enum.UserInputState.Cancel
			then
				if p2 == Enum.UserInputState.Begin then
					v13 = vector2
					return
				end

				if p2 ~= Enum.UserInputState.Change or v13 == nil then
					return
				end

				local v20 = vector2 - v13
				v13 = vector2

				if v20.Magnitude > 0 then
					v7 = false
					v8 = nil
				end

				v5 -= v20.X * 0.003
				v4 = math.clamp(v4 - v20.Y * 0.003, -1.5676547341413067, 1.5676547341413067)
				state.CFrame = CFrame.new(state.CFrame.Position) * CFrame.fromEulerAnglesYXZ(v4, v5, 0)

				return
			end
		end

		v13 = nil
	end)

	local touchPinchConnection = object.TouchPinch:Connect(function(_, scale: number, _: number, p2, flag3: boolean)
		if not flag2 then
			for _, v20 in v14 do
				if v20 then
					flag3 = true
					break
				end
			end

			if
				not flag3
				and not data.getIsOpen()
				and object:GetFocusedTextBox() == nil
				and p2 ~= Enum.UserInputState.End
				and p2 ~= Enum.UserInputState.Cancel
			then
				if not (scale > 0 and scale < 1e999) then
					return
				end

				if p2 == Enum.UserInputState.Begin then
					v13 = nil
					v12 = {
						cframe = state.CFrame,
						distance = position == nil and 300 or math.max(1, (state.CFrame.Position - position).Magnitude),
						scale = scale
					}
				elseif p2 == Enum.UserInputState.Change and v12 ~= nil then
					if scale ~= v12.scale then
						v7 = false
						v8 = nil
					end

					local v20 = math.clamp(v12.distance * (v12.scale / scale) ^ 0.35, 1, 100000)
					local v21 = v12.cframe.Position + v12.cframe.LookVector * (v12.distance - v20)
					state.CFrame = CFrame.new(v21) * v12.cframe.Rotation
				end

				return
			end
		end

		v12 = nil
	end)

	return {
		step = function(p2: number)
			if flag2 then
				return
			end

			local v20 = data.getWorldViewportRect()
			local worldChatTop = data.getWorldChatTop()
			local worldChatLeft = data.getWorldChatLeft()
			local viewportSize = state.ViewportSize
			local rect

			if v20 ~= nil then
				local guiInset = v:GetGuiInset()
				local rect2 = Rect.new(v20.Min + guiInset, v20.Max + guiInset)

				if worldChatTop ~= nil then
					worldChatTop += guiInset.Y
				end

				if worldChatLeft ~= nil then
					worldChatLeft += guiInset.X
				end

				local vector2 = Vector2.new(
					math.clamp(rect2.Min.X, 0, viewportSize.X),
					(math.clamp(rect2.Min.Y, 0, viewportSize.Y))
				)

				local v21 = math.max(vector2.X, (math.min(viewportSize.X, rect2.Max.X, worldChatLeft or 1e999)))
				local v22 = math.min(viewportSize.Y, rect2.Max.Y)

				v20 = Rect.new(vector2, Vector2.new(v21, (math.max(vector2.Y, (math.min(v22, worldChatTop or 1e999))))))

				local v23 = not object.OnScreenKeyboardVisible and 0 or object.OnScreenKeyboardSize.Y

				local v24 = math.min(v22, worldChatTop == nil and 1e999 or worldChatTop + v23)
				rect = Rect.new(
					vector2,
					Vector2.new(v21, (math.max(v24, (math.min(v22, vector2.Y + (v22 - vector2.Y) * 0.3)))))
				)
			end

			if v20 == v9 and viewportSize == v10 and state.FieldOfView == fieldOfView then
				total += p2
			else
				v9 = v20
				v10 = viewportSize
				fieldOfView = state.FieldOfView
				total = 0
				v11 = true
			end

			local focusRequest = data.getFocusRequest()

			if focusRequest == nil then
				position = nil
				model = nil
				v7 = false
				v8 = nil
			end

			local v21

			if focusRequest == nil then
				v21 = false
			else
				v21 = focusRequest.token ~= v3
			end

			if v21 and focusRequest ~= nil then
				v3 = focusRequest.token
				v8 = nil
				position = focusRequest.position
				v6 = focusRequest.radius
				model = focusRequest.model
				v7 = true
				flag = false
				v11 = true
				v12 = nil
				v13 = nil
				total = 0
			end

			local v22

			if v20 == nil then
				v22 = false
			else
				v22 = not data.getIsChatOpen() or worldChatTop ~= nil or worldChatLeft ~= nil
			end

			if position ~= nil and v22 and v7 and v11 and total >= 0.1 then
				v11 = false
				v12 = nil
				v13 = nil
				local target

				if flag then
					local v23 = position
					local v24

					if v8 == nil then
						v24 = state.CFrame
					else
						v24 = v8.target
					end

					target = getRecenteredCFrame(v23, v24, v20, viewportSize, state.FieldOfView)
				else
					target = getFocusCFrame(
						position,
						v6,
						rect,
						viewportSize,
						state.FieldOfView,
						model,
						worldChatTop ~= nil or worldChatLeft ~= nil
					)
				end

				if target ~= nil then
					flag = true
					v8 = { start = state.CFrame, target = target, elapsed = 0 }
				end
			end

			if v8 ~= nil then
				v8.elapsed += p2
				local v23 = math.clamp(v8.elapsed / 0.25, 0, 1)
				local v24 = v23 * v23 * (3 - v23 * 2)
				local cframe

				if v23 == 1 then
					cframe = v8.target
				else
					cframe = v8.start:Lerp(v8.target, v24)
				end

				state.CFrame = cframe

				v4, v5 = state.CFrame:ToEulerAnglesYXZ()

				if v23 == 1 then
					v8 = nil
				end
			end

			local inputBlocked = isInputBlocked() -- inferred equivalent call
			teamCreateFreeCamera.Enabled = not (inputBlocked or isChatUsingInput())

			if teamCreateFreeCamera.Enabled then
				local mouseBehavior

				if v18:GetState() then
					mouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				else
					mouseBehavior = Enum.MouseBehavior.Default
				end

				object.MouseBehavior = mouseBehavior

				local v23 = v19:GetState() * p2

				if v23.Magnitude > 0 then
					v7 = false
					v8 = nil
				end

				v5 += v23.X
				v4 = math.clamp(v4 + v23.Y, -1.5676547341413067, 1.5676547341413067)

				local cframe = CFrame.fromEulerAnglesYXZ(v4, v5, 0)
				local v24 = p2 * 50 * (v17:GetState() and 5 or 1)
				local state2 = v15:GetState()
				local v25 = state.CFrame.Position + (cframe.RightVector * state2.X + cframe.LookVector * state2.Y + Vector3.new(0, 1, 0) * v16:GetState()) * v24

				if v25 ~= state.CFrame.Position then
					v7 = false
					v8 = nil
				end

				state.CFrame = CFrame.new(v25) * cframe
			else
				if inputBlocked then
					v12 = nil
					v13 = nil
				end

				object.MouseBehavior = Enum.MouseBehavior.Default
			end
		end,
		destroy = function()
			flag2 = true
			teamCreateFreeCamera:Destroy()
			v8 = nil
			v12 = nil
			v13 = nil
			table.clear(v14)
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			touchPanConnection:Disconnect()
			touchPinchConnection:Disconnect()
			object.MouseBehavior = Enum.MouseBehavior.Default
		end
	}
end

return createTeamCreateFreeCamera
