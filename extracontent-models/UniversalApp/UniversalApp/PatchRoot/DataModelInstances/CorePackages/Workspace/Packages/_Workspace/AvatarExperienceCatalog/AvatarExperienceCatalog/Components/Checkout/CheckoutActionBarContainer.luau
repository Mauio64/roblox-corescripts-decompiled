local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local useCheckoutActionBarProps = require(AvatarExperienceCatalog.Components.Checkout.useCheckoutActionBarProps)
local CheckoutActionBar = require(AvatarExperienceCatalog.Components.Checkout.CheckoutActionBar)
local v6 = React.forwardRef(function(p1, p2) -- line: 10
	-- upvalues: useCheckoutActionBarProps (copy), React (copy), CheckoutActionBar (copy)
	local v9 = useCheckoutActionBarProps(p1, p2)

	return React.createElement(CheckoutActionBar, v9)
end)

return React.memo(v6)
