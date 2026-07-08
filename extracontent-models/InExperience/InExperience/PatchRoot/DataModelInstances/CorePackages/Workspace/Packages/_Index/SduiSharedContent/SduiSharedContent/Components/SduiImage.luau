local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function SduiImage(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Image, {
		AnchorPoint = t1.anchorPoint,
		AutomaticSize = t1.automaticSize,
		ClipsDescendants = t1.clipsDescendants,
		Image = t1.image,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		ResampleMode = t1.resampleMode,
		ScaleType = t1.scaleType,
		Size = t1.size,
		SizeConstraint = t1.sizeConstraint,
		TileSize = t1.tileSize,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		aspectRatio = t1.aspectRatio,
		backgroundStyle = t1.backgroundStyle,
		cornerRadius = t1.cornerRadius,
		cursor = t1.cursorType,
		imageStyle = t1.imageStyle,
		onActivated = t1.onActivated,
		tag = t1.tag,
		testId = t1.testId
	})
end

return SduiImage
