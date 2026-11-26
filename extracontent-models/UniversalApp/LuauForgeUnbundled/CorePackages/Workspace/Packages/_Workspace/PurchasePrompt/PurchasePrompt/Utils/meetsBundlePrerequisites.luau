local Players = game:GetService("Players")

local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local function meetsBundlePrerequisites(data, p2, p3, p4, p5)
	local collectibleItemDetail = data.collectibleItemDetail
	local v5

	if collectibleItemDetail then
		if collectibleItemDetail.collectibleItemId == nil then
			v5 = false
		else
			v5 = collectibleItemDetail.collectibleItemId ~= ""
		end
	else
		v5 = collectibleItemDetail
	end

	local v6

	if collectibleItemDetail then
		if collectibleItemDetail.collectibleItemType == nil then
			v6 = false
		else
			v6 = collectibleItemDetail.collectibleItemType == "Limited"
		end
	else
		v6 = collectibleItemDetail
	end

	if v5 then
		if not v6 and p4 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p4 then
		return false, PurchaseError.AlreadyOwn
	end

	local v7

	if v5 then
		v7 = collectibleItemDetail.saleStatus == "OnSale"
	else
		v7 = data.product and data.product.isForSale
	end

	if v5 then
		if collectibleItemDetail.lowestAvailableResaleProductId == nil then
			v5 = false
		else
			v5 = collectibleItemDetail.lowestAvailableResaleProductId ~= ""
		end
	end

	if not (v7 or v5) then
		return false, PurchaseError.NotForSale
	end

	if p3 ~= nil and p2.robux ~= nil and p2.robux < p3 then
		return false, PurchaseError.NotEnoughRobux
	end

	if data.itemRestrictions == nil then
		return true, nil
	end

	for k, itemRestriction in data.itemRestrictions do
		if itemRestriction ~= "ThirteenPlus" then
			continue
		end

		if Players.LocalPlayer:GetUnder13() then
			return false, PurchaseError.Under13
		end

		break
	end

	return true, nil
end

return meetsBundlePrerequisites
