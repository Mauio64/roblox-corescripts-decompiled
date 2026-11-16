local parent = script.Parent.Parent
local parent2 = parent.Parent

local Promise = require(parent.Promise)
require(parent.types)

require(parent2.IAPExperience)
require(parent2.PurchasePromptLite)

local function isOfferDeselected(items): boolean -- 1 equivalent call inferred from this helper
	if items == nil then
		return false
	end

	for _, item in items do
		if item == "be86b44b-462a-41a2-a059-01411756f07d" then
			return true
		end
	end

	return false
end

local function buildMockResponse(items)
	local selected = not isOfferDeselected(items) -- inferred equivalent call

	local v = {
		productIdentifier = { namespace = "GamePass", targetIdentifier = "12345" },
		priceInRobux = selected and 80 or 100,
		regularPriceInRobux = 100
	}

	if selected then
		v.discountInformation = {
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
		items = { v },
		savingsSummary = selected and "Saving R$ XX" or nil,
		availableOffers = {
			{
				offerId = "be86b44b-462a-41a2-a059-01411756f07d",
				localizedDescription = "XX% off one item up to R$ XX",
				expirationTimeUtc = DateTime.fromUnixTimestamp(DateTime.now().UnixTimestamp + 259200):ToIsoDate(),
				selected = selected
			}
		}
	}
end

local function MockPostInGameItemCartPricing(_, _: number, _: string, list, p, _, _)
	if list == nil or #list == 0 then
		return Promise.resolve(nil)
	end

	return Promise.resolve(buildMockResponse(p))
end

return MockPostInGameItemCartPricing
