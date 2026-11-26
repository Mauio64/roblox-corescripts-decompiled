local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local SetSourceLanguageName = require("@game/CoreGui/RobloxGui/Modules/Feedback/Actions/SetSourceLanguageName")

local SetCollectibleResellableInstances = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetCollectibleResellableInstances")
local module5 = require("@luauforge/bundled/dQE")
local module6 = require("@luauforge/bundled/dQF")

local fetchCollectibleItemDataBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchCollectibleItemDataBatchedSuccess

return Rodux.createReducer({}, {
	[SetSourceLanguageName.name] = function(p2, p3)
		module.isType(p3.collectibleItemId, "string", "collectibleItemId must be a string.")
		module.isType(p3.collectibleItemData, "table", "collectibleItemData must be a table.")

		local collectibleItemId = p3.collectibleItemId
		local v6 = module6.fromGetCollectibleItemData(p3.collectibleItemData)

		local v7 = p2[collectibleItemId]

		if not v7 then
			return Cryo.Dictionary.join(p2, { [collectibleItemId] = v6 })
		end

		local joined = Cryo.Dictionary.join(v7, v6)
		return Cryo.Dictionary.join(p2, { [collectibleItemId] = joined })
	end,
	[SetCollectibleResellableInstances.name] = function(p2, p3)
		module.isType(p3.collectibleItemId, "string", "collectibleItemId must be a string.")
		module.isType(p3.collectibleItemInstances, "table", "collectibleItemData must be a table.")

		local collectibleItemId = p3.collectibleItemId
		local v6 = module6.fromGetResellers(p3.collectibleItemInstances)

		local v7 = p2[collectibleItemId]

		if not v7 then
			return Cryo.Dictionary.join(p2, { [collectibleItemId] = v6 })
		end

		local joined = Cryo.Dictionary.join(v7, v6)
		return Cryo.Dictionary.join(p2, { [collectibleItemId] = joined })
	end,
	[module5.name] = function(p2, p3)
		module.isType(p3.collectibleItemId, "string", "collectibleItemId must be a string.")
		module.isType(p3.resaleData, "table", "resaleData must be a table.")

		local collectibleItemId = p3.collectibleItemId
		local v6 = module6.fromGetResaleData(p3.resaleData)

		local v7 = p2[collectibleItemId]

		if not v7 then
			return Cryo.Dictionary.join(p2, { [collectibleItemId] = v6 })
		end

		local joined = Cryo.Dictionary.join(v7, v6)
		return Cryo.Dictionary.join(p2, { [collectibleItemId] = joined })
	end,
	[fetchCollectibleItemDataBatchedSuccess.name] = function(options, p2)
		local v6 = options or {}

		local values = {}

		for k, v7 in p2.collectibleItemData do
			local collectibleItemId = v7.collectibleItemId
			local v8 = module6.fromGetCollectibleItemData(v7)
			local v9 = v6[collectibleItemId] or {}
			values[collectibleItemId] = Cryo.Dictionary.join(v9, v8)
		end

		return Cryo.Dictionary.join(v6, values)
	end
})
