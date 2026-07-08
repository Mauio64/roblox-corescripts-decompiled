local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local Promise = require(CorePackages.Packages.Promise)
local EmptyState = UIBlox.App.Indicator.EmptyState

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local cFrame = CFrame.fromEulerAnglesXYZ(0.3490658503988659, 0.2617993877991494, 0.6981317007977318)
local v12 = game:DefineFastInt("AXClusterCompositionTimeoutMs", 3000)
local v13 = Roact.PureComponent:extend("HumanoidViewport")

v13.validateProps = t.strictInterface({
	humanoidDescription = t.optional(t.instanceOf("HumanoidDescription")),
	loadingFailed = t.boolean,
	retryLoadDescription = t.callback,
	rigType = t.optional(t.enum(Enum.HumanoidRigType))
})

function v13.init(p1) -- line: 34
	-- upvalues: Roact (copy)
	p1:setState({
		loading = true,
		loadingFailed = false
	})
	p1.cameraRef = Roact.createRef()
	p1.worldModelRef = Roact.createRef()

	local v18, v19 = Roact.createBinding(CFrame.new())

	p1.cameraCFrameBinding = v18
	p1.updateCameraCFrameBinding = v19

	local v20, v21 = Roact.createBinding(CFrame.new())

	p1.cameraFocusBinding = v20
	p1.updateCameraFocusBinding = v21
	p1.humanoidModel = nil
	p1.mounted = false

	function p1.onRetryLoading() -- line: 50
		-- upvalues: p1 (copy)
		p1:setState({
			loading = true,
			loadingFailed = false
		})

		if p1.props.humanoidDescription then
			p1:loadHumanoidModel()

			return
		end

		p1.props.retryLoadDescription()
	end
end

local function rotateLookVector(p2) -- line: 64
	-- upvalues: cFrame (copy)
	local v23 = if not (math.abs(p2.Y) > 0.95) then Vector3.new(p2.X, 0, p2.Z).unit else Vector3.new(0, 0, -1)

	return (CFrame.new(Vector3.new(0, 0, 0), v23) * cFrame).lookVector
end
local function getCameraOffset(p3, p4) -- line: 77
	local p4X = p4.X
	local p4Y = p4.Y
	local p4Z = p4.Z
	local v29 = math.max(p4X, p4Y)
	local v30 = 1 / math.tan(math.rad(p3) / 2)

	return v29 / 2 * v30 + p4Z / 2
end
local function zoomExtents(p5, p6, p7) -- line: 87
	local p = p5:GetModelCFrame().p
	local ExtentsSize = p5:GetExtentsSize()
	local ExtentsSizeX = ExtentsSize.X
	local ExtentsSizeY = ExtentsSize.Y
	local ExtentsSizeZ = ExtentsSize.Z
	local v39 = (math.max(ExtentsSizeX, ExtentsSizeY) / 2 * 1.4281480067421146 + ExtentsSizeZ / 2) * 1

	return p7 - p7.p + p + p6 * v39
end

function v13.positionCamera(p8) -- line: 98
	-- upvalues: cFrame (copy)
	local humanoidModel = p8.humanoidModel
	local ModelCFrame = humanoidModel:GetModelCFrame()
	local lookVector = ModelCFrame.lookVector
	local HumanoidRootPart = humanoidModel:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		lookVector = HumanoidRootPart.CFrame.lookVector
	end

	local v45 = if not (math.abs(lookVector.Y) > 0.95) then Vector3.new(lookVector.X, 0, lookVector.Z).unit else Vector3.new(0, 0, -1)
	local lookVector2 = (CFrame.new(Vector3.new(0, 0, 0), v45) * cFrame).lookVector
	local cFrame2 = CFrame.new(ModelCFrame.p + lookVector2 * 5, ModelCFrame.p)
	local p = humanoidModel:GetModelCFrame().p
	local ExtentsSize = humanoidModel:GetExtentsSize()
	local ExtentsSizeX = ExtentsSize.X
	local ExtentsSizeY = ExtentsSize.Y
	local ExtentsSizeZ = ExtentsSize.Z
	local v53 = (math.max(ExtentsSizeX, ExtentsSizeY) / 2 * 1.4281480067421146 + ExtentsSizeZ / 2) * 1
	local v54 = cFrame2 - cFrame2.p + p + lookVector2 * v53

	p8.updateCameraCFrameBinding(v54)
	p8.updateCameraFocusBinding(ModelCFrame)
end
function v13.loadIdleAnimation(_, p10) -- line: 115
	local Humanoid = p10:FindFirstChildOfClass("Humanoid")

	if Humanoid.HumanoidDescription.IdleAnimation == 0 then
		return
	end

	local Animate = p10:FindFirstChild("Animate")

	if not Animate then
		return
	end

	local idle = Animate:FindFirstChild("idle")

	if not idle then
		return
	end

	local Animation = idle:FindFirstChildOfClass("Animation")

	if not Animation then
		return
	end

	local track = Humanoid:LoadAnimation(Animation)

	track.Looped = true
	track:Play()
end
function v13.loadHumanoidModel(p11) -- line: 143
	-- upvalues: Players (copy), Promise (copy), v12 (copy)
	local humanoidDescription = p11.props.humanoidDescription
	local rigType = p11.props.rigType

	coroutine.wrap(function() -- line: 147
		-- upvalues: Players (copy), humanoidDescription (copy), rigType (copy), p11 (copy), Promise (copy), v12 (copy)
		local u75 = nil

		pcall(function() -- line: 149
			-- upvalues: u75 (ref), Players (copy), humanoidDescription (copy), rigType (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				u75 = Players:CreateHumanoidModelFromDescriptionAsync(humanoidDescription, rigType)

				return
			end

			u75 = Players:CreateHumanoidModelFromDescription(humanoidDescription, rigType)
		end)

		if not p11.mounted then
			return
		end

		if p11.props.humanoidDescription ~= humanoidDescription then
			return
		end

		if p11.props.rigType ~= rigType then
			return
		end

		if u75 == nil then
			p11:setState({
				loadingFailed = true
			})

			return
		end

		p11.humanoidModel = u75

		if p11.worldModelRef:getValue() then
			p11.humanoidModel.Parent = p11.worldModelRef:getValue()
		end

		if #humanoidDescription:GetAccessories(false) > 0 then
			Promise.race({
				Promise.fromEvent(u75.Humanoid.ClusterCompositionFinished),
				Promise.delay(v12 * 0.001)
			}):await()
		end

		if not p11.mounted then
			return
		end

		p11:positionCamera()
		p11:loadIdleAnimation(u75)
		p11:setState({
			loading = false,
			loadingFailed = false
		})
	end)()
end
function v13.render(p12) -- line: 205
	-- upvalues: Roact (copy), Skeleton (copy), EmptyState (copy), RobloxTranslator (copy)
	local v66 = p12.props.loadingFailed or p12.state.loadingFailed
	local v67 = not v66 and p12.state.loading
	local v68 = v66 or p12.state.loading

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ShimmerFrame = v67 and Roact.createElement(Skeleton, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		LoadingFailed = v66 and Roact.createElement(EmptyState, {
			text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.ItemsListLoadingFailed"),
			size = UDim2.fromScale(1, 1),
			onActivated = p12.onRetryLoading
		}),
		ViewportFrame = Roact.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			Visible = not v68,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LightColor = Color3.fromRGB(240, 240, 240),
			Ambient = Color3.fromRGB(240, 240, 240),
			CurrentCamera = p12.cameraRef
		}, {
			Camera = Roact.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = 70,
				CFrame = p12.cameraCFrameBinding,
				Focus = p12.cameraFocusBinding,
				[Roact.Ref] = p12.cameraRef
			}),
			WorldModel = Roact.createElement("WorldModel", {
				[Roact.Ref] = p12.worldModelRef
			})
		})
	})
end
function v13.didMount(p13) -- line: 261
	p13.mounted = true

	if p13.props.humanoidDescription then
		p13:loadHumanoidModel()
	end
end
function v13.didUpdate(p14, p15) -- line: 269
	if p14.worldModelRef:getValue() and p14.humanoidModel then
		p14.humanoidModel.Parent = p14.worldModelRef:getValue()
	end

	local v72 = p14.props.humanoidDescription ~= p15.humanoidDescription
	local v73 = p14.props.rigType ~= p15.rigType

	if p14.props.rigType ~= nil and (p14.props.humanoidDescription ~= nil and (v72 or v73)) then
		p14:setState({
			loading = true
		})

		if p14.props.humanoidDescription ~= nil then
			p14:loadHumanoidModel()
		end
	end
end
function v13.willUnmount(p16) -- line: 291
	p16.mounted = false
end

return v13
