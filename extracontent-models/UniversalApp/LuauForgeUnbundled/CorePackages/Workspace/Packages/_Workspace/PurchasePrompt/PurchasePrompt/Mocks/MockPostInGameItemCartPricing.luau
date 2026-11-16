local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")

local function isOfferDeselected(items): boolean
	if items == nil then
		return false
	end

	for k, item in items do
		if item == "be86b44b-462a-41a2-a059-01411756f07d" then
			return true
		end
	end

	return false
end

local function buildMockResponse(items)
	local v5

	if items == nil then
		v5 = false
	else
		local flag = true

		for k, item in items do
			if item == "be86b44b-462a-41a2-a059-01411756f07d" then
				v5 = true
				flag = false
				break
			end
		end

		if flag then
			v5 = false
		end
	end

	local v6 = not v5

	local v7 = {
		productIdentifier = { namespace = "GamePass", targetIdentifier = "12345" },
		priceInRobux = v6 and 80 or 100,
		regularPriceInRobux = 100
	}

	if v6 then
		v7.discountInformation = {
			originalPrice = 100,
			totalDiscountPercentage = 20,
			totalDiscountAmount = 20,
			discounts = {
				{
					robuxDiscountAmount = 20,
					robuxDiscountPercentage = 20,
					discountCampaign = "sample-campaign",
					localizedDiscountAttribution = "XX% offer",
					discountType = "MARKETPLACE_OFFER",
					discountId = "be86b44b-462a-41a2-a059-01411756f07d"
				}
			}
		}
	end

	return {
		items = { v7 },
		savingsSummary = v6 and "Saving R$ XX" or nil,
		availableOffers = {
			{
				offerId = "be86b44b-462a-41a2-a059-01411756f07d",
				localizedDescription = "XX% off one item up to R$ XX",
				expirationTimeUtc = DateTime.fromUnixTimestamp(DateTime.now().UnixTimestamp + 259200):ToIsoDate(),
				selected = v6
			}
		}
	}
end

local function MockPostInGameItemCartPricing(p2, p3, p4, list, p5, p6, p7)
	if list == nil or #list == 0 then
		return Promise.resolve(nil)
	end

	return Promise.resolve(buildMockResponse(p5))
end

return MockPostInGameItemCartPricing
