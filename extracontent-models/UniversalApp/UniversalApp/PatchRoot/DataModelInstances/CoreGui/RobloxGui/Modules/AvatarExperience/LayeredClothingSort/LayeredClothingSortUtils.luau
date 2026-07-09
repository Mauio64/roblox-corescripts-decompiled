local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AssetMetadata = require(Modules.AvatarExperience.Common.Models.AssetMetadata)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(Modules.AvatarExperience.Common.Types)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local FFlagFixLayeredSorting = AvatarExperienceFlags.FFlagFixLayeredSorting
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport

return {
	createAssetIdToOrderMapping = memoize(function(t1: {[any]: any}) -- line: 35
		local t2 = {}

		for v16, v17 in t1 do
			t2[v17.id] = {
				order = #t1 - v16,
				assetTypeId = v17.typeId
			}
		end

		return t2
	end),
	formatForSetOrder = memoize(function(t3: {[any]: any}, p1) -- line: 50
		if not p1 then
			return nil
		end

		local t4 = {}

		for v21, v22 in t3 do
			if p1[v22.typeId] and p1[v22.typeId][v22.id] or v22.equipped then
				t4[v22.id] = {
					order = #t3 - v21,
					assetTypeId = v22.typeId
				}
			end
		end

		return t4
	end),
	formatForSetOrderWithTryOns = memoize(function(t5: {[any]: any}, p2, p3, _) -- line: 72
		-- upvalues: getTryOnItemReducerKey (copy), Constants (copy)
		if not p2 then
			return nil
		end

		local t6 = {}
		local t7 = {}

		for v29, v30 in t5 do
			local v31 = getTryOnItemReducerKey(v30.id, Constants.ItemType.Asset)

			if p2[v30.typeId] and p2[v30.typeId][v30.id] or v30.equipped then
				t6[v30.id] = {
					order = #t5 - v29,
					assetTypeId = v30.typeId
				}
			elseif p3 and p3[v31] then
				t7[v30.id] = #t5 - v29
			else
				assert(p3 ~= nil, "tryOnItems should not be nil")

				for _, v33 in p3 do
					if v33.bundleInfo and v33.bundleInfo[v30.id] then
						t7[v30.id] = #t5 - v29

						break
					end
				end
			end
		end

		return t6, t7
	end),
	formatForEquipOutfit = memoize(function(t8: {[any]: any}, p5) -- line: 123
		-- upvalues: AssetMetadata (copy)
		if not p5 then
			return nil
		end

		local t9 = {}

		for v37, v38 in t8 do
			if p5[v38.typeId] and p5[v38.typeId][v38.id] or v38.equipped then
				local v39 = AssetMetadata.getDefaultMetadata(v38.typeId)

				v39.order = #t8 - v37
				t9[v38.typeId] = {
					[v38.id] = v39
				}
			end
		end

		return t9
	end),
	getTableAndOrderAfterEquippingIntoSort = memoize(function(t10: {[any]: any}, t11: {[any]: any}) -- line: 157
		-- upvalues: Constants (copy), mutedError (copy), FFlagFixLayeredSorting (copy)
		if not Constants.LayeredClothingOrder[t11.typeId] then
			return t10, 0
		end

		local n1 = 0
		local n2 = 0

		for v44, v45 in t10 do
			if Constants.LayeredClothingOrder[v45.typeId] == nil then
				mutedError(`getTableAndOrderAfterEquippingIntoSort could not find in layeredClothingOrder typeId: { v45.typeId } assetId: { v45.id }`)
			end

			if v45.typeId == t11.typeId then
				n1 = v44

				if not FFlagFixLayeredSorting or v45.id ~= t11.id then
					continue
				end

				table.remove(t10, n1)

				return t10, (math.max(0, n1 - 1))
			end

			if n1 == 0 and Constants.LayeredClothingOrder[v45.typeId] > Constants.LayeredClothingOrder[t11.typeId] then
				n2 = v44
			end
		end

		local n3 = 1

		if n1 > 0 then
			n3 = n1
		elseif n2 > 0 then
			n3 = n2 + 1
		end

		table.insert(t10, n3, t11)

		return t10, #t10 - n3
	end),
	getSortedEquippedLCIfNoDefault = memoize(function(p6) -- line: 208
		-- upvalues: FFlagAXCustomizeMakeupSupport (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), Constants (copy)
		if not p6 then
			return nil
		end

		local t12 = {}
		local t13 = {}
		local v50 = true

		for v51, v52 in p6 do
			if not FFlagAXCustomizeMakeupSupport or not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v51] then
				for v53, v54 in v52 do
					if v54.order and v54.order ~= Constants.LayeredClothingOrder[v51] then
						v50 = false
					end

					if v54.isLayered then
						t12[v53] = v54.order or Constants.LayeredClothingOrder[v51]
						table.insert(t13, {
							id = v53,
							typeId = v51
						})
					end
				end
			end
		end

		if v50 then
			return nil
		end

		table.sort(t13, function(p7, p8) -- line: 244
			-- upvalues: t12 (copy)
			return t12[p7.id] > t12[p8.id]
		end)

		return t13
	end)
}
