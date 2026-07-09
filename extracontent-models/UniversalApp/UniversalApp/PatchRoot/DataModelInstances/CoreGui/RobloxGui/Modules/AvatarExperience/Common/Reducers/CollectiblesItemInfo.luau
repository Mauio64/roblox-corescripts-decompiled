local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local SetCollectibleItemInfo = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleItemInfo)
local SetCollectibleResellersInstances = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResellersInstances)
local SetCollectibleResaleData = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResaleData)
local CollectibleInfo = require(Modules.AvatarExperience.Common.Models.CollectibleInfo)
local FetchCollectibleItemDataBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchCollectibleItemDataBatchedSuccess
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping

return Rodux.createReducer({}, {
	[SetCollectibleItemInfo.name] = function(t1: {[any]: any}, p1) -- line: 23
		-- upvalues: ArgCheck (copy), CollectibleInfo (copy), Cryo (copy)
		ArgCheck.isType(p1.collectibleItemId, "string", "collectibleItemId must be a string.")
		ArgCheck.isType(p1.collectibleItemData, "table", "collectibleItemData must be a table.")

		local collectibleItemId = p1.collectibleItemId
		local v17 = CollectibleInfo.fromGetCollectibleItemData(p1.collectibleItemData)
		local v18 = t1[collectibleItemId]

		if v18 then
			local v19 = Cryo.Dictionary.join(v18, v17)

			return Cryo.Dictionary.join(t1, {
				[collectibleItemId] = v19
			})
		end

		return Cryo.Dictionary.join(t1, {
			[collectibleItemId] = v17
		})
	end,
	[SetCollectibleResellersInstances.name] = function(t2: {[any]: any}, p2) -- line: 39
		-- upvalues: ArgCheck (copy), CollectibleInfo (copy), Cryo (copy)
		ArgCheck.isType(p2.collectibleItemId, "string", "collectibleItemId must be a string.")
		ArgCheck.isType(p2.collectibleItemInstances, "table", "collectibleItemData must be a table.")

		local collectibleItemId = p2.collectibleItemId
		local v23 = CollectibleInfo.fromGetResellers(p2.collectibleItemInstances)
		local v24 = t2[collectibleItemId]

		if v24 then
			local v25 = Cryo.Dictionary.join(v24, v23)

			return Cryo.Dictionary.join(t2, {
				[collectibleItemId] = v25
			})
		end

		return Cryo.Dictionary.join(t2, {
			[collectibleItemId] = v23
		})
	end,
	[SetCollectibleResaleData.name] = function(t3: {[any]: any}, p3) -- line: 55
		-- upvalues: ArgCheck (copy), CollectibleInfo (copy), Cryo (copy)
		ArgCheck.isType(p3.collectibleItemId, "string", "collectibleItemId must be a string.")
		ArgCheck.isType(p3.resaleData, "table", "resaleData must be a table.")

		local collectibleItemId = p3.collectibleItemId
		local v29 = CollectibleInfo.fromGetResaleData(p3.resaleData)
		local v30 = t3[collectibleItemId]

		if v30 then
			local v31 = Cryo.Dictionary.join(v30, v29)

			return Cryo.Dictionary.join(t3, {
				[collectibleItemId] = v31
			})
		end

		return Cryo.Dictionary.join(t3, {
			[collectibleItemId] = v29
		})
	end,
	[FetchCollectibleItemDataBatchedSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(t4: {[any]: any}, p4) -- line: 72
		-- upvalues: CollectibleInfo (copy), Cryo (copy)
		local v34 = t4 or {}
		local t5 = {}

		for _, v37 in p4.collectibleItemData do
			local collectibleItemId = v37.collectibleItemId
			local v39 = CollectibleInfo.fromGetCollectibleItemData(v37)
			local v40 = v34[collectibleItemId] or {}

			t5[collectibleItemId] = Cryo.Dictionary.join(v40, v39)
		end

		return Cryo.Dictionary.join(v34, t5)
	end
})
