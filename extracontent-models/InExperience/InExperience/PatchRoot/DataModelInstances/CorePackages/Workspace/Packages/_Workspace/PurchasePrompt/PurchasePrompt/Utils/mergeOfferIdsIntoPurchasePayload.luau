local HttpService = game:GetService("HttpService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
require(PurchasePrompt.types)

local function mergeOfferIdsIntoPurchasePayload(value: string?, p)
	if p == nil or p.Offers == nil then
		return value
	end

	local discounts = {}

	for _, offer in p.Offers do
		if not (type(offer) == "table" and type(offer.Id) == "string" and offer.Id ~= "") then
			continue
		end

		table.insert(discounts, { source = "Offer", discountId = offer.Id })
	end

	if #discounts == 0 then
		return value
	end

	local result

	if type(value) == "string" and value ~= "" then
		local success
		success, result = pcall(HttpService.JSONDecode, HttpService, value)

		if not success or type(result) ~= "table" then
			return value
		end
	else
		result = {}
	end

	result.discounts = discounts

	local success, result2 = pcall(HttpService.JSONEncode, HttpService, result)

	if success and type(result2) == "string" then
		return result2
	end

	return value
end

return mergeOfferIdsIntoPurchasePayload
