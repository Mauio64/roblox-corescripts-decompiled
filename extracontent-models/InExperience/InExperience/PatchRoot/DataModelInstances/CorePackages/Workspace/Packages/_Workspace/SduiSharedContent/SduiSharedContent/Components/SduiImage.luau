local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local function SduiImage(props)
	return React.createElement(Foundation.Image, {
		AnchorPoint = props.anchorPoint,
		AutomaticSize = props.automaticSize,
		ClipsDescendants = props.clipsDescendants,
		Image = props.image,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		ResampleMode = props.resampleMode,
		ScaleType = props.scaleType,
		Size = props.size,
		SizeConstraint = props.sizeConstraint,
		TileSize = props.tileSize,
		Visible = props.visible,
		ZIndex = props.zIndex,
		aspectRatio = props.aspectRatio,
		backgroundStyle = props.backgroundStyle,
		cornerRadius = props.cornerRadius,
		cursor = props.cursorType,
		imageStyle = props.imageStyle,
		onActivated = props.onActivated,
		tag = props.tag,
		testId = props.testId
	})
end

return SduiImage
