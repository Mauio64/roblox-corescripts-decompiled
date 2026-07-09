local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local function SduiContentRatingLabel(t1: {[any]: any}) -- line: 28
	-- upvalues: useScaledValue (copy), useTokens (copy), React (copy), View (copy), Foundation (copy), FoundationImage (copy), FoundationText (copy)
	local v11 = useScaledValue(t1.width or 450)
	local v12 = useTokens()

	return React.createElement(View, {
		tag = "padding-medium gap-large radius-medium row align-y-center stroke-default size-full-0 auto-y",
		onActivated = t1.onActivated,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		LayoutOrder = t1.layoutOrder
	}, {
		SizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v11, 1e999),
			MinSize = Vector2.new(0, v12.Size.Size_1700)
		}),
		RatingImage = if not t1.image then nil else React.createElement(FoundationImage, {
			tag = "size-1700-1700",
			LayoutOrder = 1,
			Image = t1.image,
			ScaleType = Enum.ScaleType.Fit
		}),
		RatingText = React.createElement(FoundationText, {
			tag = "fill auto-y text-wrap text-align-x-left",
			LayoutOrder = 2,
			Text = t1.displayText or "",
			fontStyle = t1.fontStyle
		})
	})
end

return React.memo(SduiContentRatingLabel)
