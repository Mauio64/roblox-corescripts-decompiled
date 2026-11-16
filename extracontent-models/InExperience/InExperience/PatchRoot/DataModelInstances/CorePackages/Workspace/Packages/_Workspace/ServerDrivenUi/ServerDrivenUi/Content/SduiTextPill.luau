local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Style = require(parent.Style)
local Colors = Style.Colors
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local v3 = {
		[React.Tag] = "data-testid=--sdui-text-pill",
		BackgroundColor3 = backgroundColor3 or Colors.White,
		BackgroundTransparency = backgroundTransparency or 0,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v4 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, xSmall),
			PaddingLeft = UDim.new(0, small),
			PaddingBottom = UDim.new(0, xSmall),
			PaddingRight = UDim.new(0, small)
		}),
		TextLabel = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, v2),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = props.text,
		TextColor3 = textColor3 or v.LightMode.Content.Emphasis.Color3,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = false,
		TextTruncate = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = fontStyle.Font
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(fontStyle.Font)
	end

	v5.FontFace = fontFace
	v5.TextSize = fontStyle.FontSize
	v5.TextXAlignment = Enum.TextXAlignment.Center
	v5.TextYAlignment = Enum.TextYAlignment.Center

	v5.TextTruncate = Enum.TextTruncate.AtEnd
	v4.TextLabel = createElement2("TextLabel", v5)
	return createElement("Frame", v3, v4)
end

return React.memo(SduiTextPill)
