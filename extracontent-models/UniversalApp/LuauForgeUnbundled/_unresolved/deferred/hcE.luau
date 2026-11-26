local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dRo")
local module3 = require("@luauforge/bundled/dSq")

local module4 = require("@luauforge/bundled/dPX")
local module5 = require("@luauforge/bundled/dRg")
local module6 = require("@luauforge/bundled/dPN")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local module7 = require("@luauforge/bundled/fCe")
local module8 = require("@luauforge/bundled/fCI")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module10 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local function checkAssetExists(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromInventoryFetch then
		return true
	end

	return false
end

local function fn(p2, object, object2, object3, callback, p3)
	local state = object:getState()
	local currentPage = object2:GetCurrentPage()
	local tableToCamelCaseKeys = module7.tableToCamelCaseKeys(currentPage)

	local assetIds = {}
	local tableToCamelCaseKeys2 = {}

	for k, tableToCamelCaseKey in tableToCamelCaseKeys do
		local assetId = tostring(tableToCamelCaseKey.assetId)
		assetIds[#assetIds + 1] = assetId
		local assetInfo = state.AvatarExperience.Common.AssetInfos[assetId]

		if not (assetInfo and assetInfo.receivedFromInventoryFetch) then
			tableToCamelCaseKeys2[#tableToCamelCaseKeys2 + 1] = tableToCamelCaseKey
		end
	end

	if #tableToCamelCaseKeys2 > 0 then
		object:dispatch(module4(tableToCamelCaseKeys2))
	end

	object:dispatch(module3(p2, object2.IsFinished))

	object3:storePageObject(p2, object2)

	object:dispatch(module2(p3 or p2, assetIds))

	local v5 = if object2.IsFinished then module5.ReachedLastPage else nil

	callback(v5)
end

local function advancePage(p2, p3, pageObject, pageObjectManager, p4, callback, p5)
	local success, result = pcall(function()
		pageObject:AdvanceToNextPageAsync()
	end)

	if success then
		fn(p2, p3, pageObject, pageObjectManager, p4, p5)
		return
	end

	logging.warn("GetUserInventory failure: " .. result)
	callback()
end

local function fetchInitialPage(p2, items, p3, pageObjectManager, avatarEditorService, p4, callback, p5)
	if fFlagAXAvatarEditorServiceTelemetryV2 then
		reportAvatarEditorServiceCounter(
			AVATAR_EDITOR_SERVICE_EVENTS.GetInventory,
			AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
		)
	end

	local success, result = pcall(function()
		local v5 = {}

		for k, item in items do
			table.insert(v5, (module7.AssetTypeIdStringToEnumValue(item)))
		end

		return avatarEditorService:GetInventoryAsync(v5)
	end)

	if success then
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.GetInventory,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
			)
		end

		fn(p2, p3, result, pageObjectManager, p4, p5)
	else
		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.GetInventory)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.GetInventory,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
				result
			)
		end

		logging.warn("GetUserInventory failure: " .. result)
		callback()
	end
end

return function(p2, p3, p4)
	module.isType(p2, "table", "GetUserInventory thunk expects categoryInfo to be a table")

	return function(object, p5)
		local pageObjectManager = p5.pageObjectManager
		local avatarEditorService = p5.avatarEditorService
		local searchUuidAndAssetTypes, v5 = module8.getSearchUuidAndAssetTypes(
			p2,
			object:getState().AvatarExperience.AvatarEditor.Categories.subButton
		)

		if not searchUuidAndAssetTypes then
			return Promise.resolve("No SearchUuid")
		end

		local v6 = p3 or searchUuidAndAssetTypes

		return performFetch.Single(module6.UserInventoryKey .. v6, function(p6)
			local pageObject = pageObjectManager:getPageObject(v6)

			if pageObject and pageObject.IsFinished then
				return Promise.resolve(module5.ReachedLastPage)
			end

			return Promise.new(function(p7, p8)
				if pageObject == nil then
					fetchInitialPage(v6, v5, p6, pageObjectManager, avatarEditorService, p7, p8, p4)
				else
					advancePage(v6, p6, pageObject, pageObjectManager, p7, p8, p4)
				end
			end)
		end)(object)
	end
end
