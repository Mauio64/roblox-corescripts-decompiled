local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)

local function CardMedia(props)
	local sizeConstraint = nil
	local flexItem = nil
	local udim

	if props.isEnd then
		udim = UDim2.new(0, props.width, props.isFillHeight and 1 or 0, 0)
		sizeConstraint = {
			MaxSize = Vector2.new(props.width, 1e999)
		}

		flexItem = {
			FlexMode = Enum.UIFlexMode.Shrink,
			ItemLineAlignment = Enum.ItemLineAlignment.Stretch
		}
	else
		udim = UDim2.new(1, 0, 0, props.bottomHeight)
	end

	return React.createElement(Image, {
		Image = props.image,
		ScaleType = Enum.ScaleType.Crop,
		tag = props.tag,
		Size = udim,
		sizeConstraint = sizeConstraint,
		flexItem = flexItem,
		LayoutOrder = 2,
		testId = `{props.testId}--image`
	})
end

return CardMedia
