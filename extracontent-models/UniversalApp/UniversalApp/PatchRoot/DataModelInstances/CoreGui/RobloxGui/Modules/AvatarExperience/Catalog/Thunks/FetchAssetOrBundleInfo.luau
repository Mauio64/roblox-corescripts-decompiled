local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetBundleInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromCatalogItemAction)
local SetAssetInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromCatalogItemAction)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetAssetInfoFromBundleItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromBundleItemAction)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local FetchAssetResellers = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetResellers)
local FetchCollectibleItemData = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleItemData)
local FetchCollectibResellersInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibResellersInstances)
local FetchCollectibleResaleData = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResaleData)
local FetchCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResellableInstances)
local AssetInfo = require(Modules.AvatarExperience.Common.Models.AssetInfo)
local BundleInfo = require(Modules.AvatarExperience.Common.Models.BundleInfo)

require(Modules.AvatarExperience.Common.Types)
require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FVariable = settings():GetFVariable("LuaAppsPageLoadTimeItemDetails")

local function keyMapper(p1, p2) -- line: 51
	-- upvalues: CatalogUtils (copy)
	return CatalogUtils.GetItemDetailsKey(p1, p2)
end
local function checkIfReceivedFromBundleItemData(p3, p4) -- line: 55
	local v33 = p3.AvatarExperience.Common.AssetInfos[p4]

	if v33 and v33.receivedFromBundleItemData then
		return true
	end

	return false
end
local function v27(p5, p6, p7, p8) -- line: 63
	-- upvalues: FetchCollectibleItemData (copy), FetchCollectibleResellableInstances (copy), FetchCollectibResellersInstances (copy), CatalogConstants (copy), FetchCollectibleResaleData (copy), Promise (copy)
	local t1 = { p5:dispatch(FetchCollectibleItemData(p6, p7)) }
	local LocalUserId = p5:getState().LocalUserId

	table.insert(t1, p5:dispatch(FetchCollectibleResellableInstances(p6, p7, LocalUserId)))

	if p8 then
		table.insert(t1, p5:dispatch(FetchCollectibResellersInstances(p6, p7, nil, CatalogConstants.MaxResellersPerPage)))
		table.insert(t1, p5:dispatch(FetchCollectibleResaleData(p6, p7)))
	end

	return Promise.all(t1)
end
local function processSuccessfulResult(p9, p10, p11, p12, p13) -- line: 91
	-- upvalues: Constants (copy), SetBundleInfoFromCatalogItemAction (copy), SetAssetInfoFromBundleItemAction (copy), BundleInfo (copy), v27 (copy), SetAssetInfoFromCatalogItemAction (copy), AssetInfo (copy), CatalogUtils (copy), FetchAssetResellers (copy), CatalogConstants (copy)
	local v45 = p12:getState()

	if p11 == Constants.ItemType.Bundle then
		p12:dispatch(SetBundleInfoFromCatalogItemAction(p10, p13))

		local t2 = {}

		if p13.bundledItems then
			for _, v48 in p13.bundledItems do
				local str = tostring(v48.id)

				if v48.Type == Constants.ItemType.Asset then
					local v50 = v45.AvatarExperience.Common.AssetInfos[str]

					if not v50 or not v50.receivedFromBundleItemData then
						table.insert(t2, v48)
					end
				end
			end

			if #t2 > 0 then
				p12:dispatch(SetAssetInfoFromBundleItemAction(t2))
			end
		end

		local v51 = BundleInfo.fromGetCatalogItemData(p13)
		local collectibleItemId = v51.collectibleItemId
		local hasResellers = v51.hasResellers

		if collectibleItemId then
			v27(p12, p9, collectibleItemId, hasResellers)

			return
		end
	elseif p11 == Constants.ItemType.Asset then
		p12:dispatch(SetAssetInfoFromCatalogItemAction(p10, p13))

		local v54 = AssetInfo.fromGetCatalogItemData(p13)
		local v55 = CatalogUtils.IsResellable(v54)
		local collectibleItemId = v54.collectibleItemId
		local hasResellers = v54.hasResellers

		if collectibleItemId then
			v27(p12, p9, collectibleItemId, hasResellers)

			return
		end

		if v55 then
			p12:dispatch(FetchAssetResellers(p9, p10, nil, CatalogConstants.MaxResellersPerPage))
		end
	end
end

return function(p14, p15, p16, p17, b1: boolean?) -- line: 138
	-- upvalues: ArgCheck (copy), Constants (copy), PerformFetch (copy), CatalogUtils (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXInventoryDurablesSupport (copy), v27 (copy), FetchAssetResellers (copy), CatalogConstants (copy), Promise (copy), WebApi (copy), processSuccessfulResult (copy), Logging (copy), FVariable (copy)
	ArgCheck.isType(p16, "string", "FetchAssetOrBundleInfo request expects itemId")
	ArgCheck.isType(p17, "string", "FetchAssetOrBundleInfo request expects itemType")

	return function(p18, _) -- line: 142
		-- upvalues: p17 (copy), Constants (copy), p16 (copy), PerformFetch (copy), CatalogUtils (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXInventoryDurablesSupport (copy), b1 (copy), v27 (copy), p14 (copy), FetchAssetResellers (copy), CatalogConstants (copy), Promise (copy), WebApi (copy), processSuccessfulResult (copy), Logging (copy), p15 (copy), FVariable (copy)
		local timestamp = tick()
		local v66 = p18:getState()
		local u67 = nil

		if p17 == Constants.ItemType.Asset then
			u67 = v66.AvatarExperience.Common.AssetInfos[p16]
		elseif p17 == Constants.ItemType.Bundle then
			u67 = v66.AvatarExperience.Common.BundleInfos[p16]
		end

		local u68 = u67 and u67.collectibleItemId
		local Single = PerformFetch.Single
		local v70 = p16
		local v71 = p17

		return Single(CatalogUtils.GetItemDetailsKey(v70, v71), function(p20) -- line: 155
			-- upvalues: u67 (ref), FFlagAXMISEnableMultiShopping (copy), FFlagAXInventoryDurablesSupport (copy), b1 (copy), u68 (ref), v27 (copy), p14 (copy), CatalogUtils (copy), FetchAssetResellers (copy), p16 (copy), CatalogConstants (copy), Promise (copy), WebApi (copy), p17 (copy), processSuccessfulResult (copy), Logging (copy), p15 (copy), timestamp (copy), FVariable (copy)
			local v73 = u67 ~= nil and u67.receivedCatalogData

			if FFlagAXMISEnableMultiShopping or FFlagAXInventoryDurablesSupport then
				v73 = u67 ~= nil and (u67.receivedCatalogData and not b1)
			end

			if v73 then
				if u68 then
					local hasResellers = u67.hasResellers

					return v27(p20, p14, u68, hasResellers)
				end

				if CatalogUtils.IsResellable(u67) then
					return p20:dispatch(FetchAssetResellers(p14, p16, nil, CatalogConstants.MaxResellersPerPage))
				end

				return Promise.resolve()
			end

			return WebApi.FetchItemDetail(p14, p16, p17):andThen(function(p21) -- line: 177
				-- upvalues: processSuccessfulResult (copy), p14 (copy), p16 (copy), p17 (copy), p20 (copy)
				local v76 = p21.responseBody or {}

				processSuccessfulResult(p14, p16, p17, p20, v76)
			end):catch(function(p22) -- line: 181
				-- upvalues: Logging (copy)
				Logging.warn("FetchAssetOrBundleInfo failure: " .. p22)
			end):finally(function() -- line: 184
				-- upvalues: p15 (copy), timestamp (copy), FVariable (copy)
				if p15 and p15.Diag then
					local v78 = (tick() - timestamp) * 1000

					p15.Diag:reportStats(FVariable, v78)
				end
			end)
		end)(p18)
	end
end
