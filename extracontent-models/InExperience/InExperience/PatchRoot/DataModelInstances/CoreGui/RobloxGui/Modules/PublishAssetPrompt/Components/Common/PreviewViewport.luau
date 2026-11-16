local AnimationClipProvider = game:GetService("AnimationClipProvider")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton

local EmptyState = UIBlox.App.Indicator.EmptyState
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ShortcutBar = UIBlox.App.Navigation.ShortcutBar
local InputType = UIBlox.Core.Enums.InputType
local InputType2 = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType2.getInputGroup
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local InputType3 = require(CorePackages.Workspace.Packages.InputType)
local InputTypeConstants = InputType3.InputTypeConstants
local InputUi = require(CorePackages.Workspace.Packages.InputUi)
local GamepadUtils = InputUi.Gamepad.GamepadUtils

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local InteractionFrame = require(script.Parent.InteractionFrame)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.MakeupPreviewUtils)

local Images = UIBlox.App.ImageSet.Images
local iconsactionspreviewShrink = Images["icons/actions/previewShrink"]
local iconsactionsreset = Images["icons/actions/reset"]

local _ = {
	LOADING = "loading",
	SUCCESSFULLY_LOADED = "successfullyLoaded",
	FAILED_TO_LOAD = "failedToLoad"
}

local extended = Roact.PureComponent:extend("PreviewViewport")

extended.validateProps = t.strictInterface({
	asset = t.union(t.instanceOf("Model"), t.instanceIsA("AnimationClip")),
	closePreviewView = t.callback,
	isMakeupPreview = t.optional(t.boolean)
})

local function isGamepadInput(p): boolean -- 2 equivalent calls inferred from this helper
	return getInputGroup(p) == InputTypeConstants.Gamepad
end

function extended:init()
	self:setState({
		loadingState = "loading",
		isGamepad = isGamepadInput(UserInputService:GetLastInputType()), -- inferred equivalent call
		cameraMoved = false
	})

	self.ref = Roact.createRef()
	self.zoomFactor = 0.8
	self.cameraDegreesAngle = Vector2.new(0, 0)
	self.cameraPanInPixels = Vector2.new(0, 0)

	self.cameraRef = Roact.createRef()
	self.worldModelRef = Roact.createRef()

	local binding, updateCameraCFrameBinding = Roact.createBinding(CFrame.new())
	self.cameraCFrameBinding = binding
	self.updateCameraCFrameBinding = updateCameraCFrameBinding
	local binding2, updateCameraFocusBinding = Roact.createBinding(CFrame.new())
	self.cameraFocusBinding = binding2
	self.updateCameraFocusBinding = updateCameraFocusBinding

	function self.panByPixels(p)
		self.cameraPanInPixels += p
		self:clampOffsets()
		self:updateCameraPosition()

		if not self.state.cameraMoved then
			self:setState({ cameraMoved = true })
		end
	end

	function self.rotateByPixels(p)
		self.cameraDegreesAngle = Vector2.new(self.cameraDegreesAngle.X - p.Y, self.cameraDegreesAngle.Y - p.X)

		self:clampOffsets()
		self:updateCameraPosition()

		if not self.state.cameraMoved then
			self:setState({ cameraMoved = true })
		end
	end

	function self.storeInput(_, inputState, inputObject)
		self.inputState = inputState
		self.inputObject = inputObject

		return Enum.ContextActionResult.Sink
	end

	function self.rotateByRadians(p)
		if not self.model:FindFirstChild("HumanoidRootPart") then
			return
		end

		local v = -p * 180 / 3.141592653589793
		self.cameraDegreesAngle = Vector2.new(self.cameraDegreesAngle.X % 360, (self.cameraDegreesAngle.Y + v) % 360)

		self:updateCameraPosition()

		if not self.state.cameraMoved then
			self:setState({ cameraMoved = true })
		end
	end

	function self.setAngularVelocityByPixels(_) end

	function self.zoomToPoint(p: number, vector2: Vector2?)
		local v = 0.9 ^ p
		local zoomFactor = self.zoomFactor * v

		if zoomFactor ~= math.clamp(zoomFactor, 0.3, 10) then
			return
		end

		self.zoomFactor = zoomFactor

		if vector2 then
			local v2 = (vector2 - (self.absolutePosition + self.absoluteSize / 2)) * Vector2.new(1, -1) * -1

			self.cameraPanInPixels = v2 - (v2 - self.cameraPanInPixels) * v
		end

		self:clampOffsets()
		self:updateCameraPosition()

		if not self.state.cameraMoved then
			self:setState({ cameraMoved = true })
		end
	end

	function self.onRetryLoading()
		self:processAsset()
	end

	function self.onResetButtonPressed()
		self:resetCameraPosition()
	end
end

function extended:setLoadingState(loadingState)
	self:setState({ loadingState = loadingState })
end

function extended:clampOffsets()
	self.zoomFactor = math.clamp(self.zoomFactor, 0.3, 10)

	local v = not (self.props.asset and self.props.asset:IsA("AnimationClip")) and -80
		or self:angleToMakeBasePlateParallel()

	self.cameraDegreesAngle = Vector2.new(math.clamp(self.cameraDegreesAngle.X, v, 80), self.cameraDegreesAngle.Y)

	local v2 = math.max(
		self.zoomFactor * self.modelExtentsSize.X / 2 / self:pointsToPixelsFactor(),
		self.absoluteSize.X / 2
	)

	local v3 = math.max(
		self.zoomFactor * self.modelExtentsSize.Y / 2 / self:pointsToPixelsFactor(),
		self.absoluteSize.Y / 2
	)
	self.cameraPanInPixels = Vector2.new(
		math.clamp(self.cameraPanInPixels.X, -v2, v2),
		(math.clamp(self.cameraPanInPixels.Y, -v3, v3))
	)
end

function extended:angleToMakeBasePlateParallel()
	local v = self.cameraDistance / self.zoomFactor

	local v2 = self:pointsToPixelsFactor() / self.zoomFactor * self.cameraPanInPixels.Y

	return -math.deg((math.asin((math.clamp((self.modelExtentsSize.Y / 2 + v2) / v, -0.99, 0.99)))))
end

function extended:processAsset()
	local asset = self.props.asset

	if not asset then
		return
	end

	if asset:IsA("AnimationClip") then
		self:setLoadingState("loading")
		task.spawn(function()
			local success, result = pcall(function()
				return (Players:GetHumanoidDescriptionFromOutfitIdAsync(1342485078))
			end)
			local model

			if success then
				model = Players:CreateHumanoidModelFromDescriptionAsync(result, Enum.HumanoidRigType.R15)
			end

			if not self.isMounted or asset ~= self.props.asset then
				return
			end

			if not model then
				self:setLoadingState("failedToLoad")
				return
			end

			self.model = model
			self:addModelToViewportIfNeeded()

			local activeAnimationClip = AnimationClipProvider:RegisterActiveAnimationClip(asset)
			self.animation = Instance.new("Animation")
			self.animation.AnimationId = activeAnimationClip

			local humanoid = self.model:FindFirstChildWhichIsA("Humanoid")

			if humanoid then
				humanoid:LoadAnimation(self.animation):Play()
			end

			self:setLoadingState("successfullyLoaded")
		end)
	elseif asset:IsA("Model") or asset:IsA("Accessory") then
		if asset:IsA("Accessory") then
			local model = Instance.new("Model")
			local clone = asset:Clone()
			clone.Parent = model
			self.model = model
		else
			self.model = asset:Clone()
		end

		self.model.Parent = nil
		self:addModelToViewportIfNeeded()

		self:setLoadingState("successfullyLoaded")
	end
end

function extended:addModelToViewportIfNeeded()
	if self.model ~= nil and self.model.Parent ~= nil then
		return
	end

	if self.worldModelRef:getValue() and self.model ~= nil then
		self.model.Parent = self.worldModelRef:getValue()
		self:resetCameraPosition()

		if self.props.asset and self.props.asset:IsA("AnimationClip") then
			self.baseplate = Instance.new("Part")
			self.baseplate.Size = Vector3.new(8, 0.5, 8)
			self.baseplate.Transparency = 0.6
			self.baseplate.Parent = self.worldModelRef:getValue()
			local v = self.modelCFrame.Position + Vector3.new(0, -self.modelExtentsSize.Y / 2, 0)
			self.baseplate.Position = v + Vector3.new(0, -0.25, 0)
		end
	end
end

local function getCameraDistance(p, data)
	local x = data.X
	local y = data.Y
	local z = data.Z

	local v = math.max(x, y)

	local v2 = 1 / math.tan(math.rad(p) / 2)
	return v / 2 * v2 + z / 2
end

local function rotateVectorAround(p, p2, p3) -- 2 equivalent calls inferred from this helper
	return CFrame.fromAxisAngle(p3, p2):VectorToWorldSpace(p)
end

function extended:resetCameraPosition()
	if not self.model then
		return
	end

	local v, v2

	if self.props.isMakeupPreview then
		v, v2 = MakeupPreviewUtils.getHeadPreviewCameraData(self.model)
	end

	self.modelCFrame = v or self.model:GetModelCFrame()
	self.initialLookVector = self.modelCFrame.lookVector

	local humanoidRootPart = self.model:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		self.initialLookVector = humanoidRootPart.CFrame.lookVector
	end

	self.modelExtentsSize = v2 or self.model:GetExtentsSize()
	local modelExtentsSize = self.modelExtentsSize
	local x = modelExtentsSize.X
	local y = modelExtentsSize.Y
	local z = modelExtentsSize.Z

	self.cameraDistance = math.max(x, y) / 2 * 3.7320508075688776 + z / 2

	if self.props.asset and self.props.asset:IsA("AnimationClip") then
		self.cameraDegreesAngle = Vector2.new(0, 0)
		self.zoomFactor = 0.75
	else
		self.cameraDegreesAngle = Vector2.new(5, 20)
		self.zoomFactor = 0.8
	end

	self.cameraPanInPixels = Vector2.new(0, 0)

	self:updateCameraPosition()

	if self.state.cameraMoved then
		self:setState({ cameraMoved = false })
	end
end

function extended:pointsToPixelsFactor()
	if
		self.absoluteSize == nil
		or self.modelExtentsSize == nil
		or self.absoluteSize.Y == 0
		or self.modelExtentsSize.Y == 0
		or self.modelExtentsSize.X == 0
	then
		return 1
	end

	return math.max(self.modelExtentsSize.X, self.modelExtentsSize.Y) / self.absoluteSize.Y
end

function extended:updateCameraPosition()
	if self.absoluteSize == nil or self.cameraDistance == nil then
		return
	end

	local v = self.cameraDistance / self.zoomFactor

	local initialLookVector = self.initialLookVector
	local x = math.rad(self.cameraDegreesAngle.X)
	local y = math.rad(self.cameraDegreesAngle.Y)
	local v2 = rotateVectorAround( -- inferred equivalent call
		rotateVectorAround(initialLookVector, x, Vector3.new(1, 0, 0)), -- inferred equivalent call
		y,
		Vector3.new(0, 1, 0)
	)
	local cframe = CFrame.new(self.modelCFrame.p + v2 * v, self.modelCFrame.p)

	local v3 = self:pointsToPixelsFactor() / self.zoomFactor

	local v4 = cframe + cframe.UpVector * v3 * self.cameraPanInPixels.Y + cframe.RightVector * v3 * self.cameraPanInPixels.X

	self.updateCameraCFrameBinding(v4)
	self.updateCameraFocusBinding(self.modelCFrame)
end

local v = {
	resetViewButtonText = RobloxTranslator:FormatByKey("CoreScripts.AssetPreviewView.Action.ResetView"),
	loadingFailedText = RobloxTranslator:FormatByKey("CoreScripts.AssetPreviewView.Label.LoadingFailed")
}

function extended:render()
	local loadingState = self.state.loadingState
	local items = {
		{
			icon = {
				[InputType.MouseAndKeyboard] = Images["icons/controls/mouse/scroll"],
				[InputType.Gamepad] = Images["icons/controls/keys/xboxRSVertical"]
			},
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Zoom")
		},
		{
			icon = {
				[InputType.MouseAndKeyboard] = Images["icons/controls/mouse/clickLeft"],
				[InputType.Gamepad] = Images["icons/controls/keys/xboxRSHorizontal"]
			},
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Rotate")
		},
		{
			icon = { [InputType.MouseAndKeyboard] = Images["icons/controls/mouse/clickRight"] },
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Pan")
		},
		{
			icon = { [InputType.Gamepad] = Images["icons/controls/keys/xboxY"] },
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.ResetView")
		},
		{
			icon = { [InputType.Gamepad] = Images["icons/controls/keys/xboxB"] },
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Close")
		}
	}

	local v2 = self.state.cameraMoved and not self.state.isGamepad

	local createElement = Roact.createElement
	local v3 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Roact.Ref] = self.ref,
		[Roact.Change.AbsoluteSize] = function(p)
			self.absoluteSize = p.AbsoluteSize
			self:updateCameraPosition()
		end,
		[Roact.Change.AbsolutePosition] = function(p)
			local guiInset = GuiService:GetGuiInset()
			self.absolutePosition = p.absolutePosition + guiInset
		end
	}
	local children = {
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p)
				self:setState({ isGamepad = isGamepadInput(p) }) -- inferred equivalent call
			end
		}) or nil,
		ButtonFrame = 0,
		TooltipHint = 0,
		ShimmerFrame = 0,
		LoadingFailed = 0,
		InteractionFrame = 0
	}

	local createElement2 = Roact.createElement
	local v4 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1
	}

	local v5 = {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		ResetViewButton = 0,
		ShrinkPreviewButton = 0
	}
	local resetViewButton

	if v2 then
		resetViewButton = Roact.createElement(Button, {
			buttonType = ButtonType.Secondary,
			size = UDim2.fromOffset(36, 36),
			position = UDim2.fromScale(0, 1),
			anchorPoint = Vector2.new(0, 1),
			icon = iconsactionsreset,
			onActivated = self.onResetButtonPressed
		})
	end

	v5.ResetViewButton = resetViewButton

	v5.ShrinkPreviewButton = Roact.createElement(Button, {
		buttonType = ButtonType.PrimarySystem,
		size = UDim2.fromOffset(36, 36),
		icon = iconsactionspreviewShrink,
		position = UDim2.fromScale(1, 1),
		anchorPoint = Vector2.new(1, 1),
		onActivated = self.props.closePreviewView
	})
	children.ButtonFrame = createElement2("Frame", v4, v5)
	local tooltipHint

	if self.props.asset:IsA("Model") then
		tooltipHint = Roact.createElement(ShortcutBar, {
			position = UDim2.fromScale(0.5, 0.9),
			anchorPoint = Vector2.new(0.5, 1),
			transitionDelaySeconds = 2,
			items = items
		})
	end

	children.TooltipHint = tooltipHint

	children.ShimmerFrame = loadingState == "loading"
		and Roact.createElement(Skeleton, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})

	children.LoadingFailed = loadingState == "failedToLoad"
		and Roact.createElement(EmptyState, {
			text = v.loadingFailedText,
			size = UDim2.fromScale(1, 1),
			onActivated = self.onRetryLoading
		})

	children.InteractionFrame = Roact.createElement(InteractionFrame, {
		ZIndex = -1,
		Size = UDim2.fromScale(1, 1),
		Visible = loadingState == "successfullyLoaded",
		panByPixels = self.panByPixels,
		rotateByPixels = self.rotateByPixels,
		setAngularVelocityByPixels = self.setAngularVelocityByPixels,
		zoomToPoint = self.zoomToPoint
	}, {
		ViewportFrame = Roact.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LightColor = Constants.ViewportLightColor,
			Ambient = Constants.ViewportLightAmbient,
			LightDirection = Constants.ViewportLightDirection,
			CurrentCamera = self.cameraRef
		}, {
			Camera = Roact.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = 30,
				HeadLocked = true,
				VRTiltAndRollEnabled = true,
				CFrame = self.cameraCFrameBinding,
				Focus = self.cameraFocusBinding,
				[Roact.Ref] = self.cameraRef
			}),
			WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = self.worldModelRef })
		})
	})
	return createElement("Frame", v3, children)
end

function extended:setUpGamepad()
	ContextActionService:UnbindCoreAction("PreviewViewportClose")
	ContextActionService:UnbindCoreAction("PreviewViewportReset")
	ContextActionService:UnbindCoreAction("PreviewViewportRotateAndZoom")

	ContextActionService:BindCoreAction(
		"PreviewViewportClose",
		self.props.closePreviewView,
		false,
		Enum.KeyCode.ButtonB
	)

	ContextActionService:BindCoreAction("PreviewViewportReset", function()
		self:resetCameraPosition()
	end, false, Enum.KeyCode.ButtonY)
	ContextActionService:BindCoreAction(
		"PreviewViewportRotateAndZoom",
		self.storeInput,
		false,
		Enum.KeyCode.Thumbstick2
	)

	self.gamePadConnection = RunService.RenderStepped:Connect(function(dt)
		if self.inputState == Enum.UserInputState.Change and self.inputObject then
			GamepadUtils.rotateAndZoom(
				self.inputObject,
				dt,
				self.setAngularVelocityByPixels,
				self.rotateByRadians,
				self.zoomToPoint
			)
		end
	end)
end

function extended:didMount()
	local guiInset = GuiService:GetGuiInset()
	self.isMounted = true
	self.absolutePosition = self.ref.current.AbsolutePosition + guiInset
	self:processAsset()
	self:setUpGamepad()
end

function extended:cleanupGamepad()
	ContextActionService:UnbindCoreAction("PreviewViewportClose")
	ContextActionService:UnbindCoreAction("PreviewViewportReset")
	ContextActionService:UnbindCoreAction("PreviewViewportRotateAndZoom")

	if self.gamePadConnection then
		self.gamePadConnection:Disconnect()
	end
end

function extended:willUnmount()
	self.isMounted = false
	self:cleanupGamepad()
end

function extended:didUpdate(p)
	if self.props.asset ~= p.asset then
		if self.model ~= nil then
			self.model.Parent = nil
			self.model = nil
		end

		if self.baseplate ~= nil then
			self.baseplate.Parent = nil
			self.baseplate:Destroy()
		end

		self:processAsset()
	end
end

return extended
