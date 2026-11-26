local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local CheckoutPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPage")
local useCheckoutPageViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/useCheckoutPageViewModel")

local function CheckoutPageContainer(p2)
	local v5 = useCheckoutPageViewModel(p2)
	return React.createElement(CheckoutPage, v5)
end

return CheckoutPageContainer
