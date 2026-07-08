local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local AvatarExperienceFlags = require(AvatarExperienceUIKitParent.AvatarExperienceFlags)
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Badge = Foundation.Badge
local IconSize = Foundation.Enums.IconSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens
local useDesignTokens = require(AvatarExperienceUIKitParent.Style).useDesignTokens
local getLocalizedPrice = require(AvatarExperienceUIKit.ItemCard.Utils.getLocalizedPrice)
local FFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXEnableIaBTimedOptionsBulkPurchase = AvatarExperienceFlags.FFlagAXEnableIaBTimedOptionsBulkPurchase

local function renderIconTextPair(t1: {[any]: any}) -- line: 88
	-- upvalues: React (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	local t2 = {}

	if t1.iconName then
		t2[t1.iconKey] = React.createElement(Icon, {
			name = t1.iconName,
			style = t1.resolvedColorStyle,
			size = IconSize.Small,
			LayoutOrder = t1.iconLayoutOrder,
			testId = t1.iconKey
		})
	end

	t2[t1.textKey] = React.createElement(FoundationText, {
		textStyle = t1.resolvedColorStyle,
		fontStyle = t1.tokens.Typography.BodyMedium,
		LayoutOrder = t1.textLayoutOrder,
		Text = t1.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTruncate = Enum.TextTruncate.SplitWord
	})

	return t2
end
local function renderContentChildren(t3: {[any]: any}, s1: string, n1: number, n2: number, p1, p2, p3) -- line: 115
	-- upvalues: getLocalizedPrice (copy), renderIconTextPair (copy)
	local s2 = nil
	local v30, s3, s4

	if t3.type == "price" then
		s2 = "robux"
		v30 = getLocalizedPrice(t3.price)
		s3 = "RobuxIcon"
		s4 = "Amount"
	elseif t3.type == "timedOption" then
		s2 = t3.icon
		v30 = t3.text
		s3 = "TimedOptionIcon"
		s4 = "TimedOptionText"
	else
		if t3.type ~= "text" then
			return {}
		end

		v30 = t3.text
		s3 = "Text"
		s4 = "Text"
	end

	return (renderIconTextPair({
		iconName = s2,
		text = v30,
		iconKey = `{ s1 }{ s3 }`,
		textKey = `{ s1 }{ s4 }`,
		iconLayoutOrder = n1,
		textLayoutOrder = if not s2 then n1 else n2,
		resolvedColorStyle = p1,
		tokens = p2,
		designTokens = p3
	}))
end
local function ItemCardPriceLine(t4: {[any]: any}) -- line: 160
	-- upvalues: useTokens (copy), useDesignTokens (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), React (copy), Badge (copy), BadgeVariant (copy), FFlagAXMISEnableMultiShopping (copy), IconSize (copy), FFlagAXDurablesFooter (copy), renderContentChildren (copy), Icon (copy), FoundationText (copy), getLocalizedPrice (copy)
	local v34 = useTokens()
	local v35 = useDesignTokens()

	if FFlagAXEnableIaBTimedOptionsBulkPurchase and t4.content.type == "badge" then
		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = t4.LayoutOrder
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v34.Padding.XSmall)
			}),
			Badge = React.createElement(Badge, {
				text = t4.content.text,
				variant = BadgeVariant.Neutral,
				Position = UDim2.new(0, 0, 0, -v34.Gap.XXSmall)
			})
		}))
	end

	local v36 = if not t4.content or not t4.content.colorStyle then v34.Color.Content.Emphasis else t4.content.colorStyle
	local v37 = if not FFlagAXMISEnableMultiShopping or (not t4.content or not t4.content.iconSize) then IconSize.Small else t4.content.iconSize
	local v38 = if not FFlagAXMISEnableMultiShopping or (not t4.content or not t4.content.fontStyle) then v34.Typography.BodyMedium else t4.content.fontStyle

	if FFlagAXDurablesFooter and t4.content.type == "multi" then
		local content = t4.content
		local t5 = {
			ItemCardPriceLineLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v34.Gap.XXSmall)
			})
		}
		local n3 = 1

		for v42, v43 in content.contents do
			if v42 > 1 then
				t5[`priceLineSpacer{ v42 }`] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v34.Gap.XSmall, 0),
					LayoutOrder = n3
				})
				n3 += 1
			end

			if FFlagAXEnableIaBTimedOptionsBulkPurchase and v43.type == "badge" then
				t5[`priceLine{ v42 }Badge`] = React.createElement(Badge, {
					text = v43.text,
					variant = BadgeVariant.Neutral,
					Position = UDim2.new(0, 0, 0, -v34.Gap.XXSmall)
				})
				n3 += 1
			else
				local v44 = if not v43.colorStyle then v34.Color.Content.Emphasis else v43.colorStyle

				for v45, v46 in (renderContentChildren(v43, `priceLine{ v42 }`, n3, n3 + 1, v44, v34, v35)) do
					t5[v45] = v46
				end

				n3 += 2
			end
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = t4.LayoutOrder
		}, t5)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = t4.LayoutOrder
	}, {
		ItemCardPriceLineLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v34.Gap.XXSmall)
		}),
		ItemCardPriceLineRobuxIcon = if t4.content.type ~= "price" then nil else React.createElement(Icon, {
			name = "robux",
			LayoutOrder = 1,
			testId = "priceLineRobuxIcon",
			style = v36,
			size = v37
		}),
		ItemCardPriceLineAmount = React.createElement(FoundationText, {
			LayoutOrder = 2,
			textStyle = v36,
			fontStyle = v38,
			Text = if t4.content.type ~= "price" then t4.content.text else getLocalizedPrice(t4.content.price),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextTruncate = Enum.TextTruncate.SplitWord
		})
	})
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardPriceLine))
end

return ItemCardPriceLine
