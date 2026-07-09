local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Promise = require(CorePackages.Packages.Promise)
local GetOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfit)
local FetchBundleAssetsDetails = require(Modules.AvatarExperience.Catalog.Thunks.FetchBundleAssetsDetails)
local FetchBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchBundleInfo)
local v14 = game:DefineFastFlag("AXFixBundleOutfitFetchForShoes", false)

local function keyMapper(p1) -- line: 23
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchOutfitInfoFromBundleKey .. tostring(p1)
end
local function isBundleInfoFetching(p2, p3) -- line: 27
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), RetrievalStatus (copy)
	return PerformFetch.GetStatus(p2, CatalogConstants.FetchBundleInfoKey .. tostring(p3)) == RetrievalStatus.Fetching
end
local function isOutfitInfoFetching(p4, p5) -- line: 32
	-- upvalues: PerformFetch (copy), Constants (copy), RetrievalStatus (copy)
	return PerformFetch.GetStatus(p4, Constants.OutfitInfoKey .. tostring(p5)) == RetrievalStatus.Fetching
end
local function shouldFetchBundleInfo(p6, p7) -- line: 37
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), RetrievalStatus (copy)
	local v27 = p6.AvatarExperience.Common.BundleInfos[p7]

	if v27 and v27.receivedCatalogData or PerformFetch.GetStatus(p6, CatalogConstants.FetchBundleInfoKey .. tostring(p7)) == RetrievalStatus.Fetching then
		return false
	end

	return true
end
local function shouldFetchOutfitInfo(p8, p9) -- line: 46
	-- upvalues: v14 (copy), Utils (copy), PerformFetch (copy), Constants (copy), RetrievalStatus (copy)
	local v30 = p8.AvatarExperience.Common.BundleInfos[p9]

	if v30 and v30.receivedCatalogData then
		if not v14 and Utils.isShoeBundle(v30) then
			return false
		end

		local v31 = Utils.getUserOutfitIdFromBundle(v30)

		if p8.AvatarExperience.AvatarEditor.OutfitInfos[v31] or PerformFetch.GetStatus(p8, Constants.OutfitInfoKey .. tostring(v31)) == RetrievalStatus.Fetching then
			return false
		end

		return true
	end

	return false
end

return function(p10, p11) -- line: 67
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), RetrievalStatus (copy), Promise (copy), FetchBundleInfo (copy), v14 (copy), Utils (copy), Cryo (copy), Constants (copy), GetOutfit (copy), FetchBundleAssetsDetails (copy), shouldFetchOutfitInfo (copy)
	ArgCheck.isType(p10, "function", "FetchOutfitInfoFromBundle thunk expects networkImpl to be a function")
	ArgCheck.isType(p11, "string", "FetchOutfitInfoFromBundle thunk expects bundleId to be a string")

	return function(p12) -- line: 71
		-- upvalues: PerformFetch (copy), p11 (copy), CatalogConstants (copy), RetrievalStatus (copy), Promise (copy), FetchBundleInfo (copy), v14 (copy), Utils (copy), Cryo (copy), Constants (copy), GetOutfit (copy), FetchBundleAssetsDetails (copy), p10 (copy), shouldFetchOutfitInfo (copy)
		local v35 = p12:getState()
		local GetStatus = PerformFetch.GetStatus
		local v37 = p11

		if GetStatus(v35, CatalogConstants.FetchOutfitInfoFromBundleKey .. tostring(v37)) == RetrievalStatus.Fetching then
			return Promise.resolve()
		end

		local Single = PerformFetch.Single
		local v39 = p11

		return Single(CatalogConstants.FetchOutfitInfoFromBundleKey .. tostring(v39), function(p13) -- line: 78
			-- upvalues: p11 (copy), PerformFetch (copy), CatalogConstants (copy), RetrievalStatus (copy), FetchBundleInfo (copy), v14 (copy), Utils (copy), Cryo (copy), Constants (copy), GetOutfit (copy), FetchBundleAssetsDetails (copy), p10 (copy), shouldFetchOutfitInfo (copy), Promise (copy)
			local u41 = p13:getState()
			local v42 = u41
			local v43 = p11
			local v44 = v42.AvatarExperience.Common.BundleInfos[v43]

			if (not v44 or not v44.receivedCatalogData) and PerformFetch.GetStatus(v42, CatalogConstants.FetchBundleInfoKey .. tostring(v43)) ~= RetrievalStatus.Fetching then
				p13:dispatch(FetchBundleInfo(p11)):andThen(function(_) -- line: 82
					-- upvalues: u41 (ref), p13 (copy), v14 (copy), p11 (copy), Utils (copy), Cryo (copy), PerformFetch (copy), Constants (copy), RetrievalStatus (copy), GetOutfit (copy), FetchBundleAssetsDetails (copy), p10 (copy), shouldFetchOutfitInfo (copy), Promise (copy)
					u41 = p13:getState()

					if v14 then
						local v49 = u41.AvatarExperience.Common.BundleInfos[p11]
						local v50 = Utils.getUserOutfitIdsFromBundle(v49) or {}

						if not Cryo.isEmpty(v50) then
							for _, v52 in v50 do
								local v53 = u41

								if PerformFetch.GetStatus(v53, Constants.OutfitInfoKey .. tostring(v52)) ~= RetrievalStatus.Fetching then
									p13:dispatch(GetOutfit(v52, nil, p11))
								end
							end
						else
							local t1 = {}

							if v49.items then
								for _, v56 in v49.items do
									if v56.type == Constants.ItemType.Asset then
										table.insert(t1, (tonumber(v56.id)))
									end
								end
							end

							p13:dispatch(FetchBundleAssetsDetails(p10, p11, t1))
						end
					elseif shouldFetchOutfitInfo(u41, p11) then
						local v57 = u41.AvatarExperience.Common.BundleInfos[p11]

						for _, v59 in (Utils.getUserOutfitIdsFromBundle(v57)) do
							p13:dispatch(GetOutfit(v59, nil, p11))
						end
					else
						local v60 = u41.AvatarExperience.Common.BundleInfos[p11]
						local v61 = Utils.getUserOutfitIdsFromBundle(v60)

						if Cryo.isEmpty(v61) then
							local t2 = {}

							if v60.items then
								for _, v64 in v60.items do
									table.insert(t2, (tonumber(v64.id)))
								end
							end

							p13:dispatch(FetchBundleAssetsDetails(p10, p11, t2))
						end
					end

					return Promise.resolve()
				end)
			elseif shouldFetchOutfitInfo(u41, p11) then
				local v45 = u41.AvatarExperience.Common.BundleInfos[p11]

				for _, v47 in (Utils.getUserOutfitIdsFromBundle(v45)) do
					p13:dispatch(GetOutfit(v47, nil, p11))
				end
			end

			return Promise.resolve()
		end)(p12)
	end
end
