local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local Text = Foundation.Text
local Icon = Foundation.Icon
local Badge = Foundation.Badge
local IconSize = Foundation.Enums.IconSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local getLocalizedPrice = require(AvatarExperienceUIKit.ItemCard.Utils.getLocalizedPrice)

local FFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter

local function renderIconTextPair(props)
	local children = {}

	if props.iconName then
		children[props.iconKey] = React.createElement(Icon, {
			name = props.iconName,
			style = props.resolvedColorStyle,
			size = IconSize.Small,
			LayoutOrder = props.iconLayoutOrder,
			testId = props.iconKey
		})
	end

	children[props.textKey] = React.createElement(Text, {
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

local function renderContentChildren(content, p: string, textLayoutOrder: number, p2: number, resolvedColorStyle, tokens, designTokens)
	local iconName = nil
	local text, v, v2

	if content.type == "price" then
		text = getLocalizedPrice(content.price)
		iconName = "robux"
		v = "RobuxIcon"
		v2 = "Amount"
	elseif content.type == "timedOption" then
		iconName = content.icon
		text = content.text
		v = "TimedOptionIcon"
		v2 = "TimedOptionText"
	else
		if content.type ~= "text" then
			return {}
		end

		text = content.text
		v = "Text"
		v2 = "Text"
	end

	local v3 = {
		iconName = iconName,
		text = text,
		iconKey = `{p}{v}`,
		textKey = `{p}{v2}`,
		iconLayoutOrder = textLayoutOrder,
		textLayoutOrder = 0,
		resolvedColorStyle = 0,
		tokens = 0,
		designTokens = 0
	}

	if iconName then
		textLayoutOrder = p2
	end

	v3.textLayoutOrder = textLayoutOrder
	v3.resolvedColorStyle = resolvedColorStyle
	v3.tokens = tokens
	v3.designTokens = designTokens
	return renderIconTextPair(v3)
end

local function ItemCardPriceLine(p)
	local tokens = useTokens()
	local designTokens = useDesignTokens()

	if p.content.type == "badge" then
		return (React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = p.LayoutOrder
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, tokens.Padding.XSmall)
				}),
				Badge = React.createElement(Badge, {
					text = p.content.text,
					variant = BadgeVariant.Neutral,
					Position = UDim2.new(0, 0, 0, -tokens.Gap.XXSmall)
				})
			}
		))
	end

	local v

	if p.content and p.content.colorStyle then
		v = p.content.colorStyle
	else
		v = tokens.Color.Content.Emphasis
	end

	local size

	if p.content and p.content.iconSize then
		size = p.content.iconSize
	else
		size = IconSize.Small
	end

	local fontStyle

	if p.content and p.content.fontStyle then
		fontStyle = p.content.fontStyle
	else
		fontStyle = tokens.Typography.BodyMedium
	end

	if FFlagAXDurablesFooter and p.content.type == "multi" then
		local content = p.content
		local children = {
			ItemCardPriceLineLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, tokens.Gap.XXSmall)
			})
		}
		local total = 1

		for k, content2 in content.contents do
			if k > 1 then
				children[`priceLineSpacer{k}`] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(tokens.Gap.XSmall, 0),
					LayoutOrder = total
				})

				total += 1
			end

			if content2.type == "badge" then
				children[`priceLine{k}Badge`] = React.createElement(Badge, {
					text = content2.text,
					variant = BadgeVariant.Neutral,
					Position = UDim2.new(0, 0, 0, -tokens.Gap.XXSmall)
				})

				total += 1
			else
				local v2

				if content2.colorStyle then
					v2 = content2.colorStyle
				else
					v2 = tokens.Color.Content.Emphasis
				end

				local v3 = renderContentChildren(content2, `priceLine{k}`, total, total + 1, v2, tokens, designTokens)

				for k2, v4 in v3 do
					children[k2] = v4
				end

				total += 2
			end
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = p.LayoutOrder
		}, children)
	else
		local createElement = React.createElement
		local v2 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = p.LayoutOrder
		}
		local v3 = {
			ItemCardPriceLineLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, tokens.Gap.XXSmall)
			}),
			ItemCardPriceLineRobuxIcon = 0,
			ItemCardPriceLineAmount = 0
		}
		local itemCardPriceLineRobuxIcon

		if p.content.type == "price" then
			itemCardPriceLineRobuxIcon = React.createElement(Icon, {
				name = "robux",
				style = v,
				size = size,
				LayoutOrder = 1,
				testId = "priceLineRobuxIcon"
			})
		end

		v3.ItemCardPriceLineRobuxIcon = itemCardPriceLineRobuxIcon

		local createElement2 = React.createElement
		local text

		if p.content.type == "price" then
			text = getLocalizedPrice(p.content.price)
		else
			text = p.content.text
		end

		v3.ItemCardPriceLineAmount = createElement2(Text, {
			textStyle = v,
			fontStyle = fontStyle,
			LayoutOrder = 2,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextTruncate = Enum.TextTruncate.SplitWord
		})
		return createElement("Frame", v2, v3)
	end
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardPriceLine))
end

return ItemCardPriceLine
