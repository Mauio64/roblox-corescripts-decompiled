local parent = script.Parent.Parent
local Players = game:GetService("Players")

local PurchaseError = require(parent.Enums.PurchaseError)

local function meetsBundlePrerequisites(data, p, p2: number?, p3, _)
	local collectibleItemDetail = data.collectibleItemDetail
	local v

	if collectibleItemDetail then
		if collectibleItemDetail.collectibleItemId == nil then
			v = false
		else
			v = collectibleItemDetail.collectibleItemId ~= ""
		end
	else
		v = collectibleItemDetail
	end

	local v2

	if collectibleItemDetail then
		if collectibleItemDetail.collectibleItemType == nil then
			v2 = false
		else
			v2 = collectibleItemDetail.collectibleItemType == "Limited"
		end
	else
		v2 = collectibleItemDetail
	end

	if v then
		if not v2 and p3 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p3 then
		return false, PurchaseError.AlreadyOwn
	end

	local v3

	if v then
		v3 = collectibleItemDetail.saleStatus == "OnSale"
	else
		v3 = data.product and data.product.isForSale
	end

	if v then
		if collectibleItemDetail.lowestAvailableResaleProductId == nil then
			v = false
		else
			v = collectibleItemDetail.lowestAvailableResaleProductId ~= ""
		end
	end

	if not (v3 or v) then
		return false, PurchaseError.NotForSale
	end

	if p2 ~= nil and p.robux ~= nil and p.robux < p2 then
		return false, PurchaseError.NotEnoughRobux
	end

	if data.itemRestrictions == nil then
		return true, nil
	end

	for _, itemRestriction in data.itemRestrictions do
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
