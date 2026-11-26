local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local text = Foundation.Text
local icon = Foundation.Icon
local badge = Foundation.Badge
local iconSize = Foundation.Enums.IconSize
local badgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens

local getLocalizedPrice = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/Utils/getLocalizedPrice")

local fFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter

local function renderIconTextPair(props)
	local children = {}

	if props.iconName then
		children[props.iconKey] = React.createElement(icon, {
			name = props.iconName,
			style = props.resolvedColorStyle,
			size = iconSize.Small,
			LayoutOrder = props.iconLayoutOrder,
			testId = props.iconKey
		})
	end

	children[props.textKey] = React.createElement(text, {
		textStyle = props.resolvedColorStyle,
		fontStyle = props.tokens.Typography.BodyMedium,
		LayoutOrder = props.textLayoutOrder,
		Text = props.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTruncate = Enum.TextTruncate.SplitWord
	})

	return children
end

local function renderContentChildren(content, p2, textLayoutOrder, p3, resolvedColorStyle, tokens, designTokens)
	local v5 = nil
	local v6, v7, v8

	if content.type == "price" then
		v6 = getLocalizedPrice(content.price)
		v5 = "robux"
		v7 = "RobuxIcon"
		v8 = "Amount"
	elseif content.type == "timedOption" then
		v5 = content.icon
		v6 = content.text
		v7 = "TimedOptionIcon"
		v8 = "TimedOptionText"
	else
		if content.type ~= "text" then
			return {}
		end

		v6 = content.text
		v7 = "Text"
		v8 = "Text"
	end

	local v10 = {
		iconName = v5,
		text = v6,
		iconKey = `{p2}{v7}`,
		textKey = `{p2}{v8}`,
		iconLayoutOrder = textLayoutOrder,
		textLayoutOrder = 0,
		resolvedColorStyle = 0,
		tokens = 0,
		designTokens = 0
	}

	if v5 then
		textLayoutOrder = p3
	end

	v10.textLayoutOrder = textLayoutOrder
	v10.resolvedColorStyle = resolvedColorStyle
	v10.tokens = tokens
	v10.designTokens = designTokens
	return renderIconTextPair(v10)
end

local function ItemCardPriceLine(p2)
	local v5 = useTokens()
	local v6 = useDesignTokens()

	if p2.content.type == "badge" then
		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = p2.LayoutOrder
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v5.Padding.XSmall)
				}),
				Badge = React.createElement(badge, {
					text = p2.content.text,
					variant = badgeVariant.Neutral,
					Position = UDim2.new(0, 0, 0, -v5.Gap.XXSmall)
				})
			}
		)
	end

	local v7

	if p2.content and p2.content.colorStyle then
		v7 = p2.content.colorStyle
	else
		v7 = v5.Color.Content.Emphasis
	end

	local v8 = if p2.content and p2.content.iconSize then p2.content.iconSize else iconSize.Small
	local v9

	if p2.content and p2.content.fontStyle then
		v9 = p2.content.fontStyle
	else
		v9 = v5.Typography.BodyMedium
	end

	if fFlagAXDurablesFooter and p2.content.type == "multi" then
		local content = p2.content
		local children = {
			ItemCardPriceLineLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v5.Gap.XXSmall)
			})
		}
		local total = 1

		for k, content2 in content.contents do
			if k > 1 then
				children[`priceLineSpacer{k}`] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v5.Gap.XSmall, 0),
					LayoutOrder = total
				})

				total += 1
			end

			if content2.type == "badge" then
				children[`priceLine{k}Badge`] = React.createElement(badge, {
					text = content2.text,
					variant = badgeVariant.Neutral,
					Position = UDim2.new(0, 0, 0, -v5.Gap.XXSmall)
				})

				total += 1
			else
				local v10 = if content2.colorStyle then content2.colorStyle else v5.Color.Content.Emphasis
				local v11 = renderContentChildren(content2, `priceLine{k}`, total, total + 1, v10, v5, v6)

				for k2, v12 in v11 do
					children[k2] = v12
				end

				total += 2
			end
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = p2.LayoutOrder
		}, children)
	else
		local createElement = React.createElement
		local v11 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = p2.LayoutOrder
		}
		local v12 = {
			ItemCardPriceLineLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v5.Gap.XXSmall)
			}),
			ItemCardPriceLineRobuxIcon = 0,
			ItemCardPriceLineAmount = 0
		}

		local v13 = if p2.content.type == "price" then React.createElement(icon, {
			name = "robux",
			style = v7,
			size = v8,
			LayoutOrder = 1,
			testId = "priceLineRobuxIcon"
		}) else nil
		v12.ItemCardPriceLineRobuxIcon = v13

		local createElement2 = React.createElement

		local v16 = if p2.content.type == "price" then getLocalizedPrice(p2.content.price) else p2.content.text
		v12.ItemCardPriceLineAmount = createElement2(text, {
			textStyle = v7,
			fontStyle = v9,
			LayoutOrder = 2,
			Text = v16,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextTruncate = Enum.TextTruncate.SplitWord
		})
		return createElement("Frame", v11, v12)
	end
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardPriceLine))
end

return ItemCardPriceLine
