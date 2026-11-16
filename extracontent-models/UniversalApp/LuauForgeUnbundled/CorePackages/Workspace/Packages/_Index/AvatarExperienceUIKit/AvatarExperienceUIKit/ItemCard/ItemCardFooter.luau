local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").Hooks.useTokens

local ItemCardPriceLine = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardPriceLine")
local ItemCardCreatorName = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardCreatorName")
local ItemCardTitle = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardTitle")

local fFlagAXAddTextXAlignmentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXAddTextXAlignmentProp

local function ItemCardFooter(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local v7 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = true
	}

	local v8 = {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.Gap.XSmall)
		}),
		ItemCardFooterInfo = 0,
		ItemCardFooterPrice = 0
	}
	local v9

	if props.title or props.creatorName then
		local createElement2 = React.createElement
		local v11 = {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}

		local v12 = {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v5.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = 0,
			ItemCardFooterInfoCreatorName = 0
		}
		local v13

		if props.title then
			local createElement3 = React.createElement
			local v15 = {
				title = props.title,
				titleTextSize = props.titleTextSize,
				LayoutOrder = 1,
				TextXAlignment = 0
			}

			local v16 = if fFlagAXAddTextXAlignmentProp then props.TextXAlignment else nil
			v15.TextXAlignment = v16
			v13 = createElement3(ItemCardTitle, v15)
		end

		v12.ItemCardFooterInfoTitle = v13
		local v14

		if props.creatorName then
			local createElement3 = React.createElement
			local v16 = {
				name = props.creatorName,
				hasVerifiedBadge = props.creatorHasVerifiedBadge,
				LayoutOrder = 2,
				TextXAlignment = 0
			}

			local v17 = if fFlagAXAddTextXAlignmentProp then props.TextXAlignment else nil
			v16.TextXAlignment = v17
			v14 = createElement3(ItemCardCreatorName, v16)
		end

		v12.ItemCardFooterInfoCreatorName = v14
		v9 = createElement2("Frame", v11, v12)
	end

	v8.ItemCardFooterInfo = v9

	local v10 = if props.priceLineContent then React.createElement(ItemCardPriceLine, {
		content = props.priceLineContent,
		LayoutOrder = 2
	}) else nil
	v8.ItemCardFooterPrice = v10
	return createElement("Frame", v7, v8)
end

if require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardFooter))
end

return ItemCardFooter
