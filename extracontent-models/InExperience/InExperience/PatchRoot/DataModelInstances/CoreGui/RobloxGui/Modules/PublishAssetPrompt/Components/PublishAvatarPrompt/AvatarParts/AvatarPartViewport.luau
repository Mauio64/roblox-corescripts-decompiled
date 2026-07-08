local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local CameraUtility = require(CorePackages.Packages.Thumbnailing).CameraUtility
local MannequinUtility = require(CorePackages.Packages.Thumbnailing).MannequinUtility
local Constants = require(script.Parent.Parent.Parent.Parent.Constants)
local MakeupPreviewUtils = require(script.Parent.Parent.Parent.Parent.MakeupPreviewUtils)
local GetFFlagSingleUploadMakeupSupport = require(script.Parent.Parent.Parent.Parent.Flags.GetFFlagSingleUploadMakeupSupport)
local v10 = Roact.PureComponent:extend("AvatarPartViewport")

v10.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.number),
	asset = t.union(t.table, t.instanceOf("MeshPart"), t.instanceOf("Accessory"), t.instanceIsA("Decal")),
	assetType = t.optional(t.EnumItem),
	viewportSize = t.optional(t.Vector2)
})

function v10.init(p1) -- line: 38
	-- upvalues: Roact (copy)
	p1.camera = nil
	p1.modelRef = Roact.createRef()

	local v12, v13 = Roact.createBinding(nil)

	p1.camera = v12
	p1.updateCamera = v13
end
function v10.createViewportCamera(p2) -- line: 44
	local Camera = Instance.new("Camera")

	Camera.Parent = p2.modelRef:getValue()
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.HeadLocked = true
	Camera.VRTiltAndRollEnabled = true

	return Camera
end
function v10.addBodyPartMannequinToViewport(p3) -- line: 55
	-- upvalues: MannequinUtility (copy), CameraUtility (copy)
	local v17, v18, v19 = MannequinUtility.CreateBodyPartMannequin(p3.props.asset, false)
	local v20, v21 = MannequinUtility.SetupBodyPartMannequin(v17, v18, v19, p3.props.asset)

	v19.Parent = p3.modelRef:getValue()

	local v22 = p3:createViewportCamera()

	CameraUtility.SetupBodyPartCamera(v19, v20, v21, v22)
	p3.updateCamera(v22)
end
function v10.addHeadModelToViewport(p4) -- line: 67
	-- upvalues: MannequinUtility (copy), CameraUtility (copy)
	local v24 = MannequinUtility.CreateHeadModel(p4.props.asset)

	v24.Parent = p4.modelRef:getValue()

	local v25 = p4:createViewportCamera()

	CameraUtility.SetupHeadCamera(v24, v25)
	p4.updateCamera(v25)
end
function v10.addAccessoryToViewport(p5) -- line: 76
	-- upvalues: CameraUtility (copy)
	local asset = p5.props.asset
	local Model = Instance.new("Model")

	asset.Parent = Model
	Model.Parent = p5.modelRef:getValue()

	local v29 = p5:createViewportCamera()

	CameraUtility.SetupAccessoryCamera(Model, v29)
	p5.updateCamera(v29)
end
function v10.addMakeupDecalToViewport(p6) -- line: 86
	-- upvalues: MakeupPreviewUtils (copy), CameraUtility (copy)
	local v31 = MakeupPreviewUtils.createMakeupThumbnailPreview(p6.props.asset, p6.props.assetType)

	if not v31 then
		return
	end

	v31.Parent = p6.modelRef:getValue()

	local v32 = p6:createViewportCamera()

	CameraUtility.SetupHeadCamera(v31, v32)
	p6.updateCamera(v32)
end
function v10.didMount(p7) -- line: 98
	-- upvalues: GetFFlagSingleUploadMakeupSupport (copy), MakeupPreviewUtils (copy)
	local asset = p7.props.asset

	if typeof(asset) == "Instance" then
		if asset:IsA("MeshPart") then
			p7:addHeadModelToViewport()

			return
		end

		if GetFFlagSingleUploadMakeupSupport() and (asset:IsA("Decal") or p7.props.assetType and MakeupPreviewUtils.isMakeupAssetType(p7.props.assetType)) then
			p7:addMakeupDecalToViewport()

			return
		end

		p7:addAccessoryToViewport()

		return
	end

	p7:addBodyPartMannequinToViewport()
end
function v10.render(p8) -- line: 119
	-- upvalues: withStyle (copy), Constants (copy), Roact (copy)
	return withStyle(function(p9) -- line: 120
		-- upvalues: p8 (copy), Constants (copy), Roact (copy)
		local Theme = p9.Theme
		local v38 = if not p8.props.viewportSize then Constants.ItemCardWidthLandscape else p8.props.viewportSize

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			LayoutOrder = p8.props.LayoutOrder,
			BackgroundColor3 = Theme.PlaceHolder.Color,
			BackgroundTransparency = Theme.PlaceHolder.Transparency,
			Size = UDim2.fromOffset(v38, v38)
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10)
			}),
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			ViewportFrame = Roact.createElement("ViewportFrame", {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Constants.ViewportLightColor,
				Ambient = Constants.ViewportLightAmbient,
				LightDirection = Constants.ViewportLightDirection,
				CurrentCamera = p8.camera
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10)
				}),
				WorldModel = Roact.createElement("WorldModel", {
					[Roact.Ref] = p8.modelRef
				})
			})
		})
	end)
end

return v10
