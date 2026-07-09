local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function CheckoutErrorBanner(t1: {[any]: any}) -- line: 14
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy)
	local v7 = useLocalization({
		checkoutErrorTitleSingular = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		checkoutErrorDescription = "Feature.Catalog.Message.Checkout.PurchaseFailed",
		checkoutErrorTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = t1.erroredItemCount
		}
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y row gap-medium bg-surface-200 items-center radius-medium padding-large",
		testId = "CheckoutErrorBanner"
	}, {
		CheckoutErrorIcon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			variant = Foundation.Enums.IconVariant.Filled,
			size = Foundation.Enums.InputSize.Large
		}),
		CheckoutTextRows = React.createElement(Foundation.View, {
			tag = "size-full-0 col gap-small fill auto-y"
		}, {
			CheckoutErrorTitle = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-wrap fill text-label-medium text-align-x-left content-emphasis",
				Text = if t1.erroredItemCount ~= 1 then v7.checkoutErrorTitlePlural else v7.checkoutErrorTitleSingular
			}),
			CheckoutErrorDescription = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-wrap fill text-body-medium text-align-x-left content-default",
				Text = v7.checkoutErrorDescription
			})
		})
	})
end

return React.memo(CheckoutErrorBanner)
