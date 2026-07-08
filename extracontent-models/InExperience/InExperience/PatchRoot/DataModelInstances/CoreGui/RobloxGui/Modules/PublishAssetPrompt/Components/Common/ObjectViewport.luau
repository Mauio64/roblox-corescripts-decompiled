local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local Constants = require(script.Parent.Parent.Parent.Constants)
local CharacterUtility = require(CorePackages.Packages.Thumbnailing).CharacterUtility
local CameraUtility = require(CorePackages.Packages.Thumbnailing).CameraUtility
local CFrameUtility = require(CorePackages.Packages.Thumbnailing).CFrameUtility
local EmoteUtility = require(CorePackages.Packages.Thumbnailing).EmoteUtility
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local v17 = Images["icons/actions/previewExpand"]
local v18 = Images["component_assets/dropshadow_25"]
local uDim2 = UDim2.new(0.4, 50, 0.15, 10)
local uDim2_2 = UDim2.new(0.5, 0, 1, 0)
local v21 = Roact.PureComponent:extend("ObjectViewport")

v21.validateProps = t.strictInterface({
	model = t.optional(t.instanceOf("Model")),
	fieldOfView = t.optional(t.number),
	isLoading = t.optional(t.boolean),
	useFullBodyCameraSettings = t.optional(t.boolean),
	openPreviewView = t.optional(t.callback),
	LayoutOrder = t.optional(t.number),
	isHumanoidModel = t.optional(t.boolean)
})

function v21.createCamera(p1) -- line: 48
	local Camera = Instance.new("Camera")

	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.Parent = p1.worldModelRef:getValue()
	Camera.HeadLocked = true
	Camera.VRTiltAndRollEnabled = true

	return Camera
end
function v21.init(p2) -- line: 58
	-- upvalues: Roact (copy)
	p2.worldModelRef = Roact.createRef()

	local v26, v27 = Roact.createBinding(nil)

	p2.camera = v26
	p2.updateCamera = v27
	p2.isMounted = false
end

local function getCameraDistance(p3, p4) -- line: 64
	local p4X = p4.X
	local p4Y = p4.Y
	local p4Z = p4.Z
	local v33 = math.max(p4X, p4Y, p4Z)
	local v34 = 1 / math.tan(math.rad(p3) / 2)

	return v33 / 2 * v34 + p4Z / 2
end

function v21.setupViewportForAsset(p5) -- line: 72
	if not p5.props.model then
		return
	end

	local clone = p5.props.model:Clone()

	clone.Parent = p5.worldModelRef:getValue()

	local ModelCFrame, ExtentsSize

	if clone:IsA("Model") then
		clone:MoveTo((Vector3.new(0, 0, 0)))
		ModelCFrame = clone:GetModelCFrame()
		ExtentsSize = clone:GetExtentsSize()
	else
		local MeshPart = clone:FindFirstChildWhichIsA("MeshPart", true)

		if not MeshPart then
			return
		end

		MeshPart.CFrame = CFrame.new(0, 0, 0)
		ModelCFrame = MeshPart.CFrame
		ExtentsSize = MeshPart.Size
	end

	local lookVector = ModelCFrame.lookVector
	local v41 = p5:createCamera()
	local v42 = not p5.props.fieldOfView and 30 or p5.props.fieldOfView
	local ExtentsSizeX = ExtentsSize.X
	local ExtentsSizeY = ExtentsSize.Y
	local ExtentsSizeZ = ExtentsSize.Z
	local v46 = math.max(ExtentsSizeX, ExtentsSizeY, ExtentsSizeZ)
	local v47 = 1 / math.tan(math.rad(v42) / 2)
	local v48 = v46 / 2 * v47 + ExtentsSizeZ / 2
	local vector2 = Vector2.new(5, 20)
	local v50 = math.rad(vector2.X)
	local v51 = math.rad(vector2.Y)
	local v52 = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), v50):VectorToWorldSpace(lookVector)
	local v53 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v51):VectorToWorldSpace(v52)
	local v54 = ModelCFrame.Position + v53 * v48

	v41.CFrame = CFrame.new(v54, ModelCFrame.Position)
	v41.FieldOfView = v42
	p5.updateCamera(v41)
end
function v21.setupViewport(p6) -- line: 130
	-- upvalues: EmoteUtility (copy), RunService (copy), CFrameUtility (copy), CharacterUtility (copy), CameraUtility (copy)
	local clone = p6.props.model:Clone()

	assert(clone.PrimaryPart, "The Model should have a PrimaryPart for setting up Camera")
	clone.Parent = p6.worldModelRef:getValue()
	clone:MoveTo((Vector3.new(0, 0, 0)))

	local useFullBodyCameraSettings = p6.props.useFullBodyCameraSettings

	if useFullBodyCameraSettings then
		EmoteUtility.SetPlayerCharacterPoseWithMoodFallback(clone)
		RunService.PostSimulation:Wait()

		if not p6.isMounted then
			return
		end
	end

	local v58 = p6:createCamera()
	local v60

	if useFullBodyCameraSettings then
		local v59 = CFrameUtility.CalculateTargetCFrame(clone.Head.CFrame)

		v60 = v59 - v59.Position + clone.PrimaryPart.CFrame.Position
	else
		v60 = clone.PrimaryPart.CFrame
	end

	local v61, v62 = CharacterUtility.CalculateModelExtents(clone, v60)
	local t1 = {
		extentScale = 1,
		optFieldOfView = not p6.props.fieldOfView and 30 or p6.props.fieldOfView,
		targetCFrame = v60,
		minExtent = v61,
		maxExtent = v62
	}

	if useFullBodyCameraSettings then
		t1.optCameraXRot = CameraUtility.XRotForFullBody
		t1.optCameraDistanceScale = CameraUtility.DistanceScaleForFullBody
		t1.extentScale = CameraUtility.DefaultBodyMarginScale
	else
		t1.optCameraYRot = 25
	end

	CameraUtility.SetupCamera(v58, t1)
	p6.updateCamera(v58)
end
function v21.didMount(p7) -- line: 174
	p7.isMounted = true
	task.spawn(function() -- line: 176
		-- upvalues: p7 (copy)
		if not p7.props.isLoading then
			if p7.props.isHumanoidModel then
				p7:setupViewport()

				return
			end

			p7:setupViewportForAsset()
		end
	end)
end
function v21.didUpdate(p8, p9) -- line: 187
	if p9.isLoading and not p8.props.isLoading then
		task.spawn(function() -- line: 190
			-- upvalues: p8 (copy)
			if p8.props.isHumanoidModel then
				p8:setupViewport()

				return
			end

			p8:setupViewportForAsset()
		end)
	end
end
function v21.render(p10) -- line: 200
	-- upvalues: withStyle (copy), Roact (copy), Constants (copy), IconButton (copy), v17 (copy), IconSize (copy), ImageSetLabel (copy), uDim2_2 (copy), v18 (copy), uDim2 (copy), Skeleton (copy)
	return withStyle(function(p11) -- line: 201
		-- upvalues: p10 (copy), Roact (copy), Constants (copy), IconButton (copy), v17 (copy), IconSize (copy), ImageSetLabel (copy), uDim2_2 (copy), v18 (copy), uDim2 (copy), Skeleton (copy)
		local Theme = p11.Theme

		if not p10.props.isLoading then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, Constants.PromptSidePadding * 2, 0, 240),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LayoutOrder = p10.props.LayoutOrder
			}, {
				ViewportFrame = Roact.createElement("ViewportFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					LightColor = Constants.ViewportLightColor,
					Ambient = Constants.ViewportLightAmbient,
					LightDirection = Constants.ViewportLightDirection,
					CurrentCamera = p10.camera
				}, {
					WorldModel = Roact.createElement("WorldModel", {
						[Roact.Ref] = p10.worldModelRef
					})
				}),
				ExpandPreviewButton = p10.props.openPreviewView and Roact.createElement(IconButton, {
					position = UDim2.new(1, -Constants.PromptSidePadding, 1, 0),
					anchorPoint = Vector2.new(1, 1),
					icon = v17,
					iconSize = IconSize.Medium,
					onActivated = p10.props.openPreviewView
				}),
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Theme.BackgroundMuted.Color),
						ColorSequenceKeypoint.new(1, Theme.BackgroundMuted.Color)
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.7, 0.75),
						NumberSequenceKeypoint.new(1, 1)
					})
				}),
				DropShadow = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ImageTransparency = 0.5,
					ZIndex = 0,
					Position = uDim2_2,
					AnchorPoint = Vector2.new(0.5, 1),
					Image = v18,
					Size = uDim2
				})
			})
		end

		return (Roact.createElement(Skeleton, {
			Size = UDim2.new(1, Constants.PromptSidePadding * 2, 0, 240),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LayoutOrder = p10.props.LayoutOrder
		}))
	end)
end
function v21.willUnmount(p12) -- line: 267
	p12.isMounted = false
end

return v21
