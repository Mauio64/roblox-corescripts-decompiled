local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.Reducers.Looks)
require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesItemInfo)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellersInstances)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellableInstances)

local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local v8 = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = require(CorePackages.Workspace.Packages.SharedFlags).FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = require(CorePackages.Workspace.Packages.SharedFlags).FIntBlackbirdUpsellMaxPriceForDiscountInclusive
local t1 = {
	getItemInfo = function(s1: string, p1, p2, s2: string?) -- line: 31
		-- upvalues: Constants (copy)
		if not p2 or not s2 then
			return nil
		end

		local v16 = p2[s2]

		if not v16 then
			return nil
		end

		if p1 == Constants.ItemType.Asset then
			return v16.lookAssetInfos[s1]
		end

		if p1 == Constants.ItemType.Bundle then
			local lookBundleInfos = v16.lookBundleInfos

			if lookBundleInfos then
				return lookBundleInfos[s1]
			end

			return nil
		end

		return nil
	end
}

function t1.getOwnedTryOnItems(p3, p4, s3: string?) -- line: 60
	-- upvalues: t1 (copy)
	local t2 = {}

	for v22, v23 in p3 do
		if v23.selectedInTryOnManager then
			local v24 = t1.getItemInfo(v23.itemId, v23.itemType, p4, s3)

			if v24 and v24.quantityOwned > 0 then
				t2[v22] = v23
			end
		end
	end

	return t2
end
function t1.getPriceForItem(p5, p6, p7, p8, n1: number?) -- line: 83
	-- upvalues: CatalogUtils (copy)
	local priceInRobux = p5.priceInRobux

	if n1 and p5.timedOptions then
		local v31 = p5.timedOptions[n1]

		if v31 then
			priceInRobux = v31.price
		end
	end

	if p5.collectibleItemId then
		local v32 = CatalogUtils.findCheapestCollectiblePurchaseInfoV2(p5.collectibleItemId, CatalogUtils.IsResellable(p5), p6, p7, p8)

		if v32.price then
			priceInRobux = v32.price
		end
	end

	return priceInRobux
end

if FFlagAXMISEnableMultiShopping then
	function t1.getBottomBarInfoMIS(p9, p10, p11, p12, p13, s4: string?, p14) -- line: 118
		-- upvalues: v8 (copy), t1 (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), Cryo (copy)
		local n2 = 0
		local n3 = 0
		local n4 = 0
		local n5 = 0
		local v44 = false
		local t3 = {}
		local v46 = false
		local v47 = false

		if not s4 then
			local v48 = nil

			if v8 then
				return n4, n2, n3, v44, v48, n5, false
			end

			return n4, n2, n3, v44, v48, n5, nil
		end

		for _, v50 in p9 do
			n2 += 1

			local v51 = t1.getItemInfo(v50.id, v50.itemType, p13, s4)

			if not v51 then
				if not v44 then
					v44 = true
				end
			elseif not v51 or not v51.quantityOwned or not (v51.quantityOwned > 0) then
				local selectedTimedOptionIndex = nil
				local v53 = nil

				if p14 then
					for _, v55 in p14 do
						if v55.itemId == v50.id and v55.itemType == v50.itemType then
							v53 = v55
							selectedTimedOptionIndex = v55.selectedTimedOptionIndex

							break
						end
					end
				end

				local v56 = t1.getPriceForItem(v51, p10, p11, p12, selectedTimedOptionIndex)

				if v56 ~= nil then
					n4 += v56
					n3 += 1

					local v57 = if not v51 or not v51.discountInformation then v56 else v51.discountInformation.originalPrice
					local v58 = FIntBlackbirdUpsellMaxPriceForDiscountInclusive
					local v59 = v57 <= FIntBlackbirdUpsellMinPriceForDiscountInclusive or v58 ~= 0 and v58 <= v57

					if v51 and v51.discountInformation and not v59 then
						v46 = true
					else
						v47 = true
					end

					n5 = if not v51 or not v51.discountInformation then n5 + v56 else n5 + v51.discountInformation.originalPrice

					if v53 then
						t3[v50.id] = Cryo.Dictionary.join(v53, {
							expectedPrice = v56
						})
					end
				end
			end
		end

		if v8 then
			return n4, n2, n3, v44, t3, n5, v46 and v47
		end

		return n4, n2, n3, v44, t3, n5, nil
	end
	function t1.getOwnedItemsInLook(t4: {[any]: any}, p15, s5: string?) -- line: 235
		-- upvalues: t1 (copy)
		local t5 = {}

		for v64, v65 in t4 do
			local v66 = if not v65.itemType then nil else t1.getItemInfo(v65.id, v65.itemType, p15, s5)

			if v66 and v66.quantityOwned > 0 then
				t5[v64] = v65
			end
		end

		return t5
	end
end

return t1
