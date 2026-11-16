local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Text = Foundation.Text
local Image = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local function SduiContentRatingLabel(props)
	local v = useScaledValue(props.width or 450)
	local v2 = useTokens()

	local createElement = React.createElement
	local v3 = {
		tag = "padding-medium gap-large radius-medium row align-y-center stroke-default size-full-0 auto-y",
		onActivated = props.onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		LayoutOrder = props.layoutOrder
	}
	local v4 = {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v, 1e999),
			MinSize = Vector2.new(0, v2.Size.Size_1700)
		}),
		RatingImage = 0,
		RatingText = 0
	}
	local ratingImage

	if props.image then
		ratingImage = React.createElement(Image, {
			Image = props.image,
			tag = "size-1700-1700",
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1
		})
	end

	v4.RatingImage = ratingImage

	v4.RatingText = React.createElement(Text, {
		Text = props.displayText or "",
		tag = "fill auto-y text-wrap text-align-x-left",
		LayoutOrder = 2,
		fontStyle = props.fontStyle
	})
	return createElement(View, v3, v4)
end

return React.memo(SduiContentRatingLabel)
