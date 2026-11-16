local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local InputSize = require(Foundation.Enums.InputSize)

local IconButton = require(Foundation.Components.IconButton)
local View = require(Foundation.Components.View)
require(script.Parent.Parent.useCardVariants)

local Icon = BuilderIcons.Icon
local Small = InputSize.Small

local function CardActions(props)
	local variantProps = props.variantProps

	local createElement = React.createElement
	local v = {
		tag = variantProps.actions.tag,
		AnchorPoint = 0,
		Position = 0,
		LayoutOrder = 0,
		ZIndex = 2,
		testId = 0
	}
	local anchorPoint

	if not props.isInline then
		anchorPoint = Vector2.new(1, 0)
	end

	v.AnchorPoint = anchorPoint
	local position

	if not props.isInline then
		position = UDim2.fromScale(1, 0)
	end

	v.Position = position
	v.LayoutOrder = props.isInline and 2 or nil

	v.testId = `{props.testId}--actions`
	local overflow

	if props.onOverflow then
		local createElement2 = React.createElement
		local v2 = {
			onActivated = props.onOverflow,
			icon = Icon.ThreeDotsHorizontal,
			variant = 0,
			size = 0,
			isCircular = true,
			ref = 0,
			LayoutOrder = 1,
			testId = 0
		}
		local variant

		if props.isOverMedia then
			variant = ButtonVariant.OverMedia
		else
			variant = ButtonVariant.Utility
		end

		v2.variant = variant
		v2.size = Small

		v2.ref = props.overflowRef

		v2.testId = `{props.testId}--overflow`
		overflow = createElement2(IconButton, v2)
	end

	local close

	if props.onClose then
		local createElement2 = React.createElement
		local v2 = {
			onActivated = props.onClose,
			icon = Icon.X,
			variant = 0,
			size = 0,
			isCircular = true,
			LayoutOrder = 2,
			testId = 0
		}
		local variant

		if props.isOverMedia then
			variant = ButtonVariant.OverMedia
		else
			variant = ButtonVariant.Utility
		end

		v2.variant = variant
		v2.size = Small

		v2.testId = `{props.testId}--close`
		close = createElement2(IconButton, v2)
	end

	return createElement(View, v, { Overflow = overflow, Close = close })
end

return CardActions
