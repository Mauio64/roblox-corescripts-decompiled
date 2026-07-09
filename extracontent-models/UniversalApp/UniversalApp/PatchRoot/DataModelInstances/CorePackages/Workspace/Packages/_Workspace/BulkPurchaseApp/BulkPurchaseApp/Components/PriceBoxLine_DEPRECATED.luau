local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local LineItemLayout = require(script.Parent.LineItemLayout)
local Price_DEPRECATED = require(script.Parent.Price_DEPRECATED)
local PriceBoxLineVariantEnum = require(BulkPurchaseApp.Enums.PriceBoxLineVariantEnum)

local function PriceBoxLine_DEPRECATED(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), PriceBoxLineVariantEnum (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), LineItemLayout (copy), StyledTextLabel (copy), Price_DEPRECATED (copy)
	local v13 = useDesignTokens()
	local v14 = if t1.variant ~= PriceBoxLineVariantEnum.Danger then if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Typography.Body else v13.Typography.BodyLarge else {
		LineHeight = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Typography.Body.LineHeight else v13.Typography.BodyLarge.LineHeight,
		Font = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Typography.Subheader.Font else v13.Typography.TitleLarge.Font,
		FontSize = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Typography.Body.FontSize else v13.Typography.BodyLarge.FontSize,
		LetterSpacing = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Typography.Body.LetterSpacing else v13.Typography.BodyLarge.LetterSpacing
	}
	local v15 = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Color.Text.Default else v13.Color.Content.Default

	if t1.variant == PriceBoxLineVariantEnum.Highlight then
		v15 = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Color.Text.Emphasis else v13.Color.Content.Emphasis
	elseif t1.variant == PriceBoxLineVariantEnum.Danger then
		v15 = if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Color.Common.Alert else v13.Color.System.Alert
	end

	return React.createElement(LineItemLayout, {
		LayoutOrder = t1.LayoutOrder,
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = v14,
			colorStyle = v15,
			text = t1.text
		}),
		endSlot = React.createElement(Price_DEPRECATED, {
			colorStyle = v15,
			fontStyle = v14,
			amount = t1.amount
		})
	})
end

return PriceBoxLine_DEPRECATED
