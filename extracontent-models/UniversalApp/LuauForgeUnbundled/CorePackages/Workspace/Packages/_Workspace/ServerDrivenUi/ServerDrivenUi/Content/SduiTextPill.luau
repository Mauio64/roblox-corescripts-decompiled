local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Style").Colors
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local v5 = useTokens()
	local small = v5.Padding.Small
	local xSmall = v5.Padding.XSmall
	local fontStyle = props.fontStyle or v5.Typography.LabelSmall
	local v6 = fontStyle.FontSize * fontStyle.LineHeight

	local createElement = React.createElement
	local v8 = {
		[React.Tag] = "data-testid=--sdui-text-pill",
		BackgroundColor3 = backgroundColor3 or colors.White,
		BackgroundTransparency = backgroundTransparency or 0,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v9 = {
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
	local v11 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, v6),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = props.text,
		TextColor3 = textColor3 or v5.LightMode.Content.Emphasis.Color3,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = false,
		TextTruncate = 0
	}
	local v12 = if not foundationFontFaceMigration then fontStyle.Font else nil
	v11.Font = v12
	local v13 = if foundationFontFaceMigration then normalizeFontFace(fontStyle.Font) else nil
	v11.FontFace = v13
	v11.TextSize = fontStyle.FontSize
	v11.TextXAlignment = Enum.TextXAlignment.Center
	v11.TextYAlignment = Enum.TextYAlignment.Center

	v11.TextTruncate = Enum.TextTruncate.AtEnd
	v9.TextLabel = createElement2("TextLabel", v11)
	return createElement("Frame", v8, v9)
end

return React.memo(SduiTextPill)
