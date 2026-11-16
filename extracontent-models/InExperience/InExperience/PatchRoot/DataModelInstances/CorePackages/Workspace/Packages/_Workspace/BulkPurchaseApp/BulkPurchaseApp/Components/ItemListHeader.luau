local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local LineItemLayout = require(script.Parent.LineItemLayout)

local function ItemListHeader(props)
	local v = useDesignTokens()
	local fontStyle = {
		LineHeight = v.Typography.BodyLarge.LineHeight,
		Font = v.Typography.TitleLarge.Font,
		FontSize = v.Typography.BodyLarge.FontSize,
		LetterSpacing = v.Typography.BodyLarge.LetterSpacing
	}

	local emphasis = v.Color.Content.Emphasis

	return React.createElement(LineItemLayout, {
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = fontStyle,
			colorStyle = emphasis,
			text = props.heading
		}),
		endSlot = React.createElement(StyledTextLabel, {
			fontStyle = fontStyle,
			colorStyle = emphasis,
			text = props.itemCount
		}),
		LayoutOrder = props.LayoutOrder
	})
end

return ItemListHeader
