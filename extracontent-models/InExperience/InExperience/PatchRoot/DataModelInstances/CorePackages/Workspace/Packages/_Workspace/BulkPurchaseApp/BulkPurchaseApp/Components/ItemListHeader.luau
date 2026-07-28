local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local StyledTextLabel = require(Parent.UIBlox).App.Text.StyledTextLabel
local LineItemLayout = require(script.Parent.LineItemLayout)

local function ItemListHeader(t1: {[any]: any}) -- line: 17
	-- upvalues: useDesignTokens (copy), React (copy), LineItemLayout (copy), StyledTextLabel (copy)
	local v8 = useDesignTokens()
	local t2 = {
		LineHeight = v8.Typography.BodyLarge.LineHeight,
		Font = v8.Typography.TitleLarge.Font,
		FontSize = v8.Typography.BodyLarge.FontSize,
		LetterSpacing = v8.Typography.BodyLarge.LetterSpacing
	}
	local Emphasis = v8.Color.Content.Emphasis

	return React.createElement(LineItemLayout, {
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = t2,
			colorStyle = Emphasis,
			text = t1.heading
		}),
		endSlot = React.createElement(StyledTextLabel, {
			fontStyle = t2,
			colorStyle = Emphasis,
			text = t1.itemCount
		}),
		LayoutOrder = t1.LayoutOrder
	})
end

return ItemListHeader
