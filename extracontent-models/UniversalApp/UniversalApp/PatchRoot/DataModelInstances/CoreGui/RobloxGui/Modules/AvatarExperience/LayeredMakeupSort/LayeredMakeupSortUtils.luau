local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AssetMetadata = require(Modules.AvatarExperience.Common.Models.AssetMetadata)

require(Modules.AvatarExperience.Common.Types)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS

return {
	getEquippedAssetsBasedOnSortTable = function(t1: {[any]: any}, p1, p2, t2: {[any]: any}?) -- line: 30
		-- upvalues: AssetMetadata (copy), Cryo (copy), getTryOnItemReducerKey (copy), Constants (copy)
		if not p1 then
			return {}
		end

		local t3 = {}

		for v16, v17 in t1 do
			if p1[v17.typeId] and p1[v17.typeId][v17.id] then
				local v18 = AssetMetadata.getDefaultMetadata(v17.typeId)

				v18.order = #t1 - v16
				t3[v17.typeId] = Cryo.Dictionary.join(t3[v17.typeId] or {}, {
					[v17.id] = v18
				})
			end

			if t2 then
				for v19, v20 in t2 do
					if v19 == v17.id and not p2[getTryOnItemReducerKey(v19, Constants.ItemType.Asset)] then
						local v21 = AssetMetadata.getDefaultMetadata(v20)

						v21.order = #t1 - v16
						t3[v17.typeId] = Cryo.Dictionary.join(t3[v17.typeId] or {}, {
							[v17.id] = v21
						})
					end
				end
			end
		end

		return t3
	end,
	getTryOnItemsOrderBasedOnSortTable = function(t4: {[any]: any}, p3) -- line: 73
		-- upvalues: getTryOnItemReducerKey (copy), Constants (copy)
		if not p3 then
			return {}
		end

		local t5 = {}

		for v25, v26 in t4 do
			if p3[getTryOnItemReducerKey(v26.id, Constants.ItemType.Asset)] then
				t5[v26.id] = #t4 - v25
			end
		end

		return t5
	end,
	getTableAndOrderAfterEquippingIntoSort = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 98
		-- upvalues: LAYERED_MAKEUP_ORDER (copy), MAX_MAKEUP_LAYERS (copy)
		if not LAYERED_MAKEUP_ORDER[t7.typeId] then
			return t6, 0
		end

		table.insert(t6, 1, t7)

		if #t6 > MAX_MAKEUP_LAYERS then
			t6 = { table.unpack(t6, 1, MAX_MAKEUP_LAYERS) }
		end

		return t6, #t6
	end,
	getSortedEquippedLayeredMakeup = function(p4) -- line: 117
		-- upvalues: Constants (copy), LAYERED_MAKEUP_ORDER (copy)
		if not p4 then
			return nil
		end

		local t8 = {}
		local t9 = {}

		for v32, v33 in p4 do
			if not Constants.LayeredClothingOrder[v32] then
				for v34, v35 in v33 do
					if v35.isLayered then
						t8[v34] = v35.order or LAYERED_MAKEUP_ORDER[v32]
						table.insert(t9, {
							id = v34,
							typeId = v32
						})
					end
				end
			end
		end

		table.sort(t9, function(p5, p6) -- line: 144
			-- upvalues: t8 (copy)
			return t8[p5.id] > t8[p6.id]
		end)

		return t9
	end
}
