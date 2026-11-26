local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local OfferCheckboxRow = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/OfferCheckboxRow")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")

local function buildCartPricingOfferCheckboxes(p2)
	local cartPricing = p2.cartPricing
	local children = {}

	if not cartPricing.showCartOfferUi then
		return children
	end

	for k, cartPricingOffer in cartPricing.cartPricingOffers do
		local offerId = cartPricingOffer.offerId
		children["CartPricingOffer_" .. offerId] = React.createElement(OfferCheckboxRow, {
			LayoutOrder = k,
			label = cartPricingOffer.localizedDescription,
			isChecked = cartPricingOffer.selected,
			isDisabled = p2.isDisabled,
			expirationTimeUtc = cartPricingOffer.expirationTimeUtc,
			onActivated = function()
				cartPricing.toggleCartPricingOffer(offerId)
			end
		})
	end

	return children
end

return buildCartPricingOfferCheckboxes
