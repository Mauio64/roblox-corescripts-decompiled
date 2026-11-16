local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local LineItemLayout = require(script.Parent.LineItemLayout)
local Price_DEPRECATED = require(script.Parent.Price_DEPRECATED)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)

local function PriceBoxLine_DEPRECATED(props)
	local v = useDesignTokens()
	local fontStyle

	if props.variant == PriceBoxLineVariantEnum.Danger then
		fontStyle = {
			LineHeight = v.Typography.BodyLarge.LineHeight,
			Font = v.Typography.TitleLarge.Font,
			FontSize = v.Typography.BodyLarge.FontSize,
			LetterSpacing = v.Typography.BodyLarge.LetterSpacing
		}
	else
		fontStyle = v.Typography.BodyLarge
	end

	local colorStyle = v.Color.Content.Default

	if props.variant == PriceBoxLineVariantEnum.Highlight then
		colorStyle = v.Color.Content.Emphasis
	elseif props.variant == PriceBoxLineVariantEnum.Danger then
		colorStyle = v.Color.System.Alert
	end

	return React.createElement(LineItemLayout, {
		LayoutOrder = props.LayoutOrder,
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = fontStyle,
			colorStyle = colorStyle,
			text = props.text
		}),
		endSlot = React.createElement(Price_DEPRECATED, {
			colorStyle = colorStyle,
			fontStyle = fontStyle,
			amount = props.amount
		})
	})
end

return PriceBoxLine_DEPRECATED
