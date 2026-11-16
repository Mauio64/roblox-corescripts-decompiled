local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
require(parent.AvatarExperienceUIKit)

local function getRecommendationPriceLineContent(data)
	local priceStatus = data.priceStatus

	if typeof(priceStatus) == "string" and priceStatus ~= "" then
		return { type = "text", text = priceStatus }
	end

	local lowestPrice = data.lowestPrice or data.priceInRobux

	if lowestPrice == nil or lowestPrice <= 0 then
		return { type = "text", text = data.freeLabel }
	end

	return { type = "price", price = lowestPrice }
end

return getRecommendationPriceLineContent
