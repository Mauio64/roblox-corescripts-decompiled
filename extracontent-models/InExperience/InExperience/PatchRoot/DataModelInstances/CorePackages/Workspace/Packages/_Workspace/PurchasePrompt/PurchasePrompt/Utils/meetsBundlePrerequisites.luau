local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local PurchaseError = require(ParentParent.Enums.PurchaseError)

local function meetsBundlePrerequisites(p1, p2, n1: number?, p3, _: {[any]: any}?) -- line: 10
	-- upvalues: PurchaseError (copy), Players (copy)
	local collectibleItemDetail = p1.collectibleItemDetail
	local v11 = collectibleItemDetail and (collectibleItemDetail.collectibleItemId ~= nil and collectibleItemDetail.collectibleItemId ~= "")
	local v12 = collectibleItemDetail and (collectibleItemDetail.collectibleItemType ~= nil and collectibleItemDetail.collectibleItemType == "Limited")

	if v11 then
		if not v12 and p3 then
			return false, PurchaseError.AlreadyOwn
		end
	elseif p3 then
		return false, PurchaseError.AlreadyOwn
	end

	local v13 = if not v11 then p1.product and p1.product.isForSale else collectibleItemDetail.saleStatus == "OnSale"
	local v14 = v11 and (collectibleItemDetail.lowestAvailableResaleProductId ~= nil and collectibleItemDetail.lowestAvailableResaleProductId ~= "")

	if not v13 and not v14 then
		return false, PurchaseError.NotForSale
	end

	if n1 ~= nil and p2.robux ~= nil and n1 > p2.robux then
		return false, PurchaseError.NotEnoughRobux
	end

	if p1.itemRestrictions ~= nil then
		for _, v16 in p1.itemRestrictions do
			if v16 == "ThirteenPlus" then
				if not Players.LocalPlayer:GetUnder13() then
					return true, nil
				end

				return false, PurchaseError.Under13
			end
		end
	end

	return true, nil
end

return meetsBundlePrerequisites
