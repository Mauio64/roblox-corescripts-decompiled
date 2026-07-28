local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local StyledTextLabel = require(BulkPurchaseAppParent.UIBlox).App.Text.StyledTextLabel
local LineItemLayout = require(script.Parent.LineItemLayout)
local Price_DEPRECATED = require(script.Parent.Price_DEPRECATED)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)

local function PriceBoxLine_DEPRECATED(t1: {[any]: any}) -- line: 21
	-- upvalues: useDesignTokens (copy), PriceBoxLineVariantEnum (copy), React (copy), LineItemLayout (copy), StyledTextLabel (copy), Price_DEPRECATED (copy)
	local v11 = useDesignTokens()
	local v12 = if t1.variant ~= PriceBoxLineVariantEnum.Danger then v11.Typography.BodyLarge else {
		LineHeight = v11.Typography.BodyLarge.LineHeight,
		Font = v11.Typography.TitleLarge.Font,
		FontSize = v11.Typography.BodyLarge.FontSize,
		LetterSpacing = v11.Typography.BodyLarge.LetterSpacing
	}
	local Default = v11.Color.Content.Default

	if t1.variant == PriceBoxLineVariantEnum.Highlight then
		Default = v11.Color.Content.Emphasis
	elseif t1.variant == PriceBoxLineVariantEnum.Danger then
		Default = v11.Color.System.Alert
	end

	return React.createElement(LineItemLayout, {
		LayoutOrder = t1.LayoutOrder,
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = v12,
			colorStyle = Default,
			text = t1.text
		}),
		endSlot = React.createElement(Price_DEPRECATED, {
			colorStyle = Default,
			fontStyle = v12,
			amount = t1.amount
		})
	})
end

return PriceBoxLine_DEPRECATED
