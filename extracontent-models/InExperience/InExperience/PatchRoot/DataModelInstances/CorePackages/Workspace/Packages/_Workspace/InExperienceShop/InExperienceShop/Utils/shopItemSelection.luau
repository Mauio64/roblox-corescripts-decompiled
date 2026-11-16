local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function findItemById(items, p: string?, p2)
	if p == nil or p2 == nil then
		return nil
	end

	for _, item in items do
		for _, item2 in item.items do
			if item2.id == p and item2.itemType == p2 then
				return item2
			end
		end
	end

	return nil
end

local function findBonusItemById(items, p: string?, p2)
	if p == nil or p2 == nil then
		return nil
	end

	for _, item in items do
		local featuredRobuxPackage = item.featuredRobuxPackage

		if featuredRobuxPackage ~= nil then
			local bonusItemDetails = featuredRobuxPackage.bonusItemDetails

			if bonusItemDetails ~= nil and bonusItemDetails.id == p and bonusItemDetails.itemType == p2 then
				return bonusItemDetails
			end
		end

		local robuxPackages = item.robuxPackages

		if robuxPackages == nil then
			continue
		end

		for _, robuxPackage in robuxPackages do
			local bonusItemDetails = robuxPackage.bonusItemDetails

			if bonusItemDetails ~= nil and bonusItemDetails.id == p and bonusItemDetails.itemType == p2 then
				return bonusItemDetails
			end
		end
	end

	return nil
end

local ShopItemSelection = {}
ShopItemSelection.findItemById = findItemById
ShopItemSelection.findBonusItemById = findBonusItemById

function ShopItemSelection.resolveItemForSelection(p, p2: string?, p3, flag: boolean)
	local itemById = findItemById(p, p2, p3)

	if itemById ~= nil then
		return itemById
	end

	if flag then
		return findBonusItemById(p, p2, p3)
	end

	return nil
end

function ShopItemSelection.isRobuxBonusOnlySelection(p, p2: string?, p3, flag: boolean): boolean
	if not flag or p2 == nil or p3 == nil then
		return false
	end

	return findItemById(p, p2, p3) == nil and findBonusItemById(p, p2, p3) ~= nil
end

return ShopItemSelection
