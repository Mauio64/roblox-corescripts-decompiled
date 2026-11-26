local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local vector2s = {
	[Enum.KeyCode.Left] = Vector2.new(-1, 0),
	[Enum.KeyCode.Right] = Vector2.new(1, 0),
	[Enum.KeyCode.Up] = Vector2.new(0, -1),
	[Enum.KeyCode.Down] = Vector2.new(0, 1)
}

local function getCameraDistance(p2, p3, p4)
	local v5 = not (p4.X > 0 and p4.Y > 0) and 1 or p4.X / p4.Y
	local v6 = math.atan(math.tan(math.rad(p2) / 2) * math.min(1, v5))
	return math.max(p3.Magnitude / 2, 0.01) / math.sin(v6)
end

local function ModelViewport(props)
	local v5 = useTokens()
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local ref = React.useRef(nil)
	local v6, v7 = Motion.useMotion({ size = UDim2.fromScale(1, 1) })
	local ref2 = React.useRef(v7)
	ref2.current = v7
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(0)
	local model = props.model
	local fieldOfView = props.fieldOfView or 30
	local cameraDistanceScale = props.cameraDistanceScale or 1
	local isInteractive = props.isInteractive == true

	local ref3 = React.useRef({
		yaw = 0.3490658503988659,
		pitch = -0.2617993877991494,
		zoom = 1,
		center = Vector3.new(0, 0, 0),
		baseDistance = 0,
		camera = nil,
		sourceModel = nil,
		dragInput = nil,
		lastDragPosition = nil
	})

	local v8 = React.useCallback(function()
		local current = ref3.current
		local camera = current.camera

		if camera == nil then
			return
		end

		local v9 = CFrame.fromEulerAnglesYXZ(current.pitch, current.yaw, 0) * Vector3.new(0, 0, current.baseDistance * current.zoom)
		camera.CFrame = CFrame.lookAt(current.center + v9, current.center)
	end, {})

	React.useEffect(function()
		local current = ref.current

		if current == nil or model == nil then
			return nil
		end

		local v9 = model:Clone()

		if v9 == nil then
			setState(model)
			local archivableChangedConnection = model:GetPropertyChangedSignal("Archivable"):Connect(function()
				setState2(function(p2)
					return p2 + 1
				end)
			end)
			return function()
				archivableChangedConnection:Disconnect()
			end
		else
			setState(nil)
			local worldModel = Instance.new("WorldModel")
			worldModel.Parent = current
			v9.Parent = worldModel

			local camera = Instance.new("Camera")
			camera.CameraType = Enum.CameraType.Scriptable
			camera.FieldOfView = fieldOfView
			camera.Parent = worldModel
			current.CurrentCamera = camera

			local current2 = ref3.current
			current2.camera = camera

			if current2.sourceModel ~= model then
				current2.yaw = 0.3490658503988659
				current2.pitch = -0.2617993877991494
				current2.zoom = 1
				current2.sourceModel = model
			end

			local boundingBox, v10 = v9:GetBoundingBox()
			v9:TranslateBy(-boundingBox.Position)
			current2.center = Vector3.new(0, 0, 0)

			local function updateFit()
				local v11 = current2
				local v13 = v10
				local absoluteSize = current.AbsoluteSize
				local v14 = not (absoluteSize.X > 0 and absoluteSize.Y > 0) and 1
					or absoluteSize.X / absoluteSize.Y
				local v15 = math.atan(math.tan(math.rad(fieldOfView) / 2) * math.min(1, v14))
				v11.baseDistance = math.max(v13.Magnitude / 2, 0.01) / math.sin(v15) * cameraDistanceScale
				v8()
			end
			local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateFit)
			local v12 = v10
			local absoluteSize = current.AbsoluteSize
			local v13 = not (absoluteSize.X > 0 and absoluteSize.Y > 0) and 1
				or absoluteSize.X / absoluteSize.Y
			local v14 = math.atan(math.tan(math.rad(fieldOfView) / 2) * math.min(1, v13))
			current2.baseDistance = math.max(v12.Magnitude / 2, 0.01) / math.sin(v14) * cameraDistanceScale
			v8()

			local flag = false
			local thread = nil
			local v15 = {}
			local function refreshPreview()
				thread = nil

				if flag then
					return
				end

				local clone = model:Clone()

				if clone == nil then
					return
				end

				local boundingBox2, v16 = clone:GetBoundingBox()
				clone:TranslateBy(-boundingBox2.Position)
				v9:Destroy()
				v9 = clone
				v9.Parent = worldModel
				v10 = v16
				local v17 = current2
				local v19 = v10
				local absoluteSize2 = current.AbsoluteSize
				local v20 = not (absoluteSize2.X > 0 and absoluteSize2.Y > 0) and 1
					or absoluteSize2.X / absoluteSize2.Y
				local v21 = math.atan(math.tan(math.rad(fieldOfView) / 2) * math.min(1, v20))
				v17.baseDistance = math.max(v19.Magnitude / 2, 0.01) / math.sin(v21) * cameraDistanceScale
				v8()
			end
			local function scheduleRefresh()
				if flag or thread ~= nil then
					return
				end

				thread = task.defer(refreshPreview)
			end
			local function observe(p2)
				if v15[p2] == nil then
					v15[p2] = p2.Changed:Connect(scheduleRefresh)
				end
			end

			local descendantAddedConnection, descendantRemovingConnection

			if isInteractive then
				local v16 = model

				if v15[v16] == nil then
					v15[v16] = v16.Changed:Connect(scheduleRefresh)
				end

				for i, descendant in model:GetDescendants() do
					if v15[descendant] == nil then
						v15[descendant] = descendant.Changed:Connect(scheduleRefresh)
					end
				end

				descendantAddedConnection = model.DescendantAdded:Connect(function(descendant)
					if v15[descendant] == nil then
						v15[descendant] = descendant.Changed:Connect(scheduleRefresh)
					end

					if not flag then
						if thread ~= nil then
							return
						end

						thread = task.defer(refreshPreview)
					end
				end)
				descendantRemovingConnection = model.DescendantRemoving:Connect(function(descendant)
					local connection = v15[descendant]

					if connection ~= nil then
						connection:Disconnect()
						v15[descendant] = nil
					end

					if not flag then
						if thread ~= nil then
							return
						end

						thread = task.defer(refreshPreview)
					end
				end)
			else
				descendantAddedConnection = nil
				descendantRemovingConnection = nil
			end

			return function()
				flag = true

				if thread ~= nil then
					task.cancel(thread)
				end

				if descendantAddedConnection then
					descendantAddedConnection:Disconnect()
				end

				if descendantRemovingConnection then
					descendantRemovingConnection:Disconnect()
				end

				for k, connection in v15 do
					connection:Disconnect()
				end

				absoluteSizeChangedConnection:Disconnect()
				current2.camera = nil
				current2.dragInput = nil
				current2.lastDragPosition = nil
				worldModel:Destroy()
			end
		end
	end, {
		model or false,
		fieldOfView,
		cameraDistanceScale,
		isInteractive,
		v8,
		state2
	})

	React.useEffect(function()
		local current = ref.current

		if current == nil or not isInteractive then
			return nil
		end

		local parent = current.Parent
		local v9 = false
		local function resizeViewport()
			local absoluteSize = parent.AbsoluteSize

			if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
				return
			end

			ref2.current(Motion.createState({
				size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
			}, {
				default = Motion.transition({
					duration = v9 and not reducedMotion and 0.25 or 0,
					easingStyle = Enum.EasingStyle.Quad
				})
			}))

			v9 = true
		end
		resizeViewport()
		local absoluteSizeChangedConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeViewport)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { isInteractive, reducedMotion })

	local v9 = React.useCallback(function(p2, dragInput)
		local current = ref3.current

		if not isInteractive or current.dragInput ~= nil then
			return
		end

		if
			dragInput.UserInputType == Enum.UserInputType.MouseButton1
			or dragInput.UserInputType == Enum.UserInputType.Touch
		then
			current.dragInput = dragInput
			current.lastDragPosition = dragInput.Position
		end
	end, { isInteractive })

	React.useEffect(function()
		if not isInteractive then
			return nil
		end

		local UserInputService = game:GetService("UserInputService")
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
			local current = ref3.current
			local dragInput = current.dragInput

			if dragInput == nil or current.lastDragPosition == nil then
				return
			end

			local v10

			if dragInput.UserInputType == Enum.UserInputType.MouseButton1 then
				v10 = input.UserInputType == Enum.UserInputType.MouseMovement
			else
				v10 = false
			end

			if not v10 and input ~= dragInput then
				return
			end

			local v11 = input.Position - current.lastDragPosition
			current.lastDragPosition = input.Position
			current.yaw -= v11.X * 0.01
			current.pitch = math.clamp(
				current.pitch - v11.Y * 0.01,
				-1.4835298641951802,
				1.4835298641951802
			)
			v8()
		end)
		local function clearDrag()
			ref3.current.dragInput = nil
			ref3.current.lastDragPosition = nil
		end
		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if ref3.current.dragInput == input then
				ref3.current.dragInput = nil
				ref3.current.lastDragPosition = nil
			end
		end)
		local windowFocusReleasedConnection = UserInputService.WindowFocusReleased:Connect(clearDrag)
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			local v10 = vector2s[input.KeyCode]

			if gameProcessed or v10 == nil then
				return
			end

			local current = ref3.current
			current.yaw -= v10.X * 0.2617993877991494
			current.pitch = math.clamp(
				current.pitch - v10.Y * 0.2617993877991494,
				-1.4835298641951802,
				1.4835298641951802
			)
			v8()
		end)
		return function()
			inputBeganConnection:Disconnect()
			inputChangedConnection:Disconnect()
			inputEndedConnection:Disconnect()
			windowFocusReleasedConnection:Disconnect()
			ref3.current.dragInput = nil
			ref3.current.lastDragPosition = nil
		end
	end, { isInteractive, v8 })

	local v10 = React.useCallback(function(p2, p3)
		local current = ref3.current

		if
			isInteractive
			and current.dragInput == nil
			and p3.UserInputType == Enum.UserInputType.MouseWheel
		then
			current.zoom = math.clamp(current.zoom - p3.Position.Z * 0.12, 0.4, 2.5)
			v8()
		end
	end, { isInteractive, v8 })

	local createElement = React.createElement
	local v12 = {
		Size = props.size or UDim2.fromScale(1, 1),
		backgroundStyle = props.backgroundTransparency ~= nil and {
			Color3 = v5.Color.Surface.Surface_200.Color3,
			Transparency = props.backgroundTransparency
		} or nil,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local v14

	if not (model == nil or state ~= model) then
		local createElement2 = React.createElement
		local text = Foundation.Text
		local v15 = {
			Text = props.unavailableText,
			tag = "size-full padding-small text-body-small text-wrap text-align-x-center content-default",
			testId = 0
		}

		local v16 = if props.testId ~= nil then `{props.testId}.Unavailable` else nil
		v15.testId = v16
		v14 = createElement2(text, v15)
	end

	local createElement2 = React.createElement
	local v16 = {
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		["Visible"] = nil,
		Visible = model == nil or state ~= model
	}
	local v17 = if isInteractive then v6.size else UDim2.fromScale(1, 1)
	v16.Size = v17
	v16.BackgroundColor3 = v5.Color.Surface.Surface_200.Color3
	v16.BackgroundTransparency = props.backgroundTransparency or v5.Color.Surface.Surface_200.Transparency
	v16.BorderSizePixel = 0
	v16.Active = isInteractive
	v16.ref = ref
	local tag = React.Tag
	local v18 = if props.testId ~= nil then `data-testid={props.testId}.Viewport` else nil
	v16[tag] = v18
	v16[React.Event.InputBegan] = v9
	v16[React.Event.InputChanged] = v10
	return createElement(view, v12, {
		Unavailable = v14,
		Viewport = createElement2("ViewportFrame", v16)
	})
end

return React.memo(ModelViewport)
