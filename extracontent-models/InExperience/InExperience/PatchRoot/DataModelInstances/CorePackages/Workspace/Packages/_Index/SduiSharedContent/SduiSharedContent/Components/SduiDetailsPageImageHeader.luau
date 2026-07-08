local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local View = Foundation.View
local FoundationImage = Foundation.Image

local function SduiDetailsPageImageHeader(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), View (copy), FoundationImage (copy)
	return React.createElement(View, {
		tag = "col align-x-center align-y-center",
		Size = t1.size,
		Position = t1.position,
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		backgroundStyle = t1.backgroundStyle,
		AutomaticSize = t1.automaticSize,
		testId = t1.testId
	}, {
		Image = React.createElement(FoundationImage, {
			Image = t1.image,
			Size = t1.imageSize,
			TileSize = t1.tileSize,
			ScaleType = t1.scaleType,
			ResampleMode = t1.resampleMode,
			imageStyle = t1.imageStyle,
			tag = t1.imageTag,
			SizeConstraint = t1.imageSizeConstraint
		})
	})
end

return React.memo(SduiDetailsPageImageHeader)
