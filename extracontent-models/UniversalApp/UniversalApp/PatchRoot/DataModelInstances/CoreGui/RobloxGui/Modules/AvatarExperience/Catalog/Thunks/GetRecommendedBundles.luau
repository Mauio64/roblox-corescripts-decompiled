local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetRecommendedBundlesAction = require(Modules.AvatarExperience.Catalog.Actions.SetRecommendedBundlesAction)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function keyMapper(p1) -- line: 25
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.RecommendedItemsForBundlesKey .. tostring(p1)
end

return function(s1: string, s2: string, n1: number, b1: boolean) -- line: 29
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), Promise (copy), Utils (copy), Constants (copy), Cryo (copy), SetRecommendedBundlesAction (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
	ArgCheck.isType(s1, "string", "GetRecommendedBundles thunk expects bundleId to be a string")
	ArgCheck.isType(s2, "string", "GetRecommendedBundles thunk expects bundleTypeId to be a string")
	ArgCheck.isType(n1, "number", "GetRecommendedBundles thunk expects numItems to be a number")
	ArgCheck.isType(b1, "boolean", "GetRecommendedBundles thunk expects details to be a boolean")

	return function(p2, p3) -- line: 35
		-- upvalues: PerformFetch (copy), s1 (copy), CatalogConstants (copy), Promise (copy), Utils (copy), Constants (copy), Cryo (copy), SetRecommendedBundlesAction (copy), s2 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
		local avatarEditorService = p3.avatarEditorService
		local Single = PerformFetch.Single
		local v25 = s1

		return Single(CatalogConstants.RecommendedItemsForBundlesKey .. tostring(v25), function(p4) -- line: 37
			-- upvalues: s1 (copy), Promise (copy), avatarEditorService (copy), Utils (copy), Constants (copy), Cryo (copy), SetRecommendedBundlesAction (copy), s2 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
			local v27 = p4:getState().AvatarExperience.Common.BundleInfos[s1]

			if v27 ~= nil and v27.receivedRecommendedData then
				return Promise.resolve()
			end

			return Promise.new(function(resolve, reject) -- line: 43
				-- upvalues: avatarEditorService (copy), s1 (copy), Utils (copy), Constants (copy), Cryo (copy), p4 (copy), SetRecommendedBundlesAction (copy), s2 (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
				local ok, result = pcall(function() -- line: 44
					-- upvalues: avatarEditorService (copy), s1 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return avatarEditorService:GetRecommendedBundlesAsync(s1)
					end

					return avatarEditorService:GetRecommendedBundles(s1)
				end)

				if ok then
					local v32 = Utils.tableToCamelCaseKeys(result)
					local NumRecommendedItems = Constants.NumRecommendedItems
					local v34 = Cryo.List.getRange(v32, 1, NumRecommendedItems)

					p4:dispatch(SetRecommendedBundlesAction(s1, s2, v34))
					resolve(v34)

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.GetRecommendedBundles)
				end

				Logging.warn("GetRecommendedBundles failed: " .. result)
				reject({
					HttpError = Enum.HttpError.OK
				})
			end)
		end)(p2)
	end
end
