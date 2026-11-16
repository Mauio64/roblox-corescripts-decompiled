local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent
local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)
local useStyleMetadata = require(parent2.Core.Style.useStyleMetadata)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local LoadableImage = require(parent2.App.Loading.LoadableImage)
local TileSelectionOverlay = require(parent.TileSelectionOverlay)
local TileUnselectedOverlay = require(parent.TileUnselectedOverlay)

local extended = Roact.PureComponent:extend("TileThumbnail")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	imageSize = UDim2.fromScale(1, 1),
	imageTransparency = 0,
	cornerRadius = UDim.new(0, 10),
	scaleType = Enum.ScaleType.Stretch
}

function extended.render(p)
	local hasRoundedCorners = p.props.hasRoundedCorners
	local image = p.props.Image
	local imageSize = p.props.imageSize
	local imageColor = p.props.imageColor
	local imageTransparency = p.props.imageTransparency
	local isSelected = p.props.isSelected
	local multiSelect = p.props.multiSelect
	local overlayComponents = p.props.overlayComponents
	local backgroundImage = p.props.backgroundImage
	local cornerRadius = p.props.cornerRadius
	local scaleType = p.props.scaleType

	local v = typeof(image) == "table"

	return withStyle(function(p2)
		local theme = p2.Theme
		local hasSurfaceOverrides = p.props.hasSurfaceOverrides
		local createElement = Roact.createElement
		local v2 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

		local createElement2 = Roact.createElement
		local v3 = {
			BackgroundColor3 = theme.PlaceHolder.Color,
			BackgroundTransparency = theme.PlaceHolder.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0
		}

		local createElement3 = Roact.createElement
		local label = ImageSetComponent.Label
		local v4 = {
			Image = backgroundImage,
			ImageColor3 = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = 0,
			Position = 0,
			Size = 0,
			ZIndex = 0
		}
		local imageColor2

		if hasSurfaceOverrides then
			imageColor2 = theme.BackgroundUIDefault.Color:Lerp(
				theme.PlayerBackgroundDefault.Color,
				theme.Overlay.Transparency
			)
		end

		v4.ImageColor3 = imageColor2

		v4.AnchorPoint = Vector2.new(0.5, 0.5)
		v4.Position = UDim2.fromScale(0.5, 0.5)
		v4.Size = UDim2.fromScale(1, 1)
		return createElement("Frame", v2, {
			ImageContainer = createElement2("Frame", v3, {
				BackgroundImage = createElement3(label, v4, {
					ImageSetImage = v and Roact.createElement(ImageSetComponent.Label, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = image,
						ImageColor3 = imageColor or theme.UIEmphasis.Color,
						ImageTransparency = imageTransparency,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = imageSize,
						ScaleType = scaleType
					}, {
						UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
							CornerRadius = cornerRadius
						}) or nil
					}) or Roact.createElement(LoadableImage, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = theme.PlaceHolder.Color,
						BackgroundTransparency = 1,
						Image = image,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = imageSize,
						cornerRadius = hasRoundedCorners and cornerRadius or nil,
						showFailedStateWhenLoadingFailed = true,
						useShimmerAnimationWhileLoading = true,
						ScaleType = scaleType,
						onLoaded = p.props.onThumbnailLoaded
					}),
					UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
						CornerRadius = cornerRadius
					}) or nil
				}),
				UICorner = hasRoundedCorners and Roact.createElement("UICorner", {
					CornerRadius = cornerRadius
				}) or nil
			}),
			ComponentsFrame = overlayComponents and Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 1 },
				overlayComponents
			),
			SelectionOverlay = isSelected and Roact.createElement(TileSelectionOverlay, {
				ZIndex = 2,
				cornerRadius = hasRoundedCorners and cornerRadius or nil
			}),
			UnselectedOverlay = multiSelect and not isSelected and Roact.createElement(TileUnselectedOverlay, {
				ZIndex = 2
			})
		})
	end)
end

local function TileThumbnailFunctionalWrapper(p)
	local v = useStyleMetadata()

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join
	local hasSurfaceOverrides

	if v then
		hasSurfaceOverrides = v.HasSurfaceOverrides
	else
		hasSurfaceOverrides = false
	end

	return createElement(extended, join(p, { hasSurfaceOverrides = hasSurfaceOverrides }))
end

return TileThumbnailFunctionalWrapper
