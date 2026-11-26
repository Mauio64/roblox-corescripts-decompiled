local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local text = Foundation.Text
local image = Foundation.Image
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local function SduiContentRatingLabel(props)
	local v5 = useScaledValue(props.width or 450)
	local v6 = useTokens()

	local createElement = React.createElement
	local v8 = {
		tag = "padding-medium gap-large radius-medium row align-y-center stroke-default size-full-0 auto-y",
		onActivated = props.onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		LayoutOrder = props.layoutOrder
	}
	local v9 = {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v5, 1e999),
			MinSize = Vector2.new(0, v6.Size.Size_1700)
		}),
		RatingImage = 0,
		RatingText = 0
	}

	local v10 = if props.image then React.createElement(image, {
		Image = props.image,
		tag = "size-1700-1700",
		ScaleType = Enum.ScaleType.Fit,
		LayoutOrder = 1
	}) else nil
	v9.RatingImage = v10

	v9.RatingText = React.createElement(text, {
		Text = props.displayText or "",
		tag = "fill auto-y text-wrap text-align-x-left",
		LayoutOrder = 2,
		fontStyle = props.fontStyle
	})
	return createElement(view, v8, v9)
end

return React.memo(SduiContentRatingLabel)
