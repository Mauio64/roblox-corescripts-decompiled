local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local Cryo = require(ParentParentParentParent.Cryo)
local Foundation = require(ParentParentParentParent.Foundation)

require(ParentParent.ImageSet.ImagesTypes)
require(ParentParent.Style.StyleTypes)

local Label = require(ParentParentParent.Core.ImageSet.ImageSetComponent).Label
local Skeleton = Foundation.Skeleton
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local UIBloxConfig = require(ParentParentParent.UIBloxConfig)
local OpenTypeSupport = require(ParentParentParent.Utility.OpenTypeSupport)

local function getStyleDefaults(p1) -- line: 81
	return {
		iconLabelSpacing = p1.Global.Space_25,
		iconSize = p1.Semantic.Icon.Size.Small,
		iconColorStyle = p1.Semantic.Color.Icon.Default,
		labelTypography = p1.Semantic.Typography.CaptionHeader,
		labelColorStyle = p1.Semantic.Color.Text.Default
	}
end
local function getDisplayNameStyleDefaults(p2) -- line: 91
	return {
		iconLabelSpacing = p2.Global.Space_25,
		iconSize = p2.Semantic.Icon.Size.Small,
		labelTypography = p2.Semantic.Typography.Subheader,
		labelColorStyle = p2.Semantic.Color.Text.Emphasis
	}
end
local function getUserNameStyleDefaults(p3) -- line: 100
	return {
		iconLabelSpacing = p3.Global.Space_25,
		iconSize = p3.Global.Size_150,
		iconColorStyle = p3.Semantic.Color.Icon.Default,
		labelTypography = p3.Semantic.Typography.CaptionHeader,
		labelColorStyle = p3.Semantic.Color.Text.Default
	}
end
local function NameItem(t1: {[any]: any}) -- line: 110
	-- upvalues: Cryo (copy), React (copy), Label (copy), Skeleton (copy), UIBloxConfig (copy)
	local layoutOrder = t1.layoutOrder
	local isReversed = t1.isReversed
	local itemProps = t1.itemProps
	local itemStyleDefaults = t1.itemStyleDefaults
	local icon = itemProps.icon
	local labelText = itemProps.labelText
	local useTextAsIcon = itemProps.useTextAsIcon
	local onActivated = itemProps.onActivated
	local v29 = itemProps.isLoading ~= nil and itemProps.isLoading
	local v30 = Cryo.Dictionary.join(itemStyleDefaults, itemProps.styleProps or {})
	local iconLabelSpacing = v30.iconLabelSpacing
	local iconSize = v30.iconSize
	local v33 = v30.iconColorStyle or {}
	local labelTypography = v30.labelTypography
	local labelColorStyle = v30.labelColorStyle
	local v36 = not v29 and not not icon
	local v37 = not v29 and not not onActivated
	local v38 = nil

	if v29 then
		v38 = if not icon then labelTypography.FontSize else math.max(iconSize, labelTypography.FontSize)
	end

	local v39 = nil

	if v36 then
		v39 = if not useTextAsIcon then React.createElement(Label, {
			BackgroundTransparency = 1,
			Selectable = false,
			LayoutOrder = not isReversed and 1 or 2,
			Size = UDim2.fromOffset(iconSize, iconSize),
			Image = icon,
			ImageColor3 = v33.Color3,
			ImageTransparency = not v33.Transparency and 0 or v33.Transparency
		}) else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Selectable = false,
			LayoutOrder = not isReversed and 1 or 2,
			Size = UDim2.fromOffset(iconSize, iconSize),
			Text = icon,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Font = labelTypography.Font,
			TextSize = iconSize,
			TextColor3 = v33.Color3,
			TextTransparency = not v33.Transparency and 0 or v33.Transparency
		})
	end

	return React.createElement(not v37 and "Frame" or "TextButton", {
		Text = if not v37 then nil else "",
		AutoButtonColor = not v37 and nil,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Selectable = not not v37,
		[React.Event.Activated] = if not v37 then nil else onActivated
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, iconLabelSpacing)
		}),
		Shimmer = if not v29 then nil else React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v38)
		}),
		Icon = v39,
		Label = if v29 then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Selectable = false,
			LayoutOrder = not isReversed and 2 or 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(0, 0),
			Text = labelText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Font = labelTypography.Font,
			TextSize = labelTypography.FontSize,
			TextColor3 = labelColorStyle.Color3,
			TextTransparency = labelColorStyle.Transparency,
			OpenTypeFeatures = if not UIBloxConfig.enableOpenTypeSupport or not t1.openTypeFeatures then nil else t1.openTypeFeatures
		})
	})
end
local function PlayerName(t2: {[any]: any}) -- line: 215
	-- upvalues: useStyle (copy), React (copy), NameItem (copy), UIBloxConfig (copy), OpenTypeSupport (copy), getUserNameStyleDefaults (copy), getStyleDefaults (copy)
	local v41 = useStyle()
	local position = t2.position
	local anchorPoint = t2.anchorPoint
	local size = t2.size
	local v45 = t2.automaticSize or Enum.AutomaticSize.Y
	local layoutOrder = t2.layoutOrder
	local v47 = t2.namesSpacing or v41.Tokens.Global.Space_50
	local displayNameItem = t2.displayNameItem
	local userNameItem = t2.userNameItem
	local vendorNameItem = t2.vendorNameItem
	local aliasItem = t2.aliasItem
	local createElement = React.createElement
	local t3 = {
		BackgroundTransparency = 1,
		Selectable = false,
		Position = position,
		AnchorPoint = anchorPoint,
		Size = size,
		AutomaticSize = v45,
		LayoutOrder = layoutOrder
	}
	local t4 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v47)
		})
	}
	local v59

	if displayNameItem then
		local createElement2 = React.createElement
		local v56 = NameItem
		local t5 = {
			layoutOrder = 1,
			isReversed = true,
			itemProps = displayNameItem
		}
		local Tokens = v41.Tokens

		t5.itemStyleDefaults = {
			iconLabelSpacing = Tokens.Global.Space_25,
			iconSize = Tokens.Semantic.Icon.Size.Small,
			labelTypography = Tokens.Semantic.Typography.Subheader,
			labelColorStyle = Tokens.Semantic.Color.Text.Emphasis
		}
		v59 = createElement2(v56, t5)
	else
		v59 = nil
	end

	t4.DisplayName = v59
	t4.UserName = if not userNameItem then nil else React.createElement(NameItem, {
		layoutOrder = 2,
		itemProps = userNameItem,
		openTypeFeatures = if not UIBloxConfig.enableOpenTypeSupport then nil else OpenTypeSupport:getUserNameStylisticAlternative(),
		itemStyleDefaults = getUserNameStyleDefaults(v41.Tokens)
	})
	t4.VendorName = if not vendorNameItem then nil else React.createElement(NameItem, {
		layoutOrder = 3,
		itemProps = vendorNameItem,
		itemStyleDefaults = getStyleDefaults(v41.Tokens)
	})
	t4.Alias = if not aliasItem then nil else React.createElement(NameItem, {
		layoutOrder = 4,
		itemProps = aliasItem,
		itemStyleDefaults = getStyleDefaults(v41.Tokens)
	})

	return createElement("Frame", t3, t4)
end

return PlayerName
