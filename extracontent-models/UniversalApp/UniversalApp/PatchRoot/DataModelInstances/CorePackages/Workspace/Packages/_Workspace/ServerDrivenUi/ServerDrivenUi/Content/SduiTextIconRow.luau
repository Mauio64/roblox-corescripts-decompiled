local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local UIBlox = require(Parent.UIBlox)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local checkAndFormatPossibleLink = require(Parent.CollectionViews).checkAndFormatPossibleLink
local TextSize = require(Parent.TextSize)
local t1 = {
	anchorPoint = "AnchorPoint",
	automaticSize = "AutomaticSize",
	backgroundColor3 = "BackgroundColor3",
	backgroundTransparency = "BackgroundTransparency",
	layoutOrder = "LayoutOrder",
	position = "Position",
	richText = "RichText",
	size = "Size",
	text = "Text",
	textTruncate = "TextTruncate",
	textWrapped = "TextWrapped",
	textXAlignment = "TextXAlignment",
	textYAlignment = "TextYAlignment",
	zIndex = "ZIndex"
}

local function applyOverrides(t2: {[any]: any}, t3: {[any]: any}?) -- line: 87
	-- upvalues: t1 (copy), Cryo (copy)
	if t3 == nil then
		return t2
	end

	local t4 = {}

	for v15, v16 in t3 do
		t4[t1[v15] or v15] = v16
	end

	return Cryo.Dictionary.join(t2, t4)
end
local function SduiTextIconRow(t5: {[any]: any}) -- line: 98
	-- upvalues: TextSize (copy), useTokens (copy), checkAndFormatPossibleLink (copy), React (copy), applyOverrides (copy), ImageSetLabel (copy)
	local layoutOrder = t5.layoutOrder
	local anchorPoint = t5.anchorPoint
	local automaticSize = t5.automaticSize
	local size = t5.size
	local zIndex = t5.zIndex
	local position = t5.position
	local selectable = t5.selectable
	local v25 = TextSize.getTextSizeStore(false).getTextSizeOffset(false)
	local v26 = useTokens()
	local v27 = t5.fontStyle or v26.Typography.HeadingSmall
	local v28 = t5.textColor or v26.Color.Content.Emphasis.Color3
	local v29 = math.ceil(v27.LineHeight * v27.FontSize + v25)
	local v30 = if not t5.iconWidth then UDim2.new(0, v29, 0, v29) else UDim2.new(0, t5.iconWidth, 0, t5.iconWidth)
	local v31 = t5.iconColor or v28
	local v32 = t5.onActivated ~= nil
	local v33, v34 = checkAndFormatPossibleLink(t5.text)

	return React.createElement(not v32 and "Frame" or "TextButton", {
		Position = position,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize,
		Size = size or UDim2.new(1, 0, 0, v29),
		BackgroundTransparency = t5.backgroundStyle and t5.backgroundStyle.Transparency or 1,
		BackgroundColor3 = t5.backgroundStyle and t5.backgroundStyle.Color3 or nil,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Text = if not v32 then nil else "",
		TextTransparency = if not v32 then nil else 1,
		AutoButtonColor = not v32 and nil,
		[React.Event.Activated] = if not v32 then nil else t5.onActivated,
		Active = v32,
		Selectable = selectable,
		[React.Tag] = if not t5.testId then not v32 and "data-testid=--sdui-text-icon-row" or "data-testid=--sdui-text-icon-row-button" else `data-testid={ t5.testId }`
	}, {
		UICorner = if not t5.cornerRadius then nil else React.createElement("UICorner", {
			CornerRadius = t5.cornerRadius
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, t5.gap or 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = React.createElement("TextLabel", applyOverrides({
			BackgroundTransparency = 1,
			Text = v34 or "",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = size or UDim2.new(0, 0, 0, v29),
			Font = v27.Font,
			TextSize = v27.FontSize,
			TextTransparency = 0,
			TextColor3 = v28,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = (not t5.iconFirst and 1 or -1) * 1,
			RichText = not not v33 or nil,
			[React.Tag] = "data-testid=--sdui-text-icon-row-text"
		}, t5.textOverrides), {
			UIFlexItem = if not t5.textFlexMode then nil else React.createElement("UIFlexItem", {
				FlexMode = t5.textFlexMode
			})
		}),
		Icon = if not t5.icon then nil else React.createElement(ImageSetLabel, applyOverrides({
			LayoutOrder = (not t5.iconFirst and 1 or -1) * 2,
			Size = v30,
			BackgroundTransparency = 1,
			ImageColor3 = v31,
			ImageTransparency = 0,
			Image = t5.icon,
			[React.Tag] = "data-testid=--sdui-text-icon-row-icon"
		}, t5.iconOverrides))
	})
end

return React.memo(SduiTextIconRow)
