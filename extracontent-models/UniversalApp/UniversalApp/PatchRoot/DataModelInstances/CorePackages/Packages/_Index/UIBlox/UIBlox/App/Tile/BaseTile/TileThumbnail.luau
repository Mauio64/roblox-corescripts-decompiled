local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local useStyleMetadata = require(ParentParent.Core.Style.useStyleMetadata)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local LoadableImage = require(ParentParent.App.Loading.LoadableImage)
local TileSelectionOverlay = require(scriptParent.TileSelectionOverlay)
local TileUnselectedOverlay = require(scriptParent.TileUnselectedOverlay)
local v13 = Roact.PureComponent:extend("TileThumbnail")

v13.validateProps = t.strictInterface({
	hasRoundedCorners = t.optional(t.boolean),
	cornerRadius = t.optional(t.UDim),
	Image = t.optional(t.union(t.string, t.table)),
	imageSize = t.optional(t.UDim2),
	imageColor = t.optional(t.Color3),
	imageTransparency = t.optional(t.number),
	isSelected = t.optional(t.boolean),
	multiSelect = t.optional(t.boolean),
	overlayComponents = t.optional(t.table),
	backgroundImage = t.optional(t.union(t.string, t.table)),
	scaleType = t.optional(t.enum(Enum.ScaleType)),
	onThumbnailLoaded = t.optional(t.callback),
	hasSurfaceOverrides = t.optional(t.boolean)
})
v13.defaultProps = {
	imageTransparency = 0,
	imageSize = UDim2.fromScale(1, 1),
	cornerRadius = UDim.new(0, 10),
	scaleType = Enum.ScaleType.Stretch
}

function v13.render(p1) -- line: 67
	-- upvalues: withStyle (copy), Roact (copy), ImageSetComponent (copy), LoadableImage (copy), TileSelectionOverlay (copy), TileUnselectedOverlay (copy)
	local hasRoundedCorners = p1.props.hasRoundedCorners
	local propsImage = p1.props.Image
	local imageSize = p1.props.imageSize
	local imageColor = p1.props.imageColor
	local imageTransparency = p1.props.imageTransparency
	local isSelected = p1.props.isSelected
	local multiSelect = p1.props.multiSelect
	local overlayComponents = p1.props.overlayComponents
	local backgroundImage = p1.props.backgroundImage
	local cornerRadius = p1.props.cornerRadius
	local scaleType = p1.props.scaleType
	local v27 = typeof(propsImage) == "table"

	return withStyle(function(p2) -- line: 82
		-- upvalues: p1 (copy), Roact (copy), ImageSetComponent (copy), backgroundImage (copy), v27 (copy), propsImage (copy), imageColor (copy), imageTransparency (copy), imageSize (copy), scaleType (copy), hasRoundedCorners (copy), cornerRadius (copy), LoadableImage (copy), overlayComponents (copy), isSelected (copy), TileSelectionOverlay (copy), multiSelect (copy), TileUnselectedOverlay (copy)
		local Theme = p2.Theme
		local hasSurfaceOverrides = p1.props.hasSurfaceOverrides

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			ImageContainer = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				BackgroundColor3 = Theme.PlaceHolder.Color,
				BackgroundTransparency = Theme.PlaceHolder.Transparency,
				Size = UDim2.fromScale(1, 1)
			}, {
				BackgroundImage = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 0,
					Image = backgroundImage,
					ImageColor3 = if not hasSurfaceOverrides then nil else Theme.BackgroundUIDefault.Color:Lerp(Theme.PlayerBackgroundDefault.Color, Theme.Overlay.Transparency),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1)
				}, {
					ImageSetImage = v27 and Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = propsImage,
						ImageColor3 = imageColor or Theme.UIEmphasis.Color,
						ImageTransparency = imageTransparency,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = imageSize,
						ScaleType = scaleType
					}, {
						UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
							CornerRadius = cornerRadius
						}) or nil
					}) or Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						showFailedStateWhenLoadingFailed = true,
						useShimmerAnimationWhileLoading = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Theme.PlaceHolder.Color,
						Image = propsImage,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = imageSize,
						cornerRadius = hasRoundedCorners and cornerRadius or nil,
						ScaleType = scaleType,
						onLoaded = p1.props.onThumbnailLoaded
					}),
					UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
						CornerRadius = cornerRadius
					}) or nil
				}),
				UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
					CornerRadius = cornerRadius
				}) or nil
			}),
			ComponentsFrame = overlayComponents and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, overlayComponents),
			SelectionOverlay = isSelected and Roact.createElement(TileSelectionOverlay, {
				ZIndex = 2,
				cornerRadius = hasRoundedCorners and cornerRadius or nil
			}),
			UnselectedOverlay = multiSelect and (not isSelected and Roact.createElement(TileUnselectedOverlay, {
				ZIndex = 2
			}))
		})
	end)
end

local function TileThumbnailFunctionalWrapper(p3) -- line: 165
	-- upvalues: useStyleMetadata (copy), Roact (copy), v13 (copy), Cryo (copy)
	local v29 = useStyleMetadata()

	return Roact.createElement(v13, Cryo.Dictionary.join(p3, {
		hasSurfaceOverrides = not not v29 and v29.HasSurfaceOverrides
	}))
end

return TileThumbnailFunctionalWrapper
