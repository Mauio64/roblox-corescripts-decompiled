local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function mergeOfferIdsIntoPurchasePayload(value, p2)
	if p2 == nil or p2.Offers == nil then
		return value
	end

	local v5 = {}

	for k, offer in p2.Offers do
		if not (type(offer) == "table" and type(offer.Id) == "string" and offer.Id ~= "") then
			continue
		end

		table.insert(v5, { source = "Offer", discountId = offer.Id })
	end

	if #v5 == 0 then
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

	result.discounts = v5

	local success, result2 = pcall(HttpService.JSONEncode, HttpService, result)

	if success and type(result2) == "string" then
		return result2
	end

	return value
end

return mergeOfferIdsIntoPurchasePayload
