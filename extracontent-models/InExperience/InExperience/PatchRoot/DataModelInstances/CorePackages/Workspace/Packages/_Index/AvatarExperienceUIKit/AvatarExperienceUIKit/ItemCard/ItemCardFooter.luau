local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local ItemCardPriceLine = require(script.Parent.ItemCardPriceLine)
local ItemCardCreatorName = require(script.Parent.ItemCardCreatorName)
local ItemCardTitle = require(script.Parent.ItemCardTitle)
local FFlagAXAddTextXAlignmentProp = require(Parent.AvatarExperienceFlags).FFlagAXAddTextXAlignmentProp

local function ItemCardFooter(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), React (copy), ItemCardTitle (copy), FFlagAXAddTextXAlignmentProp (copy), ItemCardCreatorName (copy), ItemCardPriceLine (copy)
	local v10 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		ItemCardFooterLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v10.Gap.XSmall)
		}),
		ItemCardFooterInfo = if not t1.title and not t1.creatorName then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ItemCardFooterInfoLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v10.Gap.XXSmall)
			}),
			ItemCardFooterInfoTitle = if not t1.title then nil else React.createElement(ItemCardTitle, {
				LayoutOrder = 1,
				title = t1.title,
				titleTextSize = t1.titleTextSize,
				TextXAlignment = if not FFlagAXAddTextXAlignmentProp then nil else t1.TextXAlignment
			}),
			ItemCardFooterInfoCreatorName = if not t1.creatorName then nil else React.createElement(ItemCardCreatorName, {
				LayoutOrder = 2,
				name = t1.creatorName,
				hasVerifiedBadge = t1.creatorHasVerifiedBadge,
				TextXAlignment = if not FFlagAXAddTextXAlignmentProp then nil else t1.TextXAlignment
			})
		}),
		ItemCardFooterPrice = if not t1.priceLineContent then nil else React.createElement(ItemCardPriceLine, {
			LayoutOrder = 2,
			content = t1.priceLineContent
		})
	})
end

if require(Parent.AvatarExperienceFlags).FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardFooter))
end

return ItemCardFooter
