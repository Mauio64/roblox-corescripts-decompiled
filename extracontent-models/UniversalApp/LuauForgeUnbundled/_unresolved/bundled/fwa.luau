local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dwM")
local Cryo = require(CorePackages.Packages.Cryo)
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fuD")
local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/bundled/dxy")
local Promise = require(CorePackages.Packages.Promise)

local module6 = require("@luauforge/bundled/fwb")
local module7 = require("@luauforge/bundled/fwh")
local module8 = require("@luauforge/bundled/fwj")

local function keyMapper(p2)
	return module4.FetchOutfitInfoFromBundleKey .. tostring(p2)
end

local function isBundleInfoFetching(p2, p3): boolean
	return performFetch.GetStatus(p2, module4.FetchBundleInfoKey .. tostring(p3)) == module5.Fetching
end

local function isOutfitInfoFetching(p2, p3): boolean
	return performFetch.GetStatus(p2, module2.OutfitInfoKey .. tostring(p3)) == module5.Fetching
end

local function shouldFetchBundleInfo(p2, p3): boolean
	local bundleInfo = p2.AvatarExperience.Common.BundleInfos[p3]

	if
		bundleInfo and bundleInfo.receivedCatalogData
		or performFetch.GetStatus(p2, module4.FetchBundleInfoKey .. tostring(p3)) == module5.Fetching
	then
		return false
	end

	return true
end

local function shouldFetchOutfitInfo(p2, p3): boolean
	local bundleInfo = p2.AvatarExperience.Common.BundleInfos[p3]

	if not (bundleInfo and bundleInfo.receivedCatalogData) then
		return false
	end

	local userOutfitIdFromBundle = module3.getUserOutfitIdFromBundle(bundleInfo)

	if
		p2.AvatarExperience.AvatarEditor.OutfitInfos[userOutfitIdFromBundle]
		or performFetch.GetStatus(p2, module2.OutfitInfoKey .. tostring(userOutfitIdFromBundle)) == module5.Fetching
	then
		return false
	end

	return true
end

return function(p2, p3)
	module.isType(p2, "function", "FetchOutfitInfoFromBundle thunk expects networkImpl to be a function")
	module.isType(p3, "string", "FetchOutfitInfoFromBundle thunk expects bundleId to be a string")

	return function(object)
		local state = object:getState()

		if performFetch.GetStatus(state, module4.FetchOutfitInfoFromBundleKey .. tostring(p3)) == module5.Fetching then
			return Promise.resolve()
		end

		return performFetch.Single(module4.FetchOutfitInfoFromBundleKey .. tostring(p3), function(object2)
			local v7 = object2:getState()

			local v8 = v7
			local v9 = p3
			local bundleInfo = v8.AvatarExperience.Common.BundleInfos[v9]
			local v10

			if bundleInfo and bundleInfo.receivedCatalogData then
				v10 = false
			else
				v10 = performFetch.GetStatus(v8, module4.FetchBundleInfoKey .. tostring(v9)) ~= module5.Fetching
			end

			if v10 then
				object2:dispatch(module8(p3)):andThen(function(p4)
					v7 = object2:getState()

					local bundleInfo2 = v7.AvatarExperience.Common.BundleInfos[p3]
					local v11 = module3.getUserOutfitIdsFromBundle(bundleInfo2) or {}

					if Cryo.isEmpty(v11) then
						local ids = {}

						if bundleInfo2.items then
							for k, item in bundleInfo2.items do
								if item.type == module2.ItemType.Asset then
									table.insert(ids, (tonumber(item.id)))
								end
							end
						end

						object2:dispatch(module7(p2, p3, ids))
					else
						for k, v12 in v11 do
							local v13 = v7

							if performFetch.GetStatus(v13, module2.OutfitInfoKey .. tostring(v12)) == module5.Fetching then
								continue
							end

							object2:dispatch(module6(v12, nil, p3))
						end
					end

					return Promise.resolve()
				end)
			else
				local v11 = v7
				local bundleInfo2 = v11.AvatarExperience.Common.BundleInfos[p3]
				local v13

				if bundleInfo2 and bundleInfo2.receivedCatalogData then
					local userOutfitIdFromBundle = module3.getUserOutfitIdFromBundle(bundleInfo2)

					if v11.AvatarExperience.AvatarEditor.OutfitInfos[userOutfitIdFromBundle] then
						v13 = false
					else
						v13 = performFetch.GetStatus(
							v11,
							module2.OutfitInfoKey .. tostring(userOutfitIdFromBundle)
						) ~= module5.Fetching
					end
				else
					v13 = false
				end

				if v13 then
					local bundleInfo3 = v7.AvatarExperience.Common.BundleInfos[p3]
					local userOutfitIdsFromBundle = module3.getUserOutfitIdsFromBundle(bundleInfo3)

					for k, v14 in userOutfitIdsFromBundle do
						object2:dispatch(module6(v14, nil, p3))
					end
				end
			end

			return Promise.resolve()
		end)(object)
	end
end
