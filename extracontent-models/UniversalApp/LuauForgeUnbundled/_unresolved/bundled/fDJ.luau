local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")

local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/bundled/dPN")

local SetAssets = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetAssets")
local module5 = require("@luauforge/bundled/fDI")
local module6 = require("@luauforge/bundled/fCe")

local module7 = require("@luauforge/bundled/dQx")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module9 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local function keyMapper(p2)
	return module2.FetchBundleInfoKey .. tostring(p2)
end

local function checkAssetExists(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromBundleItemData then
		return true
	end

	return false
end

local function processSuccessfulResult(object, p2, tableToCamelCaseKeys)
	if tableToCamelCaseKeys.bundledItems then
		local state = object:getState()
		local bundledItems = {}

		for k, bundledItem in tableToCamelCaseKeys.bundledItems do
			local id = tostring(bundledItem.id)

			if bundledItem.type ~= module3.ItemType.Asset then
				continue
			end

			local assetInfo = state.AvatarExperience.Common.AssetInfos[id]

			if not (assetInfo and assetInfo.receivedFromBundleItemData) then
				table.insert(bundledItems, bundledItem)
			end
		end

		if #bundledItems > 0 then
			object:dispatch(SetAssets(bundledItems))
		end
	end

	object:dispatch(module7(p2, tableToCamelCaseKeys))
end

return function(p2)
	module.isType(p2, "string", "FetchBundleInfo thunk expects bundleId to be a string")

	return function(object, p3)
		local avatarEditorService = p3.avatarEditorService
		local bundleInfo = object:getState().AvatarExperience.Common.BundleInfos[tostring(p2)]

		if bundleInfo ~= nil and bundleInfo.receivedCatalogData then
			return Promise.resolve("We already have the bundle")
		end

		return performFetch.Single(module2.FetchBundleInfoKey .. tostring(p2), function(object2)
			return Promise.new(function(callback, callback2)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
					)
				end

				local success, result = pcall(function()
					return avatarEditorService:GetItemDetailsAsync(p2, Enum.AvatarItemType.Bundle)
				end)

				if success then
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
						)
					end

					local tableToCamelCaseKeys = module6.tableToCamelCaseKeys(result)
					processSuccessfulResult(object2, p2, tableToCamelCaseKeys)
					callback(tableToCamelCaseKeys)
				else
					if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
						reportAvatarEventCounterNoAnalyticsArgument(module9.Counter.AvatarEditorServiceErrors.FetchBundleInfo)
					end

					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
							result
						)
					end

					object2:dispatch(module5(p2))
					callback2(result)
				end
			end)
		end)(object)
	end
end
