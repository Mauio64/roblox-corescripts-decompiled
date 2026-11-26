local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dzP")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dQw")
local module3 = require("@luauforge/bundled/dPU")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/bundled/fCe")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module7 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local function keyMapper(p2)
	return module3.RecommendedItemsForBundlesKey .. tostring(p2)
end

return function(p2, p3, p4, p5)
	module.isType(p2, "string", "GetRecommendedBundles thunk expects bundleId to be a string")
	module.isType(p3, "string", "GetRecommendedBundles thunk expects bundleTypeId to be a string")
	module.isType(p4, "number", "GetRecommendedBundles thunk expects numItems to be a number")
	module.isType(p5, "boolean", "GetRecommendedBundles thunk expects details to be a boolean")

	return function(p6, p7)
		local avatarEditorService = p7.avatarEditorService
		return performFetch.Single(module3.RecommendedItemsForBundlesKey .. tostring(p2), function(object)
			local bundleInfo = object:getState().AvatarExperience.Common.BundleInfos[p2]

			if bundleInfo == nil or not bundleInfo.receivedRecommendedData then
				return Promise.new(function(callback, callback2)
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetRecommendedBundles,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local success, result = pcall(function()
						return avatarEditorService:GetRecommendedBundlesAsync(p2)
					end)

					if success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetRecommendedBundles,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						local tableToCamelCaseKeys = module5.tableToCamelCaseKeys(result)
						local numRecommendedItems = module4.NumRecommendedItems

						local range = Cryo.List.getRange(tableToCamelCaseKeys, 1, numRecommendedItems)
						object:dispatch(module2(p2, p3, range))
						callback(range)
					else
						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(module7.Counter.AvatarEditorServiceErrors.GetRecommendedBundles)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetRecommendedBundles,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								result
							)
						end

						logging.warn("GetRecommendedBundles failed: " .. result)
						callback2({ HttpError = Enum.HttpError.OK })
					end
				end)
			end

			return Promise.resolve()
		end)(p6)
	end
end
