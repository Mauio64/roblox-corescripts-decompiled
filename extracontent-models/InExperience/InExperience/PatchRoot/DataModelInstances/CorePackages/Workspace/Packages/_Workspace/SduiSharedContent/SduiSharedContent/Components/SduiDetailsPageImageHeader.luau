local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local View = Foundation.View
local Image = Foundation.Image

local function SduiDetailsPageImageHeader(props)
	return React.createElement(View, {
		tag = "col align-x-center align-y-center",
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Visible = props.visible,
		ZIndex = props.zIndex,
		backgroundStyle = props.backgroundStyle,
		AutomaticSize = props.automaticSize,
		testId = props.testId
	}, {
		Image = React.createElement(Image, {
			Image = props.image,
			Size = props.imageSize,
			TileSize = props.tileSize,
			ScaleType = props.scaleType,
			ResampleMode = props.resampleMode,
			imageStyle = props.imageStyle,
			tag = props.imageTag,
			SizeConstraint = props.imageSizeConstraint
		})
	})
end

return React.memo(SduiDetailsPageImageHeader)
