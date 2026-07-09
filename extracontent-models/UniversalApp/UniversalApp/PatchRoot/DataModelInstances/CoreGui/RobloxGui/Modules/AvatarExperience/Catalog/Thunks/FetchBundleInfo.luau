local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetAssetInfoFromBundleItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromBundleItemAction)
local HandleTryOnFailure = require(Modules.AvatarExperience.Catalog.Thunks.HandleTryOnFailure)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SetBundleInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromCatalogItemAction)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function keyMapper(p1) -- line: 28
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchBundleInfoKey .. tostring(p1)
end
local function checkAssetExists(p2, p3) -- line: 32
	local v21 = p2.AvatarExperience.Common.AssetInfos[p3]

	if v21 and v21.receivedFromBundleItemData then
		return true
	end

	return false
end
local function processSuccessfulResult(p4, p5, p6) -- line: 42
	-- upvalues: Constants (copy), SetAssetInfoFromBundleItemAction (copy), SetBundleInfoFromCatalogItemAction (copy)
	if p6.bundledItems then
		local v25 = p4:getState()
		local t1 = {}

		for _, v28 in p6.bundledItems do
			local str = tostring(v28.id)

			if v28.type == Constants.ItemType.Asset then
				local v30 = v25.AvatarExperience.Common.AssetInfos[str]

				if not v30 or not v30.receivedFromBundleItemData then
					table.insert(t1, v28)
				end
			end
		end

		if #t1 > 0 then
			p4:dispatch(SetAssetInfoFromBundleItemAction(t1))
		end
	end

	p4:dispatch(SetBundleInfoFromCatalogItemAction(p5, p6))
end

return function(s1: string) -- line: 62
	-- upvalues: ArgCheck (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), Utils (copy), processSuccessfulResult (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), HandleTryOnFailure (copy)
	ArgCheck.isType(s1, "string", "FetchBundleInfo thunk expects bundleId to be a string")

	return function(p7, p8) -- line: 65
		-- upvalues: s1 (copy), Promise (copy), PerformFetch (copy), CatalogConstants (copy), Utils (copy), processSuccessfulResult (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), HandleTryOnFailure (copy)
		local avatarEditorService = p8.avatarEditorService
		local v35 = p7:getState().AvatarExperience.Common.BundleInfos[tostring(s1)]

		if v35 ~= nil and v35.receivedCatalogData then
			return Promise.resolve("We already have the bundle")
		end

		local Single = PerformFetch.Single
		local v37 = s1

		return Single(CatalogConstants.FetchBundleInfoKey .. tostring(v37), function(p9) -- line: 73
			-- upvalues: Promise (copy), avatarEditorService (copy), s1 (copy), Utils (copy), processSuccessfulResult (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), HandleTryOnFailure (copy)
			return Promise.new(function(resolve, reject) -- line: 74
				-- upvalues: avatarEditorService (copy), s1 (copy), Utils (copy), processSuccessfulResult (copy), p9 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), HandleTryOnFailure (copy)
				local ok, result = pcall(function() -- line: 75
					-- upvalues: avatarEditorService (copy), s1 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return avatarEditorService:GetItemDetailsAsync(s1, Enum.AvatarItemType.Bundle)
					end

					return avatarEditorService:GetItemDetails(s1, Enum.AvatarItemType.Bundle)
				end)

				if ok then
					local v43 = Utils.tableToCamelCaseKeys(result)

					processSuccessfulResult(p9, s1, v43)
					resolve(v43)

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.FetchBundleInfo)
				end

				p9:dispatch(HandleTryOnFailure(s1))
				reject(result)
			end)
		end)(p7)
	end
end
