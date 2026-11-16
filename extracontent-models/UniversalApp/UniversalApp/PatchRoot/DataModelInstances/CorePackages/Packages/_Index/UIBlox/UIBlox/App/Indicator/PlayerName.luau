local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local Cryo = require(parent3.Cryo)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

require(parent.ImageSet.ImagesTypes)
require(parent.Style.StyleTypes)

local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local Skeleton = Foundation.Skeleton

local useStyle = require(parent2.Core.Style.useStyle)

local UIBloxConfig = require(parent2.UIBloxConfig)
local OpenTypeSupport = require(parent2.Utility.OpenTypeSupport)

local function getStyleDefaults(tokens) -- 2 equivalent calls inferred from this helper
	return {
		iconLabelSpacing = tokens.Size.Size_50,
		iconSize = tokens.Size.Size_400,
		iconColorStyle = tokens.Color.Content.Default,
		labelTypography = tokens.Typography.CaptionMedium,
		labelColorStyle = tokens.Color.Content.Default
	}
end

local function getDisplayNameStyleDefaults(tokens) -- 1 equivalent call inferred from this helper
	return {
		iconLabelSpacing = tokens.Size.Size_50,
		iconSize = tokens.Size.Size_400,
		labelTypography = tokens.Typography.TitleLarge,
		labelColorStyle = tokens.Color.Content.Emphasis
	}
end

local function getUserNameStyleDefaults(tokens) -- 1 equivalent call inferred from this helper
	return {
		iconLabelSpacing = tokens.Size.Size_50,
		iconSize = tokens.Size.Size_300,
		iconColorStyle = tokens.Color.Content.Default,
		labelTypography = tokens.Typography.CaptionMedium,
		labelColorStyle = tokens.Color.Content.Default
	}
end

local function NameItem(props)
	local layoutOrder = props.layoutOrder
	local isReversed = props.isReversed
	local itemProps = props.itemProps
	local itemStyleDefaults = props.itemStyleDefaults

	local icon = itemProps.icon
	local labelText = itemProps.labelText
	local useTextAsIcon = itemProps.useTextAsIcon
	local onActivated = itemProps.onActivated
	local v = not (itemProps.isLoading == nil) and itemProps.isLoading

	local joined = Cryo.Dictionary.join(itemStyleDefaults, itemProps.styleProps or {})
	local iconLabelSpacing = joined.iconLabelSpacing
	local iconSize = joined.iconSize
	local iconColorStyle = joined.iconColorStyle or {}
	local labelTypography = joined.labelTypography
	local labelColorStyle = joined.labelColorStyle
	local v2 = not v and onActivated and true or false
	local v3

	if v then
		if icon then
			v3 = math.max(iconSize, labelTypography.FontSize)
		else
			v3 = labelTypography.FontSize
		end
	end

	local icon2

	if not v and icon then
		if useTextAsIcon then
			icon2 = React.createElement("TextLabel", {
				LayoutOrder = isReversed and 2 or 1,
				Size = UDim2.fromOffset(iconSize, iconSize),
				BackgroundTransparency = 1,
				Text = icon,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				FontFace = normalizeFontFace(labelTypography.Font),
				TextSize = iconSize,
				TextColor3 = iconColorStyle.Color3,
				TextTransparency = not iconColorStyle.Transparency and 0 or iconColorStyle.Transparency,
				Selectable = false
			})
		else
			icon2 = React.createElement(Label, {
				LayoutOrder = isReversed and 2 or 1,
				Size = UDim2.fromOffset(iconSize, iconSize),
				Image = icon,
				ImageColor3 = iconColorStyle.Color3,
				ImageTransparency = not iconColorStyle.Transparency and 0 or iconColorStyle.Transparency,
				BackgroundTransparency = 1,
				Selectable = false
			})
		end
	end

	local createElement = React.createElement
	local onActivatedsByActivated = {
		["Text"] = v2 and "" or nil,
		AutoButtonColor = not v2 and nil,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Selectable = v2 and true or false
	}

	local activated = React.Event.Activated

	if not v2 then
		onActivated = nil
	end

	onActivatedsByActivated[activated] = onActivated
	local v4 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, iconLabelSpacing)
		}),
		Shimmer = 0,
		Icon = 0,
		Label = 0
	}
	local shimmer

	if v then
		shimmer = React.createElement(Skeleton, { Size = UDim2.new(1, 0, 0, v3) })
	end

	v4.Shimmer = shimmer

	v4.Icon = icon2
	local label

	if not v then
		local createElement2 = React.createElement
		local v5 = {
			LayoutOrder = isReversed and 1 or 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Text = labelText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			FontFace = normalizeFontFace(labelTypography.Font),
			TextSize = labelTypography.FontSize,
			TextColor3 = labelColorStyle.Color3,
			TextTransparency = labelColorStyle.Transparency,
			Selectable = false,
			OpenTypeFeatures = 0
		}
		local openTypeFeatures

		if UIBloxConfig.enableOpenTypeSupport and props.openTypeFeatures then
			openTypeFeatures = props.openTypeFeatures
		end

		v5.OpenTypeFeatures = openTypeFeatures
		label = createElement2("TextLabel", v5)
	end

	v4.Label = label
	return createElement(v2 and "TextButton" or "Frame", onActivatedsByActivated, v4)
end

local function PlayerName(props)
	local v = useStyle()
	local position = props.position
	local anchorPoint = props.anchorPoint
	local size = props.size
	local automaticSize = props.automaticSize or Enum.AutomaticSize.Y
	local layoutOrder = props.layoutOrder

	local namesSpacing = props.namesSpacing or v.Tokens.Size.Size_100
	local displayNameItem = props.displayNameItem
	local userNameItem = props.userNameItem
	local vendorNameItem = props.vendorNameItem
	local aliasItem = props.aliasItem

	local createElement = React.createElement

	local v2 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, namesSpacing)
		}),
		DisplayName = 0,
		UserName = 0,
		VendorName = 0,
		Alias = 0
	}
	local displayName

	if displayNameItem then
		displayName = React.createElement(NameItem, {
			layoutOrder = 1,
			isReversed = true,
			itemProps = displayNameItem,
			itemStyleDefaults = getDisplayNameStyleDefaults(v.Tokens) -- inferred equivalent call
		})
	end

	v2.DisplayName = displayName
	local userName

	if userNameItem then
		local createElement2 = React.createElement
		local openTypeFeatures

		if UIBloxConfig.enableOpenTypeSupport then
			openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
		end

		userName = createElement2(NameItem, {
			layoutOrder = 2,
			itemProps = userNameItem,
			openTypeFeatures = openTypeFeatures,
			itemStyleDefaults = getUserNameStyleDefaults(v.Tokens) -- inferred equivalent call
		})
	end

	v2.UserName = userName
	local vendorName

	if vendorNameItem then
		vendorName = React.createElement(NameItem, {
			layoutOrder = 3,
			itemProps = vendorNameItem,
			itemStyleDefaults = getStyleDefaults(v.Tokens) -- inferred equivalent call
		})
	end

	v2.VendorName = vendorName
	local alias

	if aliasItem then
		alias = React.createElement(NameItem, {
			layoutOrder = 4,
			itemProps = aliasItem,
			itemStyleDefaults = getStyleDefaults(v.Tokens) -- inferred equivalent call
		})
	end

	v2.Alias = alias
	return createElement("Frame", {
		Position = position,
		AnchorPoint = anchorPoint,
		Size = size,
		AutomaticSize = automaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Selectable = false
	}, v2)
end

return PlayerName
