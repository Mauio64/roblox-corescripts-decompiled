local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local LineItemLayout = require(script.Parent.LineItemLayout)

local function ItemListHeader(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), LineItemLayout (copy), StyledTextLabel (copy)
	local v10 = useDesignTokens()
	local t2 = {
		LineHeight = if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Typography.Body.LineHeight else v10.Typography.BodyLarge.LineHeight,
		Font = if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Typography.Subheader.Font else v10.Typography.TitleLarge.Font,
		FontSize = if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Typography.Body.FontSize else v10.Typography.BodyLarge.FontSize,
		LetterSpacing = if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Typography.Body.LetterSpacing else v10.Typography.BodyLarge.LetterSpacing
	}
	local v12 = if not FFlagRenameDeprecatedUIBloxTokens then v10.Semantic.Color.Text.Emphasis else v10.Color.Content.Emphasis

	return React.createElement(LineItemLayout, {
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = t2,
			colorStyle = v12,
			text = t1.heading
		}),
		endSlot = React.createElement(StyledTextLabel, {
			fontStyle = t2,
			colorStyle = v12,
			text = t1.itemCount
		}),
		LayoutOrder = t1.LayoutOrder
	})
end

return ItemListHeader
