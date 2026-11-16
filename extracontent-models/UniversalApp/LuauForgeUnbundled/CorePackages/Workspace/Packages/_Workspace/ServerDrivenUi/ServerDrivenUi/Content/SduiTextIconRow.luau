local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local checkAndFormatPossibleLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").checkAndFormatPossibleLink
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TextSize")

local v5 = {
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

local function applyOverrides(p2, items)
	if items == nil then
		return p2
	end

	local v6 = {}

	for k, item in items do
		v6[v5[k] or k] = item
	end

	return Cryo.Dictionary.join(p2, v6)
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

	local v6 = useTokens()

	local fontStyle = props.fontStyle or v6.Typography.HeadingSmall
	local textColor = props.textColor or v6.Color.Content.Emphasis.Color3
	local v7 = math.ceil(fontStyle.LineHeight * fontStyle.FontSize + textSizeOffset)
	local udim

	if props.iconWidth then
		udim = UDim2.new(0, props.iconWidth, 0, props.iconWidth)
	else
		udim = UDim2.new(0, v7, 0, v7)
	end

	local iconColor = props.iconColor or textColor

	local v8 = props.onActivated ~= nil

	local v9, v10 = checkAndFormatPossibleLink(props.text)

	local createElement = React.createElement
	local v12 = {}
	v12.Position = position
	v12.AnchorPoint = anchorPoint
	v12.AutomaticSize = automaticSize
	v12.Size = size or UDim2.new(1, 0, 0, v7)
	v12.BackgroundTransparency = props.backgroundStyle and props.backgroundStyle.Transparency or 1
	local v13 = if props.backgroundStyle then props.backgroundStyle.Color3 or nil else nil
	v12.BackgroundColor3 = v13
	v12.BorderSizePixel = 0
	v12.LayoutOrder = layoutOrder
	v12.ZIndex = zIndex

	v12.Text = v8 and "" or nil
	v12.TextTransparency = v8 and 1 or nil
	v12.AutoButtonColor = if v8 then false else nil
	local activated = React.Event.Activated
	local v15 = if v8 then props.onActivated else nil
	v12[activated] = v15
	v12.Active = v8
	v12.Selectable = selectable
	v12[React.Tag] = not props.testId
		and (v8 and "data-testid=--sdui-text-icon-row-button" or "data-testid=--sdui-text-icon-row")
		or `data-testid={props.testId}`

	local v16 = if props.cornerRadius then React.createElement("UICorner", {
		CornerRadius = props.cornerRadius
	}) else nil
	local children = {
		UICorner = v16,
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

	local v19 = {}
	v19.BackgroundTransparency = 1
	v19.Text = v10 or ""
	v19.AutomaticSize = Enum.AutomaticSize.X
	v19.Size = size or UDim2.new(0, 0, 0, v7)
	local v20 = if not foundationFontFaceMigration then fontStyle.Font else nil
	v19.Font = v20
	local v21 = if foundationFontFaceMigration then normalizeFontFace(fontStyle.Font) else nil
	v19.FontFace = v21
	v19.TextSize = fontStyle.FontSize
	v19.TextTransparency = 0
	v19.TextColor3 = textColor
	v19.TextWrapped = false
	v19.TextTruncate = Enum.TextTruncate.SplitWord
	v19.TextXAlignment = Enum.TextXAlignment.Left
	v19.LayoutOrder = (props.iconFirst and -1 or 1) * 1
	v19.RichText = v9 and true or nil
	v19[React.Tag] = "data-testid=--sdui-text-icon-row-text"
	local v22 = applyOverrides(v19, props.textOverrides)

	local v24 = if props.textFlexMode then React.createElement("UIFlexItem", {
		FlexMode = props.textFlexMode
	}) else nil
	children.Text = createElement2("TextLabel", v22, { UIFlexItem = v24 })
	local v25

	if props.icon then
		v25 = React.createElement(imageSetLabel, applyOverrides({
			LayoutOrder = (props.iconFirst and -1 or 1) * 2,
			Size = udim,
			BackgroundTransparency = 1,
			ImageColor3 = iconColor,
			ImageTransparency = 0,
			Image = props.icon,
			[React.Tag] = "data-testid=--sdui-text-icon-row-icon"
		}, props.iconOverrides))
	end

	children.Icon = v25
	return createElement(v8 and "TextButton" or "Frame", v12, children)
end

return React.memo(SduiTextIconRow)
