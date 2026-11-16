local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local view = Foundation.View
local image = Foundation.Image

local function SduiDetailsPageImageHeader(props)
	return React.createElement(view, {
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
		Image = React.createElement(image, {
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
