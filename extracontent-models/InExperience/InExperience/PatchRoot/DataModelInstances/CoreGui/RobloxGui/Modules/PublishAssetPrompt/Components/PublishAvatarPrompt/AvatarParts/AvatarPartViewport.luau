local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local CameraUtility = Thumbnailing.CameraUtility
local Thumbnailing2 = require(CorePackages.Packages.Thumbnailing)
local MannequinUtility = Thumbnailing2.MannequinUtility
local Constants = require(script.Parent.Parent.Parent.Parent.Constants)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.Parent.MakeupPreviewUtils)

local GetFFlagSingleUploadMakeupSupport = require(script.Parent.Parent.Parent.Parent.Flags.GetFFlagSingleUploadMakeupSupport)

local extended = Roact.PureComponent:extend("AvatarPartViewport")

extended.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.number),
	asset = t.union(t.table, t.instanceOf("MeshPart"), t.instanceOf("Accessory"), t.instanceIsA("Decal")),
	assetType = t.optional(t.EnumItem),
	viewportSize = t.optional(t.Vector2)
})

function extended:init()
	self.camera = nil
	self.modelRef = Roact.createRef()
	local binding, updateCamera = Roact.createBinding(nil)
	self.camera = binding
	self.updateCamera = updateCamera
end

function extended:createViewportCamera()
	local camera = Instance.new("Camera")
	camera.Parent = self.modelRef:getValue()
	camera.CameraType = Enum.CameraType.Scriptable
	camera.HeadLocked = true
	camera.VRTiltAndRollEnabled = true

	return camera
end

function extended:addBodyPartMannequinToViewport()
	local bodyPartMannequin, v, v2 = MannequinUtility.CreateBodyPartMannequin(self.props.asset, false)

	local v3, v4 = MannequinUtility.SetupBodyPartMannequin(bodyPartMannequin, v, v2, self.props.asset)
	v2.Parent = self.modelRef:getValue()
	local viewportCamera = self:createViewportCamera()
	CameraUtility.SetupBodyPartCamera(v2, v3, v4, viewportCamera)
	self.updateCamera(viewportCamera)
end

function extended:addHeadModelToViewport()
	local headModel = MannequinUtility.CreateHeadModel(self.props.asset)
	headModel.Parent = self.modelRef:getValue()
	local viewportCamera = self:createViewportCamera()
	CameraUtility.SetupHeadCamera(headModel, viewportCamera)
	self.updateCamera(viewportCamera)
end

function extended:addAccessoryToViewport()
	local asset = self.props.asset
	local model = Instance.new("Model")
	asset.Parent = model
	model.Parent = self.modelRef:getValue()
	local viewportCamera = self:createViewportCamera()
	CameraUtility.SetupAccessoryCamera(model, viewportCamera)
	self.updateCamera(viewportCamera)
end

function extended:addMakeupDecalToViewport()
	local makeupThumbnailPreview = MakeupPreviewUtils.createMakeupThumbnailPreview(
		self.props.asset,
		self.props.assetType
	)

	if not makeupThumbnailPreview then
		return
	end

	makeupThumbnailPreview.Parent = self.modelRef:getValue()
	local viewportCamera = self:createViewportCamera()

	if MakeupPreviewUtils.setupMakeupThumbnailCamera(makeupThumbnailPreview, viewportCamera, self.props.assetType) then
		self.updateCamera(viewportCamera)
	end
end

function extended:didMount()
	local asset = self.props.asset

	if typeof(asset) ~= "Instance" then
		self:addBodyPartMannequinToViewport()
	elseif asset:IsA("MeshPart") then
		self:addHeadModelToViewport()
	elseif
		GetFFlagSingleUploadMakeupSupport()
		and (asset:IsA("Decal") or self.props.assetType and MakeupPreviewUtils.isMakeupAssetType(self.props.assetType))
	then
		self:addMakeupDecalToViewport()
	else
		self:addAccessoryToViewport()
	end
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme
		local v

		if data.props.viewportSize then
			v = data.props.viewportSize
		else
			v = Constants.ItemCardWidthLandscape
		end

		return Roact.createElement("Frame", {
			LayoutOrder = data.props.LayoutOrder,
			BackgroundColor3 = theme.PlaceHolder.Color,
			BackgroundTransparency = theme.PlaceHolder.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(v, v),
			ZIndex = 0
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			ViewportFrame = Roact.createElement("ViewportFrame", {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				LightColor = Constants.ViewportLightColor,
				Ambient = Constants.ViewportLightAmbient,
				LightDirection = Constants.ViewportLightDirection,
				CurrentCamera = data.camera
			}, {
				UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
				WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = data.modelRef })
			})
		})
	end)
end

return extended
