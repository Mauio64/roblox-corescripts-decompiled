local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local PriceBoxLineLayout = require(script.Parent.PriceBoxLineLayout)
local Price = require(script.Parent.Price)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)

local function PriceBoxLine(props)
	local v = useTokens()
	local fontStyle = {
		LineHeight = v.Typography.BodyLarge.LineHeight,
		FontSize = v.Typography.BodyLarge.FontSize,
		Font = 0
	}
	local font

	if props.variant == PriceBoxLineVariantEnum.Danger then
		font = v.Typography.TitleLarge.Font
	else
		font = v.Typography.BodyLarge.Font
	end

	fontStyle.Font = font

	local textStyle = v.Color.Content.Default

	if props.variant == PriceBoxLineVariantEnum.Highlight then
		textStyle = v.Color.Content.Emphasis
	elseif props.variant == PriceBoxLineVariantEnum.Danger then
		textStyle = v.Color.System.Alert
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		startSlot = React.createElement(Text, {
			fontStyle = fontStyle,
			textStyle = textStyle,
			Text = props.text,
			tag = "auto-xy"
		}),
		endSlot = 0
	}
	local endSlot

	if props.originalPrice then
		endSlot = React.createElement(View, { tag = "row align-y-center gap-small auto-xy" }, {
			OriginalPrice = React.createElement(Price, {
				textStyle = textStyle,
				fontStyle = fontStyle,
				amount = props.originalPrice,
				strikethrough = true,
				LayoutOrder = 1
			}),
			CurrentPrice = React.createElement(Price, {
				textStyle = textStyle,
				fontStyle = fontStyle,
				amount = props.amount,
				LayoutOrder = 2
			})
		})
	else
		endSlot = React.createElement(Price, {
			textStyle = textStyle,
			fontStyle = fontStyle,
			amount = props.amount
		})
	end

	v2.endSlot = endSlot
	return createElement(PriceBoxLineLayout, v2)
end

return PriceBoxLine
