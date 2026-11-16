local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Progress = Foundation.Progress
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local Constants = require(script.Parent.Parent.Parent.Constants)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.MakeupPreviewUtils)
local FFlagIECPublishValidationLoadingUI = require(script.Parent.Parent.Parent.Flags.FFlagIECPublishValidationLoadingUI)
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local CharacterUtility = Thumbnailing.CharacterUtility
local Thumbnailing2 = require(CorePackages.Packages.Thumbnailing)
local CameraUtility = Thumbnailing2.CameraUtility
local Thumbnailing3 = require(CorePackages.Packages.Thumbnailing)
local CFrameUtility = Thumbnailing3.CFrameUtility
local Thumbnailing4 = require(CorePackages.Packages.Thumbnailing)
local EmoteUtility = Thumbnailing4.EmoteUtility

local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local iconsactionspreviewExpand = Images["icons/actions/previewExpand"]
local component_assetsdropshadow_25 = Images["component_assets/dropshadow_25"]

local udim = UDim2.new(0.4, 50, 0.15, 10)
local udim2 = UDim2.new(0.5, 0, 1, 0)

local extended = Roact.PureComponent:extend("ObjectViewport")

local function getReviewingCreationText() -- 1 equivalent call inferred from this helper
	local success, result = pcall(
		RobloxTranslator.FormatByKey,
		RobloxTranslator,
		"CoreScripts.PublishCommon.ReviewingCreation"
	)
	return if success then result else "Reviewing your creation..."
end

extended.validateProps = t.strictInterface({
	model = t.optional(t.instanceOf("Model")),
	fieldOfView = t.optional(t.number),
	isLoading = t.optional(t.boolean),
	useFullBodyCameraSettings = t.optional(t.boolean),
	openPreviewView = t.optional(t.callback),
	LayoutOrder = t.optional(t.number),
	isHumanoidModel = t.optional(t.boolean),
	isMakeupPreview = t.optional(t.boolean)
})

function extended:createCamera()
	local camera = Instance.new("Camera")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.Parent = self.worldModelRef:getValue()
	camera.HeadLocked = true
	camera.VRTiltAndRollEnabled = true

	return camera
end

function extended:init()
	self.worldModelRef = Roact.createRef()
	local binding, updateCamera = Roact.createBinding(nil)
	self.camera = binding
	self.updateCamera = updateCamera
	self.isMounted = false
end

local function getCameraDistance(p, data) -- 1 equivalent call inferred from this helper
	local x = data.X
	local y = data.Y
	local z = data.Z
	local v = math.max(x, y, z)
	local v2 = 1 / math.tan(math.rad(p) / 2)
	return v / 2 * v2 + z / 2
end

function extended:setupViewportForAsset()
	if not self.props.model then
		return
	end

	local clone = self.props.model:Clone()
	clone.Parent = self.worldModelRef:getValue()
	local v, v2

	if clone:IsA("Model") then
		clone:MoveTo(Vector3.new(0, 0, 0))
		local v3, v4

		if self.props.isMakeupPreview then
			v3, v4 = MakeupPreviewUtils.getHeadPreviewCameraData(clone)
		end

		v = v3 or clone:GetModelCFrame()
		v2 = v4 or clone:GetExtentsSize()
	else
		local meshPart = clone:FindFirstChildWhichIsA("MeshPart", true)

		if not meshPart then
			return
		end

		meshPart.CFrame = CFrame.new(0, 0, 0)
		v = meshPart.CFrame
		v2 = meshPart.Size
	end

	local lookVector = v.lookVector

	local camera = self:createCamera()

	local fieldOfView = not self.props.fieldOfView and 30 or self.props.fieldOfView
	local cameraDistance = getCameraDistance(fieldOfView, v2) -- inferred equivalent call
	local vector2 = Vector2.new(5, 20)

	local x = math.rad(vector2.X)
	local y = math.rad(vector2.Y)

	local vectorToWorldSpace = CFrame.fromAxisAngle(Vector3.new(1, 0, 0), x):VectorToWorldSpace(lookVector)
	local vectorToWorldSpace2 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), y):VectorToWorldSpace(vectorToWorldSpace)

	local v3 = v.Position + vectorToWorldSpace2 * cameraDistance
	camera.CFrame = CFrame.new(v3, v.Position)
	camera.FieldOfView = fieldOfView

	self.updateCamera(camera)
end

function extended:setupViewport()
	local clone = self.props.model:Clone()
	assert(clone.PrimaryPart, "The Model should have a PrimaryPart for setting up Camera")
	clone.Parent = self.worldModelRef:getValue()
	clone:MoveTo(Vector3.new(0, 0, 0))

	local useFullBodyCameraSettings = self.props.useFullBodyCameraSettings

	if useFullBodyCameraSettings then
		EmoteUtility.SetPlayerCharacterPoseWithMoodFallback(clone)

		RunService.PostSimulation:Wait()

		if not self.isMounted then
			return
		end
	end

	local camera = self:createCamera()
	local targetCFrame2

	if useFullBodyCameraSettings then
		local targetCFrame = CFrameUtility.CalculateTargetCFrame(clone.Head.CFrame)
		targetCFrame2 = targetCFrame - targetCFrame.Position + clone.PrimaryPart.CFrame.Position
	else
		targetCFrame2 = clone.PrimaryPart.CFrame
	end

	local modelExtents, maxExtent = CharacterUtility.CalculateModelExtents(clone, targetCFrame2)
	local v = {
		optFieldOfView = not self.props.fieldOfView and 30 or self.props.fieldOfView,
		targetCFrame = targetCFrame2,
		minExtent = modelExtents,
		maxExtent = maxExtent,
		extentScale = 1
	}

	if useFullBodyCameraSettings then
		v.optCameraXRot = CameraUtility.XRotForFullBody
		v.optCameraDistanceScale = CameraUtility.DistanceScaleForFullBody
		v.extentScale = CameraUtility.DefaultBodyMarginScale
	else
		v.optCameraYRot = 25
	end

	CameraUtility.SetupCamera(camera, v)
	self.updateCamera(camera)
end

function extended:didMount()
	self.isMounted = true
	task.spawn(function()
		if not self.props.isLoading then
			if self.props.isHumanoidModel then
				self:setupViewport()
			else
				self:setupViewportForAsset()
			end
		end
	end)
end

function extended:didUpdate(p)
	if p.isLoading and not self.props.isLoading then
		task.spawn(function()
			if self.props.isHumanoidModel then
				self:setupViewport()
			else
				self:setupViewportForAsset()
			end
		end)
	end
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme

		if data.props.isLoading then
			if not FFlagIECPublishValidationLoadingUI then
				return (Roact.createElement(Skeleton, {
					Size = UDim2.new(1, Constants.PromptSidePadding * 2, 0, 240),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					LayoutOrder = data.props.LayoutOrder
				}))
			end

			return (Roact.createElement(
				"CanvasGroup",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 240),
					LayoutOrder = data.props.LayoutOrder
				},
				{
					Content = Roact.createElement(
						View,
						{ tag = "col align-x-center align-y-center gap-medium size-full" },
						{
							ProgressCircle = Roact.createElement(Progress, {
								shape = ProgressShape.Circle,
								size = ProgressSize.Large
							}),
							Status = Roact.createElement(
								View,
								{
									tag = "row align-x-center align-y-center size-0-800 auto-x radius-circle clip bg-action-utility",
									testId = "reviewing-creation-status"
								},
								{
									Text = Roact.createElement(Text, {
										Text = getReviewingCreationText(), -- inferred equivalent call
										tag = "shrink size-0-full auto-x padding-x-medium text-label-medium text-truncate-end content-action-utility"
									})
								}
							)
						}
					)
				}
			))
		end

		return Roact.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0,
			Size = UDim2.new(1, Constants.PromptSidePadding * 2, 0, 240),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LayoutOrder = data.props.LayoutOrder
		}, {
			ViewportFrame = Roact.createElement("ViewportFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Constants.ViewportLightColor,
				Ambient = Constants.ViewportLightAmbient,
				LightDirection = Constants.ViewportLightDirection,
				CurrentCamera = data.camera
			}, {
				WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = data.worldModelRef })
			}),
			ExpandPreviewButton = data.props.openPreviewView and Roact.createElement(IconButton, {
				position = UDim2.new(1, -Constants.PromptSidePadding, 1, 0),
				anchorPoint = Vector2.new(1, 1),
				icon = iconsactionspreviewExpand,
				iconSize = IconSize.Medium,
				onActivated = data.props.openPreviewView
			}),
			Gradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, theme.BackgroundMuted.Color),
					ColorSequenceKeypoint.new(1, theme.BackgroundMuted.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.7, 0.75),
					NumberSequenceKeypoint.new(1, 1)
				})
			}),
			DropShadow = Roact.createElement(ImageSetLabel, {
				Position = udim2,
				AnchorPoint = Vector2.new(0.5, 1),
				Image = component_assetsdropshadow_25,
				BackgroundTransparency = 1,
				ImageTransparency = 0.5,
				Size = udim,
				ZIndex = 0
			})
		})
	end)
end

function extended:willUnmount()
	self.isMounted = false
end

return extended
