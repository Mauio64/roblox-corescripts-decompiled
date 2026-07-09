local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local CheckoutPage = require(AvatarExperienceCatalog.Components.Checkout.CheckoutPage)
local useCheckoutPageViewModel = require(AvatarExperienceCatalog.Components.Checkout.useCheckoutPageViewModel)

local function CheckoutPageContainer(p1) -- line: 10
	-- upvalues: useCheckoutPageViewModel (copy), React (copy), CheckoutPage (copy)
	local v8 = useCheckoutPageViewModel(p1)

	return React.createElement(CheckoutPage, v8)
end

return CheckoutPageContainer
