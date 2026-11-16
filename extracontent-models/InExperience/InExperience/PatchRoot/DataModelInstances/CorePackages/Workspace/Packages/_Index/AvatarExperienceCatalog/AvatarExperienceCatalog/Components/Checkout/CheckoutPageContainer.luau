local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

local CheckoutPage = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPage)
local useCheckoutPageViewModel = require(AvatarExperienceCatalog.Components.Checkout.useCheckoutPageViewModel)

local function CheckoutPageContainer(p)
	local v = useCheckoutPageViewModel(p)
	return React.createElement(CheckoutPage, v)
end

return CheckoutPageContainer
