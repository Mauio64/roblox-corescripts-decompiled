local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

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
