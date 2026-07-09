local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.Reducers.Looks)
require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.PurchasePrompt)

local v4 = game:DefineFastFlag("AXMISFixOpenLookDetailsModal", false)
local FFlagPurchasePromptFetchCartPricingForLooks = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPurchasePromptFetchCartPricingForLooks

local function getSelectedTimedOptionDays(p1, p2) -- line: 18
	if p2.selectedTimedOptionIndex and p1.timedOptions then
		local v13 = p1.timedOptions[p2.selectedTimedOptionIndex]

		if v13 and v13.days then
			return v13.days
		end
	end

	return nil
end
local function isBlockyLookItem(p3) -- line: 31
	-- upvalues: Constants (copy)
	return p3.itemId == tostring(Constants.BlockyBundleId)
end
local function shouldExcludeLookItem(p4, p5) -- line: 35
	return not p4.selectedInTryOnManager or (not p5.isPurchasable or p5.quantityOwned > 0)
end
local function getLookItemInfo(p6, p7) -- line: 39
	local v19 = p6.lookAssetInfos[tostring(p7.itemId)]
	local v20 = (p6.lookBundleInfos or {})[tostring(p7.itemId)]

	return v19 or v20
end
local function getCartPricingRequestedItemsForLookId(p8, p9, s1: string) -- line: 48
	-- upvalues: Constants (copy)
	local t1 = {}
	local t2 = {}
	local v26 = p9[s1]

	if p8 == nil or v26 == nil then
		return t1
	end

	local g33 = nil
	local days = nil

	for _, v28 in p8 do
		local v29 = v26.lookAssetInfos[tostring(v28.itemId)]
		local v30 = (v26.lookBundleInfos or {})[tostring(v28.itemId)]
		local v31 = v29 or v30

		if v31 == nil or v28.itemId == tostring(Constants.BlockyBundleId) or (not v28.selectedInTryOnManager or (not v31.isPurchasable or v31.quantityOwned > 0)) then
			continue
		end

		local collectibleItemId = v31.collectibleItemId

		if type(collectibleItemId) ~= "string" or collectibleItemId == "" then
			continue
		end

		repeat
			if not g33 and (v28.selectedTimedOptionIndex and v31.timedOptions) then
				local v34 = v31.timedOptions[v28.selectedTimedOptionIndex]

				if not v34 or not v34.days then
					g33 = true
				end

				if not g33 then
					days = v34.days
				end
			else
				g33 = false
				days = nil
			end
		until not g33

		local v36 = collectibleItemId .. "\000" .. ((type(days) ~= "number" or not (days > 0)) and "perm" or tostring(days))

		if not t2[v36] then
			t2[v36] = true
			table.insert(t1, {
				collectibleItemId = collectibleItemId,
				rentalDays = days
			})
		end
	end

	return t1
end

return {
	getPurchaseInfoForLookId = function(p10, p11, s2: string) -- line: 94
		-- upvalues: v4 (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), Constants (copy)
		local t3 = {}
		local t4 = {}
		local t5 = {}
		local t6 = {}
		local n1 = 0
		local v45 = p11[s2]

		if p10 == nil or v45 == nil then
			return n1, t3, t4, t5
		end

		local g53 = nil
		local g56 = nil

		for _, v47 in p10 do
			local v48 = v45.lookAssetInfos[tostring(v47.itemId)]
			local v49 = (v45.lookBundleInfos or {})[tostring(v47.itemId)]

			if not v4 then
				assert(v48 or v49, "itemInfo should not be nil")
			end

			local v50 = v48 or v49

			if v4 and not v50 then
				continue
			end

			if FFlagPurchasePromptFetchCartPricingForLooks then
				local v51 = v45.lookAssetInfos[tostring(v47.itemId)]
				local v52 = (v45.lookBundleInfos or {})[tostring(v47.itemId)]

				v50 = v51 or v52
			end

			if FFlagPurchasePromptFetchCartPricingForLooks and v47.itemId == tostring(Constants.BlockyBundleId) or not FFlagPurchasePromptFetchCartPricingForLooks and v47.itemId == tostring(Constants.BlockyBundleId) then
				continue
			end

			repeat
				if not g53 and FFlagPurchasePromptFetchCartPricingForLooks then
					if v47.selectedInTryOnManager and (v50.isPurchasable and not (v50.quantityOwned > 0)) then
						g53 = true
					end
				else
					g53 = false

					if FFlagPurchasePromptFetchCartPricingForLooks or v47.selectedInTryOnManager and v50.isPurchasable and not (v50.quantityOwned > 0) then
						local priceInRobux = v50.priceInRobux

						if v47.selectedTimedOptionIndex and v50.timedOptions then
							local v55 = v50.timedOptions[v47.selectedTimedOptionIndex]

							if v55 and v55.days then
								table.insert(t6, {
									itemType = v47.itemType,
									itemId = v47.itemId,
									days = v55.days
								})
								priceInRobux = v55.price
							end
						end

						n1 += priceInRobux
						table.insert(t5, (tonumber(v47.itemId)))
						g56 = true

						break
					end
				end
			until not g53

			if g56 then
				g56 = false

				continue
			end

			if v47.itemType == Constants.ItemType.Bundle then
				table.insert(t4, v47.itemId)
			elseif v47.itemType == Constants.ItemType.Asset then
				table.insert(t3, v47.itemId)
			end
		end

		if #t6 > 0 then
			return n1, t3, t4, t5, t6
		end

		return n1, t3, t4, t5, nil
	end,
	getCartPricingRequestedItemsForLookId = if not FFlagPurchasePromptFetchCartPricingForLooks then nil else getCartPricingRequestedItemsForLookId
}
