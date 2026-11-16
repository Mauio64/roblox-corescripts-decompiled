local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")

require(InExperienceOffers.Types)

local function getOffersForKey(p, p2: string, p3)
	if p == nil then
		return nil
	end

	local v = p[p2]

	if v == nil or p3 == nil then
		return v
	end

	local result = {}

	for _, v2 in v do
		if v2.offerStatus == p3 then
			table.insert(result, v2)
		end
	end

	return if #result > 0 then result else nil
end

return getOffersForKey
