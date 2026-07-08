local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Checkbox = require(ParentParent.Foundation).Checkbox

require(script.Parent.useCartPricing)

local function buildCartPricingOfferCheckboxes(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), Checkbox (copy)
	local cartPricing = t1.cartPricing
	local t2 = {}

	if not cartPricing.showCartOfferUi then
		return t2
	end

	for v8, v9 in cartPricing.cartPricingOffers do
		local offerId = v9.offerId

		t2["CartPricingOffer_" .. offerId] = React.createElement(Checkbox, {
			size = "XSmall",
			LayoutOrder = v8,
			label = v9.localizedDescription,
			isChecked = v9.selected,
			isDisabled = t1.isDisabled,
			onActivated = function() -- line: 33
				-- upvalues: cartPricing (copy), offerId (copy)
				cartPricing.toggleCartPricingOffer(offerId)
			end
		})
	end

	return t2
end

return buildCartPricingOfferCheckboxes
