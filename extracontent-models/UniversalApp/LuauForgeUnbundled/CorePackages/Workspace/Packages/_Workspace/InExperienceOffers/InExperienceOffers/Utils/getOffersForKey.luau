require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

local function getOffersForKey(p2, p3, p4)
	if p2 == nil then
		return nil
	end

	local v5 = p2[p3]

	if v5 == nil or p4 == nil then
		return v5
	end

	local result = {}

	for k, v6 in v5 do
		if v6.offerStatus == p4 then
			table.insert(result, v6)
		end
	end

	if #result > 0 then
		return result
	end

	return nil
end

return getOffersForKey
