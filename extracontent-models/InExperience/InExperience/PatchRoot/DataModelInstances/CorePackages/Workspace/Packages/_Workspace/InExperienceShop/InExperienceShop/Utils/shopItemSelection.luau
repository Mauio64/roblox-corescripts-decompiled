local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function findItemById(t1: {[any]: any}, s1: string?, p1) -- line: 10
	if s1 == nil or p1 == nil then
		return nil
	end

	for _, v8 in t1 do
		for _, v10 in v8.items do
			if s1 == v10.id and p1 == v10.itemType then
				return v10
			end
		end
	end

	return nil
end
local function findBonusItemById(t2: {[any]: any}, s2: string?, p2) -- line: 24
	if s2 == nil or p2 == nil then
		return nil
	end

	for _, v15 in t2 do
		local featuredRobuxPackage = v15.featuredRobuxPackage

		if featuredRobuxPackage ~= nil then
			local bonusItemDetails = featuredRobuxPackage.bonusItemDetails

			if bonusItemDetails ~= nil and s2 == bonusItemDetails.id and p2 == bonusItemDetails.itemType then
				return bonusItemDetails
			end
		end

		local robuxPackages = v15.robuxPackages

		if robuxPackages ~= nil then
			for _, v20 in robuxPackages do
				local bonusItemDetails = v20.bonusItemDetails

				if bonusItemDetails ~= nil and s2 == bonusItemDetails.id and p2 == bonusItemDetails.itemType then
					return bonusItemDetails
				end
			end
		end
	end

	return nil
end

return {
	findItemById = findItemById,
	findBonusItemById = findBonusItemById,
	resolveItemForSelection = function(t3: {[any]: any}, s3: string?, p3, b1: boolean) -- line: 53
		-- upvalues: findItemById (copy), findBonusItemById (copy)
		local v26 = findItemById(t3, s3, p3)

		if v26 ~= nil then
			return v26
		end

		if b1 then
			return (findBonusItemById(t3, s3, p3))
		end

		return nil
	end,
	isRobuxBonusOnlySelection = function(t4: {[any]: any}, s4: string?, p4, b2: boolean) -- line: 71
		-- upvalues: findItemById (copy), findBonusItemById (copy)
		if not b2 or (s4 == nil or p4 == nil) then
			return false
		end

		if findItemById(t4, s4, p4) ~= nil then
			return false
		end

		return findBonusItemById(t4, s4, p4) ~= nil
	end
}
