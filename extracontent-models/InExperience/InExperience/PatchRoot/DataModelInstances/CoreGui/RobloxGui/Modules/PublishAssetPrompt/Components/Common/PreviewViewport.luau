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
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local EmptyState = UIBlox.App.Indicator.EmptyState
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ShortcutBar = UIBlox.App.Navigation.ShortcutBar
local InputType = UIBlox.Core.Enums.InputType
local getInputGroup = require(CorePackages.Workspace.Packages.InputType).getInputGroup
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local InputTypeConstants = require(CorePackages.Workspace.Packages.InputType).InputTypeConstants
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local InteractionFrame = require(script.Parent.InteractionFrame)
local Constants = require(script.Parent.Parent.Parent.Constants)
local Images = UIBlox.App.ImageSet.Images
local v25 = Images["icons/actions/previewShrink"]
local v26 = Images["icons/actions/reset"]
local _ = {
	LOADING = "loading",
	SUCCESSFULLY_LOADED = "successfullyLoaded",
	FAILED_TO_LOAD = "failedToLoad"
}
local v28 = Roact.PureComponent:extend("PreviewViewport")

v28.validateProps = t.strictInterface({
	asset = t.union(t.instanceOf("Model"), t.instanceIsA("AnimationClip")),
	closePreviewView = t.callback
})

local function isGamepadInput(p1) -- line: 70
	-- upvalues: getInputGroup (copy), InputTypeConstants (copy)
	return getInputGroup(p1) == InputTypeConstants.Gamepad
end

function v28.init(p2) -- line: 75
	-- upvalues: UserInputService (copy), getInputGroup (copy), InputTypeConstants (copy), Roact (copy)
	local t1 = {
		loadingState = "loading",
		cameraMoved = false
	}
	local LastInputType = UserInputService:GetLastInputType()

	t1.isGamepad = getInputGroup(LastInputType) == InputTypeConstants.Gamepad
	p2:setState(t1)
	p2.ref = Roact.createRef()
	p2.zoomFactor = 0.8
	p2.cameraDegreesAngle = Vector2.new(0, 0)
	p2.cameraPanInPixels = Vector2.new(0, 0)
	p2.cameraRef = Roact.createRef()
	p2.worldModelRef = Roact.createRef()

	local v37, v38 = Roact.createBinding(CFrame.new())

	p2.cameraCFrameBinding = v37
	p2.updateCameraCFrameBinding = v38

	local v39, v40 = Roact.createBinding(CFrame.new())

	p2.cameraFocusBinding = v39
	p2.updateCameraFocusBinding = v40

	function p2.panByPixels(p3) -- line: 93
		-- upvalues: p2 (copy)
		p2.cameraPanInPixels = p2.cameraPanInPixels + p3
		p2:clampOffsets()
		p2:updateCameraPosition()

		if not p2.state.cameraMoved then
			p2:setState({
				cameraMoved = true
			})
		end
	end
	function p2.rotateByPixels(p4) -- line: 102
		-- upvalues: p2 (copy)
		p2.cameraDegreesAngle = Vector2.new(p2.cameraDegreesAngle.X - p4.Y, p2.cameraDegreesAngle.Y - p4.X)
		p2:clampOffsets()
		p2:updateCameraPosition()

		if not p2.state.cameraMoved then
			p2:setState({
				cameraMoved = true
			})
		end
	end
	function p2.storeInput(_, p6, p7) -- line: 115
		-- upvalues: p2 (copy)
		p2.inputState = p6
		p2.inputObject = p7

		return Enum.ContextActionResult.Sink
	end
	function p2.rotateByRadians(p8) -- line: 123
		-- upvalues: p2 (copy)
		if not p2.model:FindFirstChild("HumanoidRootPart") then
			return
		end

		local v99 = -p8 * 180 / 3.141592653589793

		p2.cameraDegreesAngle = Vector2.new(p2.cameraDegreesAngle.X % 360, (p2.cameraDegreesAngle.Y + v99) % 360)
		p2:updateCameraPosition()

		if not p2.state.cameraMoved then
			p2:setState({
				cameraMoved = true
			})
		end
	end
	function p2.setAngularVelocityByPixels(_) -- line: 142
	end
	function p2.zoomToPoint(n1: number, vector2: Vector2?) -- line: 145
		-- upvalues: p2 (copy)
		local v103 = 0.9 ^ n1
		local v104 = p2.zoomFactor * v103

		if v104 ~= math.clamp(v104, 0.3, 10) then
			return
		end

		p2.zoomFactor = v104

		if vector2 then
			local v105 = (vector2 - (p2.absolutePosition + p2.absoluteSize / 2)) * Vector2.new(1, -1) * -1

			p2.cameraPanInPixels = v105 - (v105 - p2.cameraPanInPixels) * v103
		end

		p2:clampOffsets()
		p2:updateCameraPosition()

		if not p2.state.cameraMoved then
			p2:setState({
				cameraMoved = true
			})
		end
	end
	function p2.onRetryLoading() -- line: 170
		-- upvalues: p2 (copy)
		p2:processAsset()
	end
	function p2.onResetButtonPressed() -- line: 174
		-- upvalues: p2 (copy)
		p2:resetCameraPosition()
	end
end
function v28.setLoadingState(p10, p11) -- line: 179
	p10:setState({
		loadingState = p11
	})
end
function v28.clampOffsets(p12) -- line: 185
	p12.zoomFactor = math.clamp(p12.zoomFactor, 0.3, 10)

	local n2 = -80

	if p12.props.asset and p12.props.asset:IsA("AnimationClip") then
		n2 = p12:angleToMakeBasePlateParallel()
	end

	p12.cameraDegreesAngle = Vector2.new(math.clamp(p12.cameraDegreesAngle.X, n2, 80), p12.cameraDegreesAngle.Y)

	local v45 = math.max(p12.zoomFactor * p12.modelExtentsSize.X / 2 / p12:pointsToPixelsFactor(), p12.absoluteSize.X / 2)
	local v46 = math.max(p12.zoomFactor * p12.modelExtentsSize.Y / 2 / p12:pointsToPixelsFactor(), p12.absoluteSize.Y / 2)

	p12.cameraPanInPixels = Vector2.new(math.clamp(p12.cameraPanInPixels.X, -v45, v45), (math.clamp(p12.cameraPanInPixels.Y, -v46, v46)))
end
function v28.angleToMakeBasePlateParallel(p13) -- line: 211
	local v48 = p13.cameraDistance / p13.zoomFactor
	local v49 = p13:pointsToPixelsFactor() / p13.zoomFactor * p13.cameraPanInPixels.Y

	return -math.deg((math.asin((math.clamp((p13.modelExtentsSize.Y / 2 + v49) / v48, -0.99, 0.99)))))
end
function v28.processAsset(p14) -- line: 230
	-- upvalues: Players (copy), AnimationClipProvider (copy)
	local asset = p14.props.asset

	if not asset then
		return
	end

	if asset:IsA("AnimationClip") then
		p14:setLoadingState("loading")
		task.spawn(function() -- line: 239
			-- upvalues: Players (copy), p14 (copy), asset (copy), AnimationClipProvider (copy)
			local ok, result = pcall(function() -- line: 240
				-- upvalues: Players (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return (Players:GetHumanoidDescriptionFromOutfitIdAsync(1342485078))
				end

				return (Players:GetHumanoidDescriptionFromOutfitId(1342485078))
			end)
			local v108 = nil

			if ok then
				v108 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:CreateHumanoidModelFromDescription(result, Enum.HumanoidRigType.R15) else Players:CreateHumanoidModelFromDescriptionAsync(result, Enum.HumanoidRigType.R15)
			end

			if not p14.isMounted or asset ~= p14.props.asset then
				return
			end

			if not v108 then
				p14:setLoadingState("failedToLoad")

				return
			end

			p14.model = v108
			p14:addModelToViewportIfNeeded()

			local v109 = AnimationClipProvider:RegisterActiveAnimationClip(asset)

			p14.animation = Instance.new("Animation")
			p14.animation.AnimationId = v109

			local Humanoid = p14.model:FindFirstChildWhichIsA("Humanoid")

			if Humanoid then
				Humanoid:LoadAnimation(p14.animation):Play()
			end

			p14:setLoadingState("successfullyLoaded")
		end)

		return
	end

	if asset:IsA("Model") or asset:IsA("Accessory") then
		if asset:IsA("Accessory") then
			local Model = Instance.new("Model")

			asset:Clone().Parent = Model
			p14.model = Model
		else
			p14.model = asset:Clone()
		end

		p14.model.Parent = nil
		p14:addModelToViewportIfNeeded()
		p14:setLoadingState("successfullyLoaded")
	end
end
function v28.addModelToViewportIfNeeded(p15) -- line: 305
	if p15.model ~= nil and p15.model.Parent ~= nil then
		return
	end

	if p15.worldModelRef:getValue() and p15.model ~= nil then
		p15.model.Parent = p15.worldModelRef:getValue()
		p15:resetCameraPosition()

		if p15.props.asset and p15.props.asset:IsA("AnimationClip") then
			p15.baseplate = Instance.new("Part")
			p15.baseplate.Size = Vector3.new(8, 0.5, 8)
			p15.baseplate.Transparency = 0.6
			p15.baseplate.Parent = p15.worldModelRef:getValue()

			local v54 = p15.modelCFrame.Position + Vector3.new(0, -p15.modelExtentsSize.Y / 2, 0)

			p15.baseplate.Position = v54 + Vector3.new(0, -0.25, 0)
		end
	end
end

local function getCameraDistance(p16, p17) -- line: 327
	local p17X = p17.X
	local p17Y = p17.Y
	local p17Z = p17.Z
	local v60 = math.max(p17X, p17Y)
	local v61 = 1 / math.tan(math.rad(p16) / 2)

	return v60 / 2 * v61 + p17Z / 2
end
local function rotateVectorAround(p18, p19, p20) -- line: 337
	return CFrame.fromAxisAngle(p20, p19):VectorToWorldSpace(p18)
end

function v28.resetCameraPosition(p21) -- line: 341
	if not p21.model then
		return
	end

	p21.modelCFrame = p21.model:GetModelCFrame()
	p21.initialLookVector = p21.modelCFrame.lookVector

	local HumanoidRootPart = p21.model:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		p21.initialLookVector = HumanoidRootPart.CFrame.lookVector
	end

	p21.modelExtentsSize = p21.model:GetExtentsSize()

	local modelExtentsSize = p21.modelExtentsSize
	local modelExtentsSizeX = modelExtentsSize.X
	local modelExtentsSizeY = modelExtentsSize.Y
	local modelExtentsSizeZ = modelExtentsSize.Z

	p21.cameraDistance = math.max(modelExtentsSizeX, modelExtentsSizeY) / 2 * 3.7320508075688776 + modelExtentsSizeZ / 2

	if p21.props.asset and p21.props.asset:IsA("AnimationClip") then
		p21.cameraDegreesAngle = Vector2.new(0, 0)
		p21.zoomFactor = 0.75
	else
		p21.cameraDegreesAngle = Vector2.new(5, 20)
		p21.zoomFactor = 0.8
	end

	p21.cameraPanInPixels = Vector2.new(0, 0)
	p21:updateCameraPosition()

	if p21.state.cameraMoved then
		p21:setState({
			cameraMoved = false
		})
	end
end
function v28.pointsToPixelsFactor(p22) -- line: 375
	if p22.absoluteSize == nil or (p22.modelExtentsSize == nil or p22.absoluteSize.Y == 0 or p22.modelExtentsSize.Y == 0 or p22.modelExtentsSize.X == 0) then
		return 1
	end

	return math.max(p22.modelExtentsSize.X, p22.modelExtentsSize.Y) / p22.absoluteSize.Y
end
function v28.updateCameraPosition(p23) -- line: 390
	if p23.absoluteSize == nil or p23.cameraDistance == nil then
		return
	end

	local v73 = p23.cameraDistance / p23.zoomFactor
	local initialLookVector = p23.initialLookVector
	local v75 = math.rad(p23.cameraDegreesAngle.X)
	local v76 = math.rad(p23.cameraDegreesAngle.Y)
	local v77 = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), v75):VectorToWorldSpace(initialLookVector)
	local v78 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v76):VectorToWorldSpace(v77)
	local cFrame = CFrame.new(p23.modelCFrame.p + v78 * v73, p23.modelCFrame.p)
	local v80 = p23:pointsToPixelsFactor() / p23.zoomFactor
	local v81 = cFrame + cFrame.UpVector * v80 * p23.cameraPanInPixels.Y + cFrame.RightVector * v80 * p23.cameraPanInPixels.X

	p23.updateCameraCFrameBinding(v81)
	p23.updateCameraFocusBinding(p23.modelCFrame)
end

local t2 = {
	resetViewButtonText = RobloxTranslator:FormatByKey("CoreScripts.AssetPreviewView.Action.ResetView"),
	loadingFailedText = RobloxTranslator:FormatByKey("CoreScripts.AssetPreviewView.Label.LoadingFailed")
}

function v28.render(p24) -- line: 424
	-- upvalues: InputType (copy), Images (copy), RobloxTranslator (copy), Roact (copy), GuiService (copy), ExternalEventConnection (copy), UserInputService (copy), getInputGroup (copy), InputTypeConstants (copy), Button (copy), ButtonType (copy), v26 (copy), v25 (copy), ShortcutBar (copy), Skeleton (copy), EmptyState (copy), t2 (copy), InteractionFrame (copy), Constants (copy)
	local loadingState = p24.state.loadingState
	local t3 = {
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
			icon = {
				[InputType.MouseAndKeyboard] = Images["icons/controls/mouse/clickRight"]
			},
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Pan")
		},
		{
			icon = {
				[InputType.Gamepad] = Images["icons/controls/keys/xboxY"]
			},
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.ResetView")
		},
		{
			icon = {
				[InputType.Gamepad] = Images["icons/controls/keys/xboxB"]
			},
			text = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.Close")
		}
	}
	local v85 = p24.state.cameraMoved and not p24.state.isGamepad

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Roact.Ref] = p24.ref,
		[Roact.Change.AbsoluteSize] = function(p25) -- line: 469
			-- upvalues: p24 (copy)
			p24.absoluteSize = p25.AbsoluteSize
			p24:updateCameraPosition()
		end,
		[Roact.Change.AbsolutePosition] = function(p26) -- line: 473
			-- upvalues: GuiService (copy), p24 (copy)
			local GuiInset = GuiService:GetGuiInset()

			p24.absolutePosition = p26.absolutePosition + GuiInset
		end
	}, {
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p27) -- line: 480
				-- upvalues: p24 (copy), getInputGroup (copy), InputTypeConstants (copy)
				p24:setState({
					isGamepad = getInputGroup(p27) == InputTypeConstants.Gamepad
				})
			end
		}) or nil,
		ButtonFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0)
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 24),
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			ResetViewButton = if not v85 then nil else Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.fromOffset(36, 36),
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1),
				icon = v26,
				onActivated = p24.onResetButtonPressed
			}),
			ShrinkPreviewButton = Roact.createElement(Button, {
				buttonType = ButtonType.PrimarySystem,
				size = UDim2.fromOffset(36, 36),
				icon = v25,
				position = UDim2.fromScale(1, 1),
				anchorPoint = Vector2.new(1, 1),
				onActivated = p24.props.closePreviewView
			})
		}),
		TooltipHint = if not p24.props.asset:IsA("Model") then nil else Roact.createElement(ShortcutBar, {
			transitionDelaySeconds = 2,
			position = UDim2.fromScale(0.5, 0.9),
			anchorPoint = Vector2.new(0.5, 1),
			items = t3
		}),
		ShimmerFrame = loadingState == "loading" and Roact.createElement(Skeleton, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		LoadingFailed = loadingState == "failedToLoad" and Roact.createElement(EmptyState, {
			text = t2.loadingFailedText,
			size = UDim2.fromScale(1, 1),
			onActivated = p24.onRetryLoading
		}),
		InteractionFrame = Roact.createElement(InteractionFrame, {
			ZIndex = -1,
			Size = UDim2.fromScale(1, 1),
			Visible = loadingState == "successfullyLoaded",
			panByPixels = p24.panByPixels,
			rotateByPixels = p24.rotateByPixels,
			setAngularVelocityByPixels = p24.setAngularVelocityByPixels,
			zoomToPoint = p24.zoomToPoint
		}, {
			ViewportFrame = Roact.createElement("ViewportFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Constants.ViewportLightColor,
				Ambient = Constants.ViewportLightAmbient,
				LightDirection = Constants.ViewportLightDirection,
				CurrentCamera = p24.cameraRef
			}, {
				Camera = Roact.createElement("Camera", {
					CameraType = Enum.CameraType.Scriptable,
					FieldOfView = 30,
					HeadLocked = true,
					VRTiltAndRollEnabled = true,
					CFrame = p24.cameraCFrameBinding,
					Focus = p24.cameraFocusBinding,
					[Roact.Ref] = p24.cameraRef
				}),
				WorldModel = Roact.createElement("WorldModel", {
					[Roact.Ref] = p24.worldModelRef
				})
			})
		})
	})
end
function v28.setUpGamepad(p28) -- line: 580
	-- upvalues: ContextActionService (copy), RunService (copy), GamepadUtils (copy)
	ContextActionService:UnbindCoreAction("PreviewViewportClose")
	ContextActionService:UnbindCoreAction("PreviewViewportReset")
	ContextActionService:UnbindCoreAction("PreviewViewportRotateAndZoom")
	ContextActionService:BindCoreAction("PreviewViewportClose", p28.props.closePreviewView, false, Enum.KeyCode.ButtonB)
	ContextActionService:BindCoreAction("PreviewViewportReset", function() -- line: 591
		-- upvalues: p28 (copy)
		p28:resetCameraPosition()
	end, false, Enum.KeyCode.ButtonY)
	ContextActionService:BindCoreAction("PreviewViewportRotateAndZoom", p28.storeInput, false, Enum.KeyCode.Thumbstick2)
	p28.gamePadConnection = RunService.RenderStepped:Connect(function(dt) -- line: 601
		-- upvalues: p28 (copy), GamepadUtils (copy)
		if p28.inputState == Enum.UserInputState.Change and p28.inputObject then
			GamepadUtils.rotateAndZoom(p28.inputObject, dt, p28.setAngularVelocityByPixels, p28.rotateByRadians, p28.zoomToPoint)
		end
	end)
end
function v28.didMount(p29) -- line: 614
	-- upvalues: GuiService (copy)
	local GuiInset = GuiService:GetGuiInset()

	p29.isMounted = true
	p29.absolutePosition = p29.ref.current.AbsolutePosition + GuiInset
	p29:processAsset()
	p29:setUpGamepad()
end
function v28.cleanupGamepad(p30) -- line: 622
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("PreviewViewportClose")
	ContextActionService:UnbindCoreAction("PreviewViewportReset")
	ContextActionService:UnbindCoreAction("PreviewViewportRotateAndZoom")

	if p30.gamePadConnection then
		p30.gamePadConnection:Disconnect()
	end
end
function v28.willUnmount(p31) -- line: 631
	p31.isMounted = false
	p31:cleanupGamepad()
end
function v28.didUpdate(p32, p33) -- line: 636
	if p32.props.asset ~= p33.asset then
		if p32.model ~= nil then
			p32.model.Parent = nil
			p32.model = nil
		end

		if p32.baseplate ~= nil then
			p32.baseplate.Parent = nil
			p32.baseplate:Destroy()
		end

		p32:processAsset()
	end
end

return v28
