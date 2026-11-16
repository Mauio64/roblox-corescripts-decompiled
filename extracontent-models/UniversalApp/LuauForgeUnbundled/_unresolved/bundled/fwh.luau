local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dwM")
local module3 = require("@luauforge/bundled/dME")

local module4 = require("@luauforge/bundled/dMK")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module5 = require("@luauforge/bundled/dRQ")
local module6 = require("@luauforge/bundled/fuO")
local module7 = require("@luauforge/bundled/dMw")
local module8 = require("@luauforge/bundled/fuD")
local receivedBundleInfoForTryOn = require("@luauforge/bundled/dHL").Actions.ReceivedBundleInfoForTryOn
local module9 = require("@luauforge/bundled/fwi")

local module10 = require("@luauforge/bundled/fwd")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module12 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")
local module13 = require("@luauforge/bundled/dMx")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local function keyMapper(p2)
	return module5.GetBatchItemDetailsKey(p2)
end

local function processSuccessfulResult(p2, p3, p4, object, items)
	local state = object:getState()

	for k, item in items do
		local id = tostring(item.id)
		object:dispatch(module4(id, item))

		local v5 = module7.fromGetCatalogItemData(item)

		if module5.IsResellable(v5) then
			object:dispatch(module6(p2, id, nil, module3.MaxResellersPerPage))
		end
	end

	local tryOnItemReducerKey = getTryOnItemReducerKey(p3, module13.ItemType.Bundle)

	if state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[tryOnItemReducerKey] then
		object:dispatch(receivedBundleInfoForTryOn(p3))

		object:dispatch(module10(p3))
	end
end

return function(p2, p3, p4)
	module2.isType(p4, "table", "FetchBundleAssetsDetails request expects itemIds")
	return function(p5, p6)
		local avatarEditorService = p6.avatarEditorService
		return performFetch.Single(module5.GetBatchItemDetailsKey(p4), function(object)
			return Promise.new(function(callback, callback2)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetBatchItemDetails,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local success, result = pcall(function()
					return avatarEditorService:GetBatchItemDetailsAsync(p4, Enum.AvatarItemType.Asset)
				end)

				if success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetBatchItemDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					local tableToCamelCaseKeys = module8.tableToCamelCaseKeys(result)
					processSuccessfulResult(p2, p3, p4, object, tableToCamelCaseKeys)
					callback(tableToCamelCaseKeys)
				else
					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module12.Counter.AvatarEditorServiceErrors.GetBatchItemDetails)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetBatchItemDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							result
						)
					end

					logging.warn("FetchBundleAssetsDetails failure: " .. tostring(result))
					object:dispatch(module9(p3))
					callback2()
				end
			end)
		end)(p5)
	end
end
