local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function CheckoutErrorBanner(p)
	local v = useLocalization({
		checkoutErrorTitleSingular = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		checkoutErrorTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = p.erroredItemCount
		},
		checkoutErrorDescription = "Feature.Catalog.Message.Checkout.PurchaseFailed"
	})

	local createElement = React.createElement
	local view = Foundation.View

	local v2 = {
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
	local text2

	if p.erroredItemCount == 1 then
		text2 = v.checkoutErrorTitleSingular
	else
		text2 = v.checkoutErrorTitlePlural
	end

	v2.CheckoutTextRows = createElement2(view2, { tag = "size-full-0 col gap-small fill auto-y" }, {
		CheckoutErrorTitle = createElement3(text, {
			tag = "size-full-0 auto-y text-wrap fill text-label-medium text-align-x-left content-emphasis",
			Text = text2
		}),
		CheckoutErrorDescription = React.createElement(Foundation.Text, {
			tag = "size-full-0 auto-y text-wrap fill text-body-medium text-align-x-left content-default",
			Text = v.checkoutErrorDescription
		})
	})
	return createElement(
		view,
		{
			tag = "size-full-0 auto-y row gap-medium bg-surface-200 items-center radius-medium padding-large",
			testId = "CheckoutErrorBanner"
		},
		v2
	)
end

return React.memo(CheckoutErrorBanner)
