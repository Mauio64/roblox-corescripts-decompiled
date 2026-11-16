local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

local function CheckoutErrorBanner(p2)
	local v5 = useLocalization({
		checkoutErrorTitleSingular = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		checkoutErrorTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = p2.erroredItemCount
		},
		checkoutErrorDescription = "Feature.Catalog.Message.Checkout.PurchaseFailed"
	})

	local createElement = React.createElement
	local view = Foundation.View

	local v7 = {
		CheckoutErrorIcon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			variant = Foundation.Enums.IconVariant.Filled,
			size = Foundation.Enums.InputSize.Large
		}),
		CheckoutTextRows = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local text = Foundation.Text

	local v10 = if p2.erroredItemCount == 1 then v5.checkoutErrorTitleSingular else v5.checkoutErrorTitlePlural
	v7.CheckoutTextRows = createElement2(view2, {
		tag = "size-full-0 col gap-small fill auto-y"
	}, {
		CheckoutErrorTitle = createElement3(text, {
			tag = "size-full-0 auto-y text-wrap fill text-label-medium text-align-x-left content-emphasis",
			Text = v10
		}),
		CheckoutErrorDescription = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-wrap fill text-body-medium text-align-x-left content-default",
			Text = v5.checkoutErrorDescription
		})
	})
	return createElement(
		view,
		{
			tag = "size-full-0 auto-y row gap-medium bg-surface-200 items-center radius-medium padding-large",
			testId = "CheckoutErrorBanner"
		},
		v7
	)
end

return React.memo(CheckoutErrorBanner)
