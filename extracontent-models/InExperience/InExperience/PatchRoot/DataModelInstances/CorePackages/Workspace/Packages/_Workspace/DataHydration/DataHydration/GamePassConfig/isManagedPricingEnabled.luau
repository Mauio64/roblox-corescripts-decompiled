require(script.Parent.GamePassConfigTypes)

local function isManagedPricingEnabled(p)
	if p.isManagedPricingEnabled ~= nil then
		return p.isManagedPricingEnabled
	end

	local enabledFeatures

	if p.priceInformation ~= nil then
		enabledFeatures = p.priceInformation.enabledFeatures
	end

	if enabledFeatures == nil then
		return nil
	end

	return table.find(enabledFeatures, "RegionalPricing") ~= nil
end

return isManagedPricingEnabled
