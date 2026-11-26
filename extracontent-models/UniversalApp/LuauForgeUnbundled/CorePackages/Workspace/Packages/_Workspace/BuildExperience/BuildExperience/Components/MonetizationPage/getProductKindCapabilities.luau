require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageView")

local v5 = {
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

local function getProductKindCapabilities(p2)
	if p2 == nil then
		return nil
	end

	return v5[p2]
end

return getProductKindCapabilities
