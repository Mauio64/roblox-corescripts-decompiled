require(script.Parent.MonetizationPageView)

local v = {
	GamePass = {
		priceRequiredForSale = true,
		regionalPricing = true,
		editableName = true,
		editablePrice = true
	},
	Subscription = {
		priceRequiredForSale = false,
		regionalPricing = false,
		editableName = false,
		editablePrice = false
	}
}

local function getProductKindCapabilities(p)
	if p == nil then
		return nil
	end

	return v[p]
end

return getProductKindCapabilities
