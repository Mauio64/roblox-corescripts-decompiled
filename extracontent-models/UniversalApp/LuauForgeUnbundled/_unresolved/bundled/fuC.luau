local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/bundled/dwM")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/bundled/fuD")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local module8 = require("@luauforge/bundled/dNh")

local module9 = require("@luauforge/bundled/dMK")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local SetAssets = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetAssets")
local module11 = require("@luauforge/bundled/dRQ")
local module12 = require("@luauforge/bundled/fuO")
local GetSourceLanguageThunk = require("@game/CoreGui/RobloxGui/Modules/Feedback/Thunks/GetSourceLanguageThunk")

local module14 = require("@luauforge/bundled/fuQ")
local module15 = require("@luauforge/bundled/fuR")

local module16 = require("@luauforge/bundled/fuS")
local module17 = require("@luauforge/bundled/dMw")
local module18 = require("@luauforge/bundled/dNf")
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")

local fFlagAXFetchItemDetailsFromAvatarEditorService = AvatarExperienceFlags.FFlagAXFetchItemDetailsFromAvatarEditorService
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local fVariable = settings():GetFVariable("LuaAppsPageLoadTimeItemDetails")

local function keyMapper(p2, p3)
	return module11.GetItemDetailsKey(p2, p3)
end

local function checkIfReceivedFromBundleItemData(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromBundleItemData then
		return true
	end

	return false
end

local function fn(object, p2, collectibleItemId, hasResellers)
	local v5 = { object:dispatch(GetSourceLanguageThunk(p2, collectibleItemId)) }

	local localUserId = object:getState().LocalUserId
	table.insert(v5, object:dispatch(module16(p2, collectibleItemId, localUserId)))

	if hasResellers then
		table.insert(v5, object:dispatch(module14(p2, collectibleItemId, nil, module4.MaxResellersPerPage)))

		table.insert(v5, object:dispatch(module15(p2, collectibleItemId)))
	end

	return Promise.all(v5)
end

local function processSuccessfulResult(p2, p3, p4, object, p5)
	local state = object:getState()

	if p4 == module5.ItemType.Bundle then
		object:dispatch(module8(p3, p5))

		local bundledItems = {}

		if p5.bundledItems then
			for k, bundledItem in p5.bundledItems do
				local id = tostring(bundledItem.id)

				if bundledItem.Type ~= module5.ItemType.Asset then
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

		local v5 = module18.fromGetCatalogItemData(p5)
		local collectibleItemId = v5.collectibleItemId
		local hasResellers = v5.hasResellers

		if collectibleItemId then
			fn(object, p2, collectibleItemId, hasResellers)
		end
	elseif p4 == module5.ItemType.Asset then
		object:dispatch(module9(p3, p5))

		local v5 = module17.fromGetCatalogItemData(p5)
		local isResellable = module11.IsResellable(v5)
		local collectibleItemId = v5.collectibleItemId
		local hasResellers = v5.hasResellers

		if collectibleItemId then
			fn(object, p2, collectibleItemId, hasResellers)
		elseif isResellable then
			object:dispatch(module12(p2, p3, nil, module4.MaxResellersPerPage))
		end
	end
end

return function(p2, p3, p4, p5, p6)
	module2.isType(p4, "string", "FetchAssetOrBundleInfo request expects itemId")
	module2.isType(p5, "string", "FetchAssetOrBundleInfo request expects itemType")

	return function(object, p7)
		local lastTime = tick()
		local state = object:getState()

		local v5 = nil

		if p5 == module5.ItemType.Asset then
			v5 = state.AvatarExperience.Common.AssetInfos[p4]
		elseif p5 == module5.ItemType.Bundle then
			v5 = state.AvatarExperience.Common.BundleInfos[p4]
		end

		local collectibleItemId = v5 and v5.collectibleItemId
		return performFetch.Single(module11.GetItemDetailsKey(p4, p5), function(object2)
			local v8 = not (v5 == nil) and (v5.receivedCatalogData and not p6)

			if v8 then
				if collectibleItemId then
					return fn(object2, p2, collectibleItemId, v5.hasResellers)
				end

				if module11.IsResellable(v5) then
					return object2:dispatch(module12(p2, p4, nil, module4.MaxResellersPerPage))
				end

				return Promise.resolve()
			else
				if not fFlagAXFetchItemDetailsFromAvatarEditorService then
					return GetExperienceSourceLanguage.FetchItemDetail(p2, p4, p5):andThen(function(p8)
						local responseBody = p8.responseBody or {}
						processSuccessfulResult(p2, p4, p5, object2, responseBody)
					end):catch(function(p8)
						logging.warn("FetchAssetOrBundleInfo failure: " .. p8)
					end):finally(function()
						if p3 and p3.Diag then
							local v9 = (tick() - lastTime) * 1000
							p3.Diag:reportStats(fVariable, v9)
						end
					end)
				end

				local avatarEditorService = p7.avatarEditorService
				local v9

				if p5 == module5.ItemType.Bundle then
					v9 = Enum.AvatarItemType.Bundle
				else
					v9 = Enum.AvatarItemType.Asset
				end

				return Promise.new(function(callback)
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local success, result = pcall(function()
						return avatarEditorService:GetItemDetailsAsync(tonumber(p4), v9)
					end)

					if success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						processSuccessfulResult(p2, p4, p5, object2, module6.tableToCamelCaseKeys(result))
					else
						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(module5.Counter.AvatarEditorServiceErrors.FetchAssetOrBundleInfo)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetItemDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								result
							)
						end

						logging.warn("FetchAssetOrBundleInfo failure: " .. tostring(result))
						mutedError(`FetchAssetOrBundleInfo failure: {tostring(result)}`)
					end

					callback()
				end):finally(function()
					local v10 = (tick() - lastTime) * 1000
					sendAXStat({
						statName = module5.Counter.Latency.Network.FetchAssetOrBundleInfo,
						deltaMs = v10
					})
				end)
			end
		end)(object)
	end
end
