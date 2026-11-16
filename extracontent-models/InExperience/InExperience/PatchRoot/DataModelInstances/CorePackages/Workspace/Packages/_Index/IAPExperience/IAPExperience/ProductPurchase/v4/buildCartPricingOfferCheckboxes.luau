local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local OfferCheckboxRow = require(script.Parent.OfferCheckboxRow)

require(script.Parent.useCartPricing)

local function buildCartPricingOfferCheckboxes(p)
	local cartPricing = p.cartPricing
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
			isDisabled = p.isDisabled,
			expirationTimeUtc = cartPricingOffer.expirationTimeUtc,
			onActivated = function()
				cartPricing.toggleCartPricingOffer(offerId)
			end
		})
	end

	return children
end

return buildCartPricingOfferCheckboxes
