local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local SetAssetInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromCatalogItemAction)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local FetchAssetResellers = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetResellers)
local AssetInfo = require(Modules.AvatarExperience.Common.Models.AssetInfo)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ReceivedBundleInfoForTryOn = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ReceivedBundleInfoForTryOn
local HandleTryOnFailure = require(Modules.AvatarExperience.Catalog.Thunks.HandleTryOnFailure)
local UpdateSortOrderDueToLCBundleLoaded = require(Modules.AvatarExperience.Catalog.Thunks.UpdateSortOrderDueToLCBundleLoaded)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local function keyMapper(p1) -- line: 41
	-- upvalues: CatalogUtils (copy)
	return CatalogUtils.GetBatchItemDetailsKey(p1)
end
local function processSuccessfulResult(p2, p3, _, p5, p6) -- line: 45
	-- upvalues: SetAssetInfoFromCatalogItemAction (copy), AssetInfo (copy), CatalogUtils (copy), FetchAssetResellers (copy), CatalogConstants (copy), getTryOnItemReducerKey (copy), Constants2 (copy), ReceivedBundleInfoForTryOn (copy), UpdateSortOrderDueToLCBundleLoaded (copy)
	local v30 = p5:getState()

	for _, v32 in p6 do
		local str = tostring(v32.id)

		p5:dispatch(SetAssetInfoFromCatalogItemAction(str, v32))

		local v34 = AssetInfo.fromGetCatalogItemData(v32)

		if CatalogUtils.IsResellable(v34) then
			p5:dispatch(FetchAssetResellers(p2, str, nil, CatalogConstants.MaxResellersPerPage))
		end
	end

	local v35 = getTryOnItemReducerKey(p3, Constants2.ItemType.Bundle)

	if v30.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[v35] then
		p5:dispatch(ReceivedBundleInfoForTryOn(p3))
		p5:dispatch(UpdateSortOrderDueToLCBundleLoaded(p3))
	end
end

return function(p7, p8, p9) -- line: 73
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogUtils (copy), Promise (copy), Utils (copy), processSuccessfulResult (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy), HandleTryOnFailure (copy)
	ArgCheck.isType(p9, "table", "FetchBundleAssetsDetails request expects itemIds")

	return function(p10, p11) -- line: 75
		-- upvalues: PerformFetch (copy), p9 (copy), CatalogUtils (copy), Promise (copy), Utils (copy), processSuccessfulResult (copy), p7 (copy), p8 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy), HandleTryOnFailure (copy)
		local avatarEditorService = p11.avatarEditorService
		local Single = PerformFetch.Single
		local v43 = p9

		return Single(CatalogUtils.GetBatchItemDetailsKey(v43), function(p12) -- line: 77
			-- upvalues: Promise (copy), avatarEditorService (copy), p9 (copy), Utils (copy), processSuccessfulResult (copy), p7 (copy), p8 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy), HandleTryOnFailure (copy)
			return Promise.new(function(resolve, reject) -- line: 78
				-- upvalues: avatarEditorService (copy), p9 (copy), Utils (copy), processSuccessfulResult (copy), p7 (copy), p8 (copy), p12 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy), HandleTryOnFailure (copy)
				local ok, result = pcall(function() -- line: 79
					-- upvalues: avatarEditorService (copy), p9 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return avatarEditorService:GetBatchItemDetailsAsync(p9, Enum.AvatarItemType.Asset)
					end

					return avatarEditorService:GetBatchItemDetails(p9, Enum.AvatarItemType.Asset)
				end)

				if ok then
					local v49 = Utils.tableToCamelCaseKeys(result)

					processSuccessfulResult(p7, p8, p9, p12, v49)
					resolve(v49)

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.GetBatchItemDetails)
				end

				Logging.warn("FetchBundleAssetsDetails failure: " .. tostring(result))
				p12:dispatch(HandleTryOnFailure(p8))
				reject()
			end)
		end)(p10)
	end
end
