local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

require(parent.Types)

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Image = Foundation.Image
local View = Foundation.View

local getContentFromObject = CapturesCommon.Utils.getContentFromObject

local function renderThumbnailSlot(p, p2, flag: boolean)
	local createElement = React.createElement
	local v = {
		scale = p2.scale,
		ZIndex = flag and 2 or 1,
		tag = "position-center-center anchor-center-center size-full"
	}

	local createElement2 = React.createElement
	local imageContent

	if p then
		imageContent = getContentFromObject(p)
	end

	return createElement(View, v, {
		Thumbnail = createElement2(Image, {
			ImageContent = imageContent,
			imageStyle = p2.style,
			ScaleType = Enum.ScaleType.Crop,
			tag = "position-center-center anchor-center-center size-600-600 radius-small"
		})
	})
end

local function GalleryButtonContentView(props)
	return React.createElement(View, { tag = "size-1200-1200" }, {
		GalleryThumbnail1 = renderThumbnailSlot(props.slotCaptures[1], props.thumbnails[1], props.activeSlot == 1),
		GalleryThumbnail2 = renderThumbnailSlot(props.slotCaptures[2], props.thumbnails[2], props.activeSlot == 2),
		GalleryIcon = React.createElement(
			View,
			{
				scale = props.iconScale,
				tag = "position-center-center anchor-center-center size-full"
			},
			{
				Icon = React.createElement(Icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = IconName.ImageStacked,
					size = IconSize.Large,
					style = props.iconStyle
				})
			}
		)
	})
end

return GalleryButtonContentView
