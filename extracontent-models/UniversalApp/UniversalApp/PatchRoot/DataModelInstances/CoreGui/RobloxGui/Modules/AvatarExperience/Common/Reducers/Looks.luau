local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local Dash = require(CorePackages.Packages.Dash)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local AddLookDetails = require(Modules.AvatarExperience.Common.Actions.AddLookDetails)
local SetLookFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetLookFavorite)
local UpdateLookDetails = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetails)
local UpdateLookDetailsAfterSuccessfulPurchase = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetailsAfterSuccessfulPurchase)
local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local GetFFlagEnableLookFavoriting = require(Modules.AvatarExperience.Flags.GetFFlagEnableLookFavoriting)

require(Modules.AvatarExperience.Common.Types)

local t1 = {}

local function getItemInfo(p1) -- line: 30
	local t2 = {}

	if p1 then
		for _, v17 in p1 do
			t2[tostring(v17.id)] = v17
		end
	end

	return t2
end

return Rodux.createReducer(t1, {
	[AddLookDetails.name] = function(t3: {[any]: any}?, p2) -- line: 43
		-- upvalues: t1 (copy), GetFFlagEnableLookFavoriting (copy), Cryo (copy)
		local v20 = t3 or t1
		local t4 = {}
		local lookId = p2.lookId
		local t5 = {
			lookType = p2.lookType,
			totalValue = p2.totalValue,
			totalPrice = p2.totalPrice,
			totalPremiumPrice = p2.totalPremiumPrice
		}
		local lookAssetInfos = p2.lookAssetInfos
		local t6 = {}

		if lookAssetInfos then
			for _, v27 in lookAssetInfos do
				t6[tostring(v27.id)] = v27
			end
		end

		t5.lookAssetInfos = t6

		local lookBundleInfos = p2.lookBundleInfos
		local t7 = {}

		if lookBundleInfos then
			for _, v31 in lookBundleInfos do
				t7[tostring(v31.id)] = v31
			end
		end

		t5.lookBundleInfos = t7
		t5.curator = p2.curator
		t5.description = p2.description
		t5.moderationStatus = p2.moderationStatus
		t5.name = p2.name
		t5.displayProperties = p2.displayProperties
		t5.favoriteCount = if not GetFFlagEnableLookFavoriting() then nil else p2.favoriteCount
		t5.isFavorited = if not GetFFlagEnableLookFavoriting() then nil else p2.isFavorited
		t5.lookDiscounts = p2.lookDiscounts
		t4[lookId] = t5

		return Cryo.Dictionary.join(v20, t4)
	end,
	[SetLookFavorite.name] = function(t8: {[any]: any}?, p3) -- line: 68
		-- upvalues: t1 (copy), Cryo (copy)
		local v34 = t8 or t1
		local v35 = v34[p3.lookId] or {}
		local t9 = {
			favoriteCount = v35.favoriteCount,
			isFavorited = p3.isFavorited
		}
		local v37 = Cryo.Dictionary.join(v35, t9)

		return Cryo.Dictionary.join(v34, {
			[p3.lookId] = v37
		})
	end,
	[UpdateLookDetails.name] = function(t10: {[any]: any}?, p4) -- line: 80
		-- upvalues: t1 (copy), Cryo (copy)
		local v40 = t10 or t1
		local v41 = v40[p4.lookId] or {}
		local v42 = Cryo.Dictionary.join(v41, p4.lookDetails)

		return Cryo.Dictionary.join(v40, {
			[p4.lookId] = v42
		})
	end,
	[UpdateLookDetailsAfterSuccessfulPurchase.name] = function(t11: {[any]: any}?, p5) -- line: 88
		-- upvalues: t1 (copy), Dash (copy), Cryo (copy)
		local v45 = t11 or t1
		local v46 = if not t11 then nil else t11[p5.lookId]

		if v46 == nil then
			return v45
		end

		assert(v46, "")

		local v47 = v46.totalPrice or 0
		local v48 = v46.totalPremiumPrice or 0
		local lookAssetInfos = v46.lookAssetInfos
		local lookBundleInfos = v46.lookBundleInfos

		if lookAssetInfos == nil then
			warn("Looks asset info does not exist")

			return v45
		end

		for _, v52 in p5.purchasedAssetIds do
			local str = tostring(v52)
			local v54 = lookAssetInfos[str]

			if v54 == nil then
				warn("Looks reducer could not find asset with id", str)
			else
				lookAssetInfos[str].quantityOwned = v54.quantityOwned + 1
				v47 -= v54.priceInRobux or 0
				v48 -= v54.premiumPriceInRobux or 0
			end
		end

		if lookBundleInfos and p5.purchasedBundleIds then
			for _, v56 in p5.purchasedBundleIds do
				local str = tostring(v56)
				local v58 = lookBundleInfos[str]

				if v58 == nil then
					warn("Looks reducer could not find bundle with id", str)
				else
					lookBundleInfos[str].quantityOwned = v58.quantityOwned + 1
					v47 -= v58.priceInRobux or 0
				end
			end
		end

		if v47 < 0 then
			warn("Looks total price is below 0 after manual calculation")
			v47 = 0
		end

		if v48 < 0 then
			warn("Looks total premium price is below 0 after manual calculation")
			v48 = 0
		end

		local t12 = {
			[p5.lookId] = {
				totalPrice = v47,
				totalPremiumPrice = v48,
				lookAssetInfos = lookAssetInfos,
				lookBundleInfos = lookBundleInfos
			}
		}
		local isOwnedAfterPurchase = p5.isOwnedAfterPurchase

		if isOwnedAfterPurchase then
			t12[p5.lookId].owned = isOwnedAfterPurchase
		end

		local v61 = t12[p5.lookId]
		local v62 = Dash.joinDeep(v46, v61)
		local t13 = {
			[p5.lookId] = v62
		}

		return Cryo.Dictionary.join(v45, t13)
	end,
	[RemoveLook.name] = function(t14: {[any]: any}?, p6) -- line: 180
		-- upvalues: t1 (copy)
		local v66 = t14 or t1
		local v67 = table.clone(v66)

		v67[p6.lookId] = nil

		return v67
	end
})
