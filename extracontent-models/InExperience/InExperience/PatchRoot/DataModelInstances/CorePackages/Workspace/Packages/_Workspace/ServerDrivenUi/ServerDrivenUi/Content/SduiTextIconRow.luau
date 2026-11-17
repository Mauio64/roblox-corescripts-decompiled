local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local CollectionViews = require(parent.CollectionViews)
local checkAndFormatPossibleLink = CollectionViews.checkAndFormatPossibleLink
local TextSize = require(parent.TextSize)

local v = {
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

local function applyOverrides(p, items)
	if items == nil then
		return p
	end

	local v2 = {}

	for k, item in items do
		v2[v[k] or k] = item
	end

	return Cryo.Dictionary.join(p, v2)
end

local function SduiTextIconRow(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position
	local selectable = props.selectable

	local textSizeOffset = TextSize.getTextSizeStore(false).getTextSizeOffset(false)

	local v2 = useTokens()

	local fontStyle = props.fontStyle or v2.Typography.HeadingSmall
	local textColor = props.textColor or v2.Color.Content.Emphasis.Color3
	local v3 = math.ceil(fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset)
	local udim

	if props.iconWidth then
		udim = UDim2.new(0, props.iconWidth, 0, props.iconWidth)
	else
		udim = UDim2.new(0, v3, 0, v3)
	end

	local iconColor = props.iconColor or textColor

	local active = props.onActivated ~= nil

	local v4, v5 = checkAndFormatPossibleLink(props.text)

	local createElement = React.createElement
	local v6 = {}
	v6.Position = position
	v6.AnchorPoint = anchorPoint
	v6.AutomaticSize = automaticSize
	v6.Size = size or UDim2.new(1, 0, 0, v3)
	v6.BackgroundTransparency = props.backgroundStyle and props.backgroundStyle.Transparency or 1
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3 or nil
	end

	v6.BackgroundColor3 = backgroundColor
	v6.BorderSizePixel = 0
	v6.LayoutOrder = layoutOrder
	v6.ZIndex = zIndex

	v6.Text = active and "" or nil
	v6.TextTransparency = active and 1 or nil
	v6.AutoButtonColor = not active and nil
	local activated = React.Event.Activated
	local v7

	if active then
		v7 = props.onActivated
	end

	v6[activated] = v7
	v6.Active = active
	v6.Selectable = selectable
	v6[React.Tag] = not props.testId
		and (active and "data-testid=--sdui-text-icon-row-button" or "data-testid=--sdui-text-icon-row")
		or `data-testid={props.testId}`
	local uiCorner

	if props.cornerRadius then
		uiCorner = React.createElement("UICorner", { CornerRadius = props.cornerRadius })
	end

	local children = {
		UICorner = uiCorner,
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, props.gap or 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = 0,
		Icon = 0
	}

	local createElement2 = React.createElement

	local v8 = applyOverrides({
		BackgroundTransparency = 1,
		Text = v5 or "",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = size or UDim2.new(0, 0, 0, v3),
		FontFace = normalizeFontFace(fontStyle.Font),
		TextSize = fontStyle.FontSize,
		TextTransparency = 0,
		TextColor3 = textColor,
		TextWrapped = false,
		TextTruncate = Enum.TextTruncate.SplitWord,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = (props.iconFirst and -1 or 1) * 1,
		RichText = v4 and true or nil,
		[React.Tag] = "data-testid=--sdui-text-icon-row-text"
	}, props.textOverrides)
	local uiFlexItem

	if props.textFlexMode then
		uiFlexItem = React.createElement("UIFlexItem", { FlexMode = props.textFlexMode })
	end

	children.Text = createElement2("TextLabel", v8, { UIFlexItem = uiFlexItem })
	local icon

	if props.icon then
		icon = React.createElement(ImageSetLabel, applyOverrides({
			LayoutOrder = (props.iconFirst and -1 or 1) * 2,
			Size = udim,
			BackgroundTransparency = 1,
			ImageColor3 = iconColor,
			ImageTransparency = 0,
			Image = props.icon,
			[React.Tag] = "data-testid=--sdui-text-icon-row-icon"
		}, props.iconOverrides))
	end

	children.Icon = icon
	return createElement(active and "TextButton" or "Frame", v6, children)
end

return React.memo(SduiTextIconRow)
