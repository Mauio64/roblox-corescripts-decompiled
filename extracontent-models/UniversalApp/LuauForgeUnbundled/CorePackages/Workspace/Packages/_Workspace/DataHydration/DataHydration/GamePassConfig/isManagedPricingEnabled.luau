require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")

local function isManagedPricingEnabled(p2)
	if p2.isManagedPricingEnabled ~= nil then
		return p2.isManagedPricingEnabled
	end

	local enabledFeatures = if p2.priceInformation ~= nil then p2.priceInformation.enabledFeatures else nil

	if enabledFeatures == nil then
		return nil
	end

	return table.find(enabledFeatures, "RegionalPricing") ~= nil
end

return isManagedPricingEnabled
