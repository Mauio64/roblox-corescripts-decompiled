local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Style = require(parent.Style)
local Colors = Style.Colors
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local function SduiTextPill(props)
	if not props.text or props.text == "" then
		return nil
	end

	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local position = props.position
	local zIndex = props.zIndex
	local backgroundColor3 = props.backgroundColor3
	local backgroundTransparency = props.backgroundTransparency
	local textColor3 = props.textColor3

	local v = useTokens()
	local small = v.Padding.Small
	local xSmall = v.Padding.XSmall
	local fontStyle = props.fontStyle or v.Typography.LabelSmall
	local v2 = fontStyle.FontSize * fontStyle.LineHeight

	return React.createElement("Frame", {
		[React.Tag] = "data-testid=--sdui-text-pill",
		BackgroundColor3 = backgroundColor3 or Colors.White,
		BackgroundTransparency = backgroundTransparency or 0,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, xSmall),
			PaddingLeft = UDim.new(0, small),
			PaddingBottom = UDim.new(0, xSmall),
			PaddingRight = UDim.new(0, small)
		}),
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, v2),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = props.text,
			TextColor3 = textColor3 or v.LightMode.Content.Emphasis.Color3,
			FontFace = normalizeFontFace(fontStyle.Font),
			TextSize = fontStyle.FontSize,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return React.memo(SduiTextPill)
