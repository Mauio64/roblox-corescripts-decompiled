local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Motion = require(parent.Motion)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local vector2s = {
	[Enum.KeyCode.Left] = Vector2.new(-1, 0),
	[Enum.KeyCode.Right] = Vector2.new(1, 0),
	[Enum.KeyCode.Up] = Vector2.new(0, -1),
	[Enum.KeyCode.Down] = Vector2.new(0, 1)
}

local function getCameraDistance(fieldOfView: number, vector3: Vector3, absoluteSize: Vector2) -- 1 equivalent call inferred from this helper
	local v = not (absoluteSize.X > 0 and absoluteSize.Y > 0) and 1 or absoluteSize.X / absoluteSize.Y
	local v2 = math.atan(math.tan(math.rad(fieldOfView) / 2) * math.min(1, v))
	return math.max(vector3.Magnitude / 2, 0.01) / math.sin(v2)
end

local function ModelViewport(props)
	local v = useTokens()
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local ref = React.useRef(nil)
	local v2, current3 = Motion.useMotion({ size = UDim2.fromScale(1, 1) })
	local ref2 = React.useRef(current3)
	ref2.current = current3
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

	local v3 = React.useCallback(function()
		local current = ref3.current
		local camera = current.camera

		if camera == nil then
			return
		end

		local v3 = CFrame.fromEulerAnglesYXZ(current.pitch, current.yaw, 0) * Vector3.new(0, 0, current.baseDistance * current.zoom)
		camera.CFrame = CFrame.lookAt(current.center + v3, current.center)
	end, {})

	React.useEffect(function()
		local current = ref.current

		if current == nil or model == nil then
			return nil
		end

		local v4 = model:Clone()

		if v4 == nil then
			setState(model)
			local archivableChangedConnection = model:GetPropertyChangedSignal("Archivable"):Connect(function()
				setState2(function(p)
					return p + 1
				end)
			end)
			return function()
				archivableChangedConnection:Disconnect()
			end
		else
			setState(nil)
			local worldModel = Instance.new("WorldModel")
			worldModel.Parent = current
			v4.Parent = worldModel

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

			local boundingBox, v5 = v4:GetBoundingBox()
			v4:TranslateBy(-boundingBox.Position)
			current2.center = Vector3.new(0, 0, 0)

			local function updateFit() -- 2 equivalent calls inferred from this helper
				current2.baseDistance = getCameraDistance(fieldOfView, v5, current.AbsoluteSize) * cameraDistanceScale -- inferred equivalent call
				v3()
			end
			local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateFit)
			updateFit() -- inferred equivalent call
			local flag = false
			local thread = nil
			local v6 = {}
			local function refreshPreview()
				thread = nil

				if flag then
					return
				end

				local clone = model:Clone()

				if clone == nil then
					return
				end

				local boundingBox2, v7 = clone:GetBoundingBox()
				clone:TranslateBy(-boundingBox2.Position)
				v4:Destroy()
				v4 = clone
				v4.Parent = worldModel
				v5 = v7
				updateFit() -- inferred equivalent call
			end
			local function scheduleRefresh()
				if flag or thread ~= nil then
					return
				end

				thread = task.defer(refreshPreview)
			end
			local function observe(p) -- 3 equivalent calls inferred from this helper
				if v6[p] == nil then
					v6[p] = p.Changed:Connect(scheduleRefresh)
				end
			end

			local descendantAddedConnection, descendantRemovingConnection

			if isInteractive then
				observe(model) -- inferred equivalent call

				for _, descendant in model:GetDescendants() do
					observe(descendant) -- inferred equivalent call
				end

				descendantAddedConnection = model.DescendantAdded:Connect(function(descendant)
					observe(descendant) -- inferred equivalent call

					if not flag then
						if thread ~= nil then
							return
						end

						thread = task.defer(refreshPreview)
					end
				end)
				descendantRemovingConnection = model.DescendantRemoving:Connect(function(descendant)
					local connection = v6[descendant]

					if connection ~= nil then
						connection:Disconnect()
						v6[descendant] = nil
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

				for _, connection in v6 do
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
		v3,
		state2
	})

	React.useEffect(function()
		local current = ref.current

		if current == nil or not isInteractive then
			return nil
		end

		local parent2 = current.Parent
		local v4 = false
		local function resizeViewport()
			local absoluteSize = parent2.AbsoluteSize

			if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
				return
			end

			ref2.current(Motion.createState({
				size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
			}, {
				default = Motion.transition({
					duration = v4 and not reducedMotion and 0.25 or 0,
					easingStyle = Enum.EasingStyle.Quad
				})
			}))

			v4 = true
		end
		resizeViewport()
		local absoluteSizeChangedConnection = parent2:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeViewport)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { isInteractive, reducedMotion })

	local v4 = React.useCallback(function(_, dragInput)
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

			local v5

			if dragInput.UserInputType == Enum.UserInputType.MouseButton1 then
				v5 = input.UserInputType == Enum.UserInputType.MouseMovement
			else
				v5 = false
			end

			if not v5 and input ~= dragInput then
				return
			end

			local v6 = input.Position - current.lastDragPosition
			current.lastDragPosition = input.Position
			current.yaw -= v6.X * 0.01
			current.pitch = math.clamp(current.pitch - v6.Y * 0.01, -1.4835298641951802, 1.4835298641951802)
			v3()
		end)
		local function clearDrag() -- 2 equivalent calls inferred from this helper
			ref3.current.dragInput = nil
			ref3.current.lastDragPosition = nil
		end
		local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if ref3.current.dragInput == input then
				clearDrag() -- inferred equivalent call
			end
		end)
		local windowFocusReleasedConnection = UserInputService.WindowFocusReleased:Connect(clearDrag)
		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed: boolean)
			local v5 = vector2s[input.KeyCode]

			if gameProcessed or v5 == nil then
				return
			end

			local current = ref3.current
			current.yaw -= v5.X * 0.2617993877991494
			current.pitch = math.clamp(
				current.pitch - v5.Y * 0.2617993877991494,
				-1.4835298641951802,
				1.4835298641951802
			)
			v3()
		end)
		return function()
			inputBeganConnection:Disconnect()
			inputChangedConnection:Disconnect()
			inputEndedConnection:Disconnect()
			windowFocusReleasedConnection:Disconnect()
			clearDrag() -- inferred equivalent call
		end
	end, { isInteractive, v3 })

	local v5 = React.useCallback(function(_, p)
		local current = ref3.current

		if isInteractive and current.dragInput == nil and p.UserInputType == Enum.UserInputType.MouseWheel then
			current.zoom = math.clamp(current.zoom - p.Position.Z * 0.12, 0.4, 2.5)
			v3()
		end
	end, { isInteractive, v3 })

	local createElement = React.createElement
	local v6 = {
		Size = props.size or UDim2.fromScale(1, 1),
		backgroundStyle = props.backgroundTransparency ~= nil and {
			Color3 = v.Color.Surface.Surface_200.Color3,
			Transparency = props.backgroundTransparency
		} or nil,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local unavailable

	if not (model == nil or state ~= model) then
		local createElement2 = React.createElement
		local text = Foundation.Text
		local v7 = {
			Text = props.unavailableText,
			tag = "size-full padding-small text-body-small text-wrap text-align-x-center content-default",
			testId = 0
		}
		local testId

		if props.testId ~= nil then
			testId = `{props.testId}.Unavailable`
		end

		v7.testId = testId
		unavailable = createElement2(text, v7)
	end

	local createElement2 = React.createElement
	local v7 = {
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
	local size

	if isInteractive then
		size = v2.size
	else
		size = UDim2.fromScale(1, 1)
	end

	v7.Size = size
	v7.BackgroundColor3 = v.Color.Surface.Surface_200.Color3
	v7.BackgroundTransparency = props.backgroundTransparency or v.Color.Surface.Surface_200.Transparency
	v7.BorderSizePixel = 0
	v7.Active = isInteractive
	v7.ref = ref
	local tag = React.Tag
	local v8

	if props.testId ~= nil then
		v8 = `data-testid={props.testId}.Viewport`
	end

	v7[tag] = v8
	v7[React.Event.InputBegan] = v4
	v7[React.Event.InputChanged] = v5
	return createElement(View, v6, {
		Unavailable = unavailable,
		Viewport = createElement2("ViewportFrame", v7)
	})
end

return React.memo(ModelViewport)
