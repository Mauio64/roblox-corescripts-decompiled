local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local ItemCardPriceLine = require(script.Parent.ItemCardPriceLine)
local ItemCardCreatorName = require(script.Parent.ItemCardCreatorName)
local ItemCardTitle = require(script.Parent.ItemCardTitle)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddTextXAlignmentProp = AvatarExperienceFlags.FFlagAXAddTextXAlignmentProp
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)

local function ItemCardFooter(props)
	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = true
	}

	local v3 = {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v.Gap.XSmall)
		}),
		ItemCardFooterInfo = 0,
		ItemCardFooterPrice = 0
	}
	local itemCardFooterInfo

	if props.title or props.creatorName then
		local createElement2 = React.createElement
		local v4 = {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}

		local v5 = {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = 0,
			ItemCardFooterInfoCreatorName = 0
		}
		local itemCardFooterInfoTitle

		if props.title then
			local createElement3 = React.createElement
			local v6 = {
				title = props.title,
				titleTextSize = props.titleTextSize,
				LayoutOrder = 1,
				TextXAlignment = 0
			}
			local textXAlignment

			if FFlagAXAddTextXAlignmentProp then
				textXAlignment = props.TextXAlignment
			end

			v6.TextXAlignment = textXAlignment
			itemCardFooterInfoTitle = createElement3(ItemCardTitle, v6)
		end

		v5.ItemCardFooterInfoTitle = itemCardFooterInfoTitle
		local itemCardFooterInfoCreatorName

		if props.creatorName then
			local createElement3 = React.createElement
			local v6 = {
				name = props.creatorName,
				hasVerifiedBadge = props.creatorHasVerifiedBadge,
				LayoutOrder = 2,
				TextXAlignment = 0
			}
			local textXAlignment

			if FFlagAXAddTextXAlignmentProp then
				textXAlignment = props.TextXAlignment
			end

			v6.TextXAlignment = textXAlignment
			itemCardFooterInfoCreatorName = createElement3(ItemCardCreatorName, v6)
		end

		v5.ItemCardFooterInfoCreatorName = itemCardFooterInfoCreatorName
		itemCardFooterInfo = createElement2("Frame", v4, v5)
	end

	v3.ItemCardFooterInfo = itemCardFooterInfo
	local itemCardFooterPrice

	if props.priceLineContent then
		itemCardFooterPrice = React.createElement(ItemCardPriceLine, {
			content = props.priceLineContent,
			LayoutOrder = 2
		})
	end

	v3.ItemCardFooterPrice = itemCardFooterPrice
	return createElement("Frame", v2, v3)
end

if AvatarExperienceFlags2.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardFooter))
end

return ItemCardFooter
