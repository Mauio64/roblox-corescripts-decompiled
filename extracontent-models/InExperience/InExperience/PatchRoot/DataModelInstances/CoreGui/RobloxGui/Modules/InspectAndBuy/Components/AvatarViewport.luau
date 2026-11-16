local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Colors = require(parent.Colors)
local CharacterModelPool = require(parent.CharacterModelPool)
local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local FFlagEnableNewAvatarViewportProps = require(parent.Flags.FFlagEnableNewAvatarViewportProps)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInspectAndBuyV2RootFlag = SharedFlags2.FFlagEnableInspectAndBuyV2RootFlag
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local extended = Roact.PureComponent:extend("AvatarViewport")

function extended:init()
	self.viewportFrameRef = Roact.createRef()
	self.worldModelRef = Roact.createRef()
	self.connections = {}
	self.xRotation = 0
	self.yRotation = 0
	self.rotationDeltaX = 0
	self.rotationDeltaY = 0
	self.mouseOrTouchDown = false
	self.delta = 0
	self.keys = {}
	self.lastPosition = Vector3.new(0, 0, 0)
	self.viewportCamera = Instance.new("Camera")
	self.viewportCamera.CameraType = Enum.CameraType.Scriptable
	self.model = self.props.model
	self.lastInputTime = 2
	local initialHrpPosition

	if self.props.model ~= nil then
		initialHrpPosition = self.props.model.HumanoidRootPart.Position or nil
	end

	self.initialHrpPosition = initialHrpPosition
end

function extended:didMount()
	if self.props.humanoidDescription and self.model then
		self.viewportCamera.Parent = self.viewportFrameRef.current
		self.viewportFrameRef.current.CurrentCamera = self.viewportCamera
		self:setRotation()

		local rigType = self.model.Humanoid.RigType
		self.characterModelPool = CharacterModelPool.new(self.worldModelRef, self.initialHrpPosition, rigType)
	end

	self.isMounted = true
	self:handleSpin()
	self:setUpGamepad()
end

function extended:didUpdate(p, _)
	if self.props.visible and self.props.humanoidDescription ~= p.humanoidDescription and self.model then
		if FFlagEnableNewAvatarViewportProps and self.props.resetCameraAndAutoRotationOnModelChange then
			self.xRotation = 0
			self.yRotation = 0

			if not self.props.disableAutoRotation then
				self.lastInputTime = tick()
			end
		end

		coroutine.wrap(function()
			self.characterModelPool:maybeUpdateCharacter(self.props.humanoidDescription)
		end)()
	end

	self.gamepadRotating = false
	self.viewportCamera.Parent = self.viewportFrameRef.current
	self.viewportFrameRef.current.CurrentCamera = self.viewportCamera

	if self.props.gamepadEnabled ~= p.gamepadEnabled then
		if self.props.gamepadEnabled then
			self:setUpGamepad()
		else
			self:unbindActions()
		end
	end
end

function extended:setRotation()
	local model = self.model

	if model then
		local humanoidRootPart = model.HumanoidRootPart

		local initialHrpPosition = self.initialHrpPosition or humanoidRootPart.Position
		local v

		if FFlagEnableNewAvatarViewportProps and self.props.offsetOptions then
			v = self.props.offsetOptions.defaultCameraOffset

			if self.model:FindFirstChildOfClass("Tool") then
				v = self.props.offsetOptions.toolOffset
			end
		else
			local view = self.props.view

			local view2 = self.props.views[view]
			v = view2.DefaultCameraOffset

			if self.model:FindFirstChildOfClass("Tool") then
				v = view2.ToolOffset
			end
		end

		local p = (CFrame.new(initialHrpPosition) * CFrame.Angles(0, -self.yRotation, 0) * CFrame.Angles(self.xRotation, 0, 0) * v).p

		self.viewportCamera.CFrame = CFrame.new(p, initialHrpPosition)

		if FFlagEnableNewAvatarViewportProps and self.props.cameraFieldOfView then
			self.viewportCamera.FieldOfView = self.props.cameraFieldOfView
		end
	end
end

function extended:render()
	local size = self.props.size
	local position = self.props.position
	local visible = self.props.visible
	local backgroundTransparency = self.props.backgroundTransparency
	local setScrollingEnabled = self.props.setScrollingEnabled

	return Roact.createElement("ViewportFrame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position,
		Size = size,
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = Colors.Graphite,
		BorderSizePixel = 0,
		Active = true,
		Visible = visible,
		[Roact.Ref] = self.viewportFrameRef,
		[Roact.Event.InputBegan] = function(_, p)
			if p.UserInputState == Enum.UserInputState.Begin then
				self.mouseOrTouchDown = true
				self.lastPosition = p.Position

				if FFlagEnableNewAvatarViewportProps then
					if setScrollingEnabled then
						setScrollingEnabled(false)
					end
				else
					setScrollingEnabled(false)
				end

				local inputChangedConnection = UserInputService.InputChanged:connect(function(p2, _)
					if
						p2.UserInputType == Enum.UserInputType.MouseMovement and self.mouseOrTouchDown
						or p2.UserInputType == Enum.UserInputType.Touch
					then
						local v = p2.Position - self.lastPosition
						self.lastPosition = p2.Position
						self.yRotation += v.x * 0.0065
						self.xRotation += v.y * 0.0065
						self.lastInputTime = tick()
					end
				end)

				local inputEndedConnection = UserInputService.InputEnded:connect(function(p2, _)
					if
						p2.UserInputType == Enum.UserInputType.MouseButton1
						or p2.UserInputType == Enum.UserInputType.Touch
					then
						if self.mouseOrTouchDown then
							self.mouseOrTouchDown = false
							self.lastInputTime = tick()
							self:removeConnections()
						end

						if FFlagEnableNewAvatarViewportProps then
							if setScrollingEnabled then
								setScrollingEnabled(true)
							end
						else
							setScrollingEnabled(true)
						end
					end
				end)
				table.insert(self.connections, inputChangedConnection)
				table.insert(self.connections, inputEndedConnection)
			end
		end
	}, {
		WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = self.worldModelRef })
	})
end

function extended:handleSpin()
	local flag = false
	spawn(function()
		while self.isMounted do
			if tick() - self.lastInputTime > 2 and not (self.mouseOrTouchDown or self.gamepadRotating) then
				if not (FFlagEnableNewAvatarViewportProps and self.props.disableAutoRotation) then
					flag = true
				end
			else
				flag = false
			end

			local function returnToDefaultPosition(p, p2)
				local v = p % 6.283185307179586
				local v2

				if v > 3.141592653589793 then
					v2 = v + p2

					if v2 > 6.283185307179586 then
						return 0
					end
				else
					v2 = v - p2

					if v2 < 0 then
						return 0
					end
				end

				return v2
			end

			if flag then
				local v = self.xRotation % 6.283185307179586
				local xRotation

				if v > 3.141592653589793 then
					xRotation = v + 0.03490658503988659

					if xRotation > 6.283185307179586 then
						xRotation = 0
					end
				else
					xRotation = v - 0.03490658503988659

					if xRotation < 0 then
						xRotation = 0
					end
				end

				self.xRotation = xRotation
				self.yRotation += 0.012217304763960306
			elseif self.gamepadRotating then
				self.yRotation += self.delta * self.rotationDeltaY
				self.xRotation += self.delta * self.rotationDeltaX
			end

			self:setRotation()
			self.delta = RunService.RenderStepped:wait()
		end
	end)
end

function extended:setUpGamepad()
	if
		isInExperienceUIVREnabled
		and FFlagEnableInExperienceUIPCVRFix
		and isSpatial()
		and FFlagEnableInspectAndBuyV2RootFlag
	then
		return
	end

	if UserInputService.GamepadEnabled then
		local v = Vector2.new(0, 0)

		ContextActionService:UnbindCoreAction("RotateModel")
		ContextActionService:BindCoreAction("RotateModel", function(_, p, p2)
			if p ~= Enum.UserInputState.Change then
				return Enum.ContextActionResult.Sink
			end

			v = p2.Position or v
			v = Vector2.new(v.X, v.Y)

			if math.abs(v.X) > 0.2 or math.abs(v.Y) > 0.2 then
				self.lastInputTime = tick()
				self.gamepadRotating = true
				self.rotationDeltaY = 3 * v.X
				self.rotationDeltaX = 3 * v.Y
			else
				self.gamepadRotating = false
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Thumbstick2, Enum.KeyCode.ButtonA)
	end
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("RotateModel")
end

function extended:removeConnections()
	for _, connection in pairs(self.connections) do
		connection:disconnect()
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.characterModelPool then
		self.characterModelPool:onDestroy()
	end

	self:unbindActions()
	self:removeConnections()
end

local function AvatarViewportWrapper(p)
	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(views)
			local joined = Cryo.Dictionary.join(p, { views = views })
			return Roact.createElement(extended, joined)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		view = data.view,
		tryingOnInfo = data.tryingOnInfo,
		gamepadEnabled = data.gamepadEnabled
	}
end)(AvatarViewportWrapper)
