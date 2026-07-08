local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Colors = require(Parent.Style).Colors
local useTokens = Foundation.Hooks.useTokens

local function SduiTextPill(t1: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), React (copy), Colors (copy)
	if not t1.text or t1.text == "" then
		return nil
	end

	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint
	local position = t1.position
	local zIndex = t1.zIndex
	local backgroundColor3 = t1.backgroundColor3
	local backgroundTransparency = t1.backgroundTransparency
	local textColor3 = t1.textColor3
	local v15 = useTokens()
	local Small = v15.Padding.Small
	local XSmall = v15.Padding.XSmall
	local v18 = t1.fontStyle or v15.Typography.LabelSmall
	local v19 = v18.FontSize * v18.LineHeight

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
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, XSmall),
			PaddingLeft = UDim.new(0, Small),
			PaddingBottom = UDim.new(0, XSmall),
			PaddingRight = UDim.new(0, Small)
		}),
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			Size = UDim2.new(0, 0, 0, v19),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = t1.text,
			TextColor3 = textColor3 or v15.LightMode.Content.Emphasis.Color3,
			Font = v18.Font,
			TextSize = v18.FontSize,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return React.memo(SduiTextPill)
