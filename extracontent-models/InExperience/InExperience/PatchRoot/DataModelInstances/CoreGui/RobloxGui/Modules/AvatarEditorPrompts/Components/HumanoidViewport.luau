local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton

local Promise = require(CorePackages.Packages.Promise)
local EmptyState = UIBlox.App.Indicator.EmptyState

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local cframe = CFrame.fromEulerAnglesXYZ(0.3490658503988659, 0.2617993877991494, 0.6981317007977318)

local defineFastInt = game:DefineFastInt("AXClusterCompositionTimeoutMs", 3000)

local extended = Roact.PureComponent:extend("HumanoidViewport")

extended.validateProps = t.strictInterface({
	humanoidDescription = t.optional(t.instanceOf("HumanoidDescription")),
	loadingFailed = t.boolean,
	retryLoadDescription = t.callback,
	rigType = t.optional(t.enum(Enum.HumanoidRigType))
})

function extended:init()
	self:setState({ loading = true, loadingFailed = false })

	self.cameraRef = Roact.createRef()
	self.worldModelRef = Roact.createRef()

	local binding, updateCameraCFrameBinding = Roact.createBinding(CFrame.new())
	self.cameraCFrameBinding = binding
	self.updateCameraCFrameBinding = updateCameraCFrameBinding
	local binding2, updateCameraFocusBinding = Roact.createBinding(CFrame.new())
	self.cameraFocusBinding = binding2
	self.updateCameraFocusBinding = updateCameraFocusBinding

	self.humanoidModel = nil

	self.mounted = false

	function self.onRetryLoading()
		self:setState({ loading = true, loadingFailed = false })

		if self.props.humanoidDescription then
			self:loadHumanoidModel()
		else
			self.props.retryLoadDescription()
		end
	end
end

local function rotateLookVector(lookVector) -- 1 equivalent call inferred from this helper
	local v = math.abs(lookVector.Y) > 0.95 and Vector3.new(0, 0, -1) or Vector3.new(lookVector.X, 0, lookVector.Z).unit

	return (CFrame.new(Vector3.new(0, 0, 0), v) * cframe).lookVector
end

local function getCameraOffset(p, data)
	local x = data.X
	local y = data.Y
	local z = data.Z

	local v = math.max(x, y)

	local v2 = 1 / math.tan(math.rad(p) / 2)
	return v / 2 * v2 + z / 2
end

local function zoomExtents(humanoidModel, p, cframe2) -- 1 equivalent call inferred from this helper
	local p2 = humanoidModel:GetModelCFrame().p
	local extentsSize = humanoidModel:GetExtentsSize()
	local x = extentsSize.X
	local y = extentsSize.Y
	local z = extentsSize.Z

	local v = (math.max(x, y) / 2 * 1.4281480067421146 + z / 2) * 1
	return cframe2 - cframe2.p + p2 + p * v
end

function extended:positionCamera()
	local humanoidModel = self.humanoidModel
	local modelCFrame = humanoidModel:GetModelCFrame()
	local lookVector = modelCFrame.lookVector
	local humanoidRootPart = humanoidModel:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		lookVector = humanoidRootPart.CFrame.lookVector
	end

	local lookVector2 = rotateLookVector(lookVector) -- inferred equivalent call
	local v = zoomExtents(humanoidModel, lookVector2, CFrame.new(modelCFrame.p + lookVector2 * 5, modelCFrame.p)) -- inferred equivalent call

	self.updateCameraCFrameBinding(v)
	self.updateCameraFocusBinding(modelCFrame)
end

function extended:loadIdleAnimation(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if humanoid.HumanoidDescription.IdleAnimation == 0 then
		return
	end

	local animate = instance:FindFirstChild("Animate")

	if not animate then
		return
	end

	local idle = animate:FindFirstChild("idle")

	if not idle then
		return
	end

	local animation = idle:FindFirstChildOfClass("Animation")

	if not animation then
		return
	end

	local track = humanoid:LoadAnimation(animation)
	track.Looped = true
	track:Play()
end

function extended:loadHumanoidModel()
	local humanoidDescription = self.props.humanoidDescription
	local rigType = self.props.rigType

	coroutine.wrap(function()
		local humanoidModel = nil
		pcall(function()
			humanoidModel = Players:CreateHumanoidModelFromDescriptionAsync(humanoidDescription, rigType)
		end)

		if not (self.mounted and self.props.humanoidDescription == humanoidDescription and self.props.rigType == rigType) then
			return
		end

		if humanoidModel == nil then
			self:setState({ loadingFailed = true })

			return
		end

		self.humanoidModel = humanoidModel

		if self.worldModelRef:getValue() then
			self.humanoidModel.Parent = self.worldModelRef:getValue()
		end

		if #humanoidDescription:GetAccessories(false) > 0 then
			Promise.race({
				Promise.fromEvent(humanoidModel.Humanoid.ClusterCompositionFinished),
				Promise.delay(defineFastInt * 0.001)
			}):await()
		end

		if not self.mounted then
			return
		end

		self:positionCamera()
		self:loadIdleAnimation(humanoidModel)

		self:setState({ loading = false, loadingFailed = false })
	end)()
end

function extended.render(props)
	local loadingFailed = props.props.loadingFailed or props.state.loadingFailed
	local loading = not loadingFailed and props.state.loading
	local visible = not (loadingFailed or props.state.loading)

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		},
		{
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			ShimmerFrame = loading and Roact.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			LoadingFailed = loadingFailed and Roact.createElement(EmptyState, {
				text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.ItemsListLoadingFailed"),
				size = UDim2.fromScale(1, 1),
				onActivated = props.onRetryLoading
			}),
			ViewportFrame = Roact.createElement("ViewportFrame", {
				Visible = visible,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Color3.fromRGB(240, 240, 240),
				Ambient = Color3.fromRGB(240, 240, 240),
				CurrentCamera = props.cameraRef
			}, {
				Camera = Roact.createElement("Camera", {
					CameraType = Enum.CameraType.Scriptable,
					FieldOfView = 70,
					CFrame = props.cameraCFrameBinding,
					Focus = props.cameraFocusBinding,
					[Roact.Ref] = props.cameraRef
				}),
				WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = props.worldModelRef })
			})
		}
	)
end

function extended:didMount()
	self.mounted = true

	if self.props.humanoidDescription then
		self:loadHumanoidModel()
	end
end

function extended:didUpdate(p)
	if self.worldModelRef:getValue() and self.humanoidModel then
		self.humanoidModel.Parent = self.worldModelRef:getValue()
	end

	local v = self.props.humanoidDescription ~= p.humanoidDescription
	local v2 = self.props.rigType ~= p.rigType
	local v3

	if self.props.rigType == nil or self.props.humanoidDescription == nil then
		v3 = false
	else
		v3 = v or v2
	end

	if v3 then
		self:setState({ loading = true })

		if self.props.humanoidDescription ~= nil then
			self:loadHumanoidModel()
		end
	end
end

function extended:willUnmount()
	self.mounted = false
end

return extended
