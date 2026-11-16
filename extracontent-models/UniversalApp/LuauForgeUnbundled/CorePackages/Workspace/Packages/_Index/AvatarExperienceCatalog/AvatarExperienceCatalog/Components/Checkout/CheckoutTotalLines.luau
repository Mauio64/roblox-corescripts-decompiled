local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local getIconRichText = Foundation.Utility.getIconRichText

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function CheckoutTotalLines(props)
	local v5 = useLocalization({
		totalItemsLabel = {
			"Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = props.itemCount
		}
	})

	local createElement = React.createElement
	local view = Foundation.View

	local v7 = if fFlagAXMISWithBlackbird then props.LayoutOrder else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v10 = {
		ItemCount = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = v5.totalItemsLabel,
			LayoutOrder = 1
		}),
		TotalPrice = 0
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v13 = if props.totalPrice and props.totalOriginalPrice and props.totalPrice < props.totalOriginalPrice then React.createElement(Foundation.Text, {
		tag = "auto-xy text-title-small content-muted",
		Text = "<s>" .. `{getIconRichText(module2.Enums.IconName.Robux)} {props.totalOriginalPrice}` .. "</s>",
		LayoutOrder = 1,
		RichText = true
	}) else nil
	v10.TotalPrice = createElement3(
		view3,
		{ tag = "auto-xy row items-center gap-small", LayoutOrder = 2 },
		{
			OriginalPrice = v13,
			TotalPriceText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium content-emphasis",
				Text = `{getIconRichText(module2.Enums.IconName.Robux)} {props.totalPrice}`,
				LayoutOrder = 2,
				RichText = true
			})
		}
	)
	return createElement(view, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = v7
	}, {
		TotalLine = createElement2(
			view2,
			{ tag = "size-full-0 auto-y fill flex-between items-center row gap-small" },
			v10
		)
	})
end

return CheckoutTotalLines
