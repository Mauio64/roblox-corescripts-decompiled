local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local getIconRichText = Foundation.Utility.getIconRichText

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function CheckoutTotalLines(props)
	local v = useLocalization({
		totalItemsLabel = {
			"Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = props.itemCount
		}
	})

	local createElement = React.createElement
	local view = Foundation.View
	local layoutOrder

	if FFlagAXMISWithBlackbird then
		layoutOrder = props.LayoutOrder
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v2 = {
		ItemCount = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = v.totalItemsLabel,
			LayoutOrder = 1
		}),
		TotalPrice = 0
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local originalPrice

	if props.totalPrice and props.totalOriginalPrice and props.totalPrice < props.totalOriginalPrice then
		originalPrice = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-small content-muted",
			Text = "<s>" .. `{getIconRichText(Foundation.Enums.IconName.Robux)} {props.totalOriginalPrice}` .. "</s>",
			LayoutOrder = 1,
			RichText = true
		})
	end

	v2.TotalPrice = createElement3(view3, {
		tag = "auto-xy row items-center gap-small",
		LayoutOrder = 2
	}, {
		OriginalPrice = originalPrice,
		TotalPriceText = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = `{getIconRichText(Foundation.Enums.IconName.Robux)} {props.totalPrice}`,
			LayoutOrder = 2,
			RichText = true
		})
	})
	return createElement(view, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = layoutOrder
	}, {
		TotalLine = createElement2(
			view2,
			{ tag = "size-full-0 auto-y fill flex-between items-center row gap-small" },
			v2
		)
	})
end

return CheckoutTotalLines
