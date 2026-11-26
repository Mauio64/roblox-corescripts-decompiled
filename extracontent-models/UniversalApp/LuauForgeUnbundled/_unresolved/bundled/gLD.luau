local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPR")
local module3 = require("@luauforge/bundled/fDB")
local module4 = require("@luauforge/bundled/gLE")
local module5 = require("@luauforge/bundled/dRo")
local module6 = require("@luauforge/bundled/dSd")
local module7 = require("@luauforge/bundled/dSq")
local module8 = require("@luauforge/bundled/dRg")
local module9 = require("@luauforge/bundled/dPN")
local module10 = require("@luauforge/bundled/fCe")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module13 = require("@luauforge/bundled/dPN")
local module14 = require("@luauforge/bundled/dQq")
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/gLF").EditorInventoryTTIMilestoneManager

local function fn(p2, p3, object, object2, object3, callback, p4, p5, p6, p7)
	local currentPage = object2:GetCurrentPage()
	local tableToCamelCaseKeys = module10.tableToCamelCaseKeys(currentPage)
	local ids = {}
	local ids2 = {}

	for k, tableToCamelCaseKey in tableToCamelCaseKeys do
		local id = tostring(tableToCamelCaseKey.id)
		ids[#ids + 1] = id

		local state = object:getState()

		if not (p7 or state.AvatarExperience.AvatarEditor.OutfitInfos[id] == nil) then
			continue
		end

		if p7 or not (module14.isEnabled() and module2.readTestVariable(module14.EnabledForUser)) then
			object:dispatch(module3(id, nil, nil, if fFlagAXInventoryDurablesSupport then p6 else nil, p7))
		else
			table.insert(ids2, id)
		end
	end

	local reachedLastPage

	if object2.IsFinished then
		reachedLastPage = module8.ReachedLastPage

		object:dispatch(module7(p4 or p2, object2.IsFinished))
	end

	object3:storePageObject(p2 .. "." .. tostring(p3) .. tostring(p5), object2)

	if module14.isEnabled() and module2.readTestVariable(module14.EnabledForUser) then
		object:dispatch(module4(ids2, p6))
	end

	object:dispatch(module6(ids, module8.OutfitOrAsset.Outfit))
	object:dispatch(module5(p2, ids))
	callback(reachedLastPage)
end

local function advancePage(p2, p3, p4, callback, object, pageObjectManager, p5, p6, p7, p8, p9)
	local success, result = pcall(function()
		object:AdvanceToNextPageAsync()
	end)

	if success then
		fn(p2, p5, p3, object, pageObjectManager, p4, p6, p7, p8, p9)
		return
	end

	logging.warn("GetOutfits failure: " .. result)
	callback(result)
end

local function fetchInitialPage(p2, p3, p4, callback, p5, p6, object, p7, p8, p9, p10, p11)
	local v5

	if fFlagAXTTIEditorEnableMilestones and p11 and editorInventoryTTIMilestoneManager then
		v5 = editorInventoryTTIMilestoneManager.getSessionGeneration()
		editorInventoryTTIMilestoneManager.L3.getOutfitsStarted()
	end

	if fFlagAXAvatarEditorServiceTelemetryV2 then
		reportAvatarEditorServiceCounter(
			AVATAR_EDITOR_SERVICE_EVENTS.GetOutfits,
			AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
		)
	end

	local success, result = pcall(function()
		return object:GetOutfitsAsync(p6, p8)
	end)

	if success then
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.GetOutfits,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
			)
		end

		if
			fFlagAXTTIEditorEnableMilestones
			and p11
			and editorInventoryTTIMilestoneManager
			and v5 == editorInventoryTTIMilestoneManager.getSessionGeneration()
		then
			editorInventoryTTIMilestoneManager.L3.getOutfitsCompleted()
		end

		fn(p2, p6, p3, result, p5, p4, p7, p8, p9, p10)
	else
		logging.warn("GetOutfits failure: " .. result)

		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module13.Counter.AvatarEditorServiceErrors.GetOutfits)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.GetOutfits,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
				result
			)
		end

		callback(result)
	end
end

return function(p2, p3, p4, p5, p6, p7, p8, p9)
	module.isTypeOrNil(p3, "boolean", "GetOutfits thunk expects onlyEditableOutfits to be a boolean or nil")

	module.isTypeOrNil(p5, "string", "GetOutfits thunk expects outfitType to be a string or nil")
	module.isTypeOrNil(p7, "boolean", "GetOutfits thunk expects forceInitialPage to be a boolean or nil")

	module.isTypeOrNil(p8, "boolean", "GetOutfits thunk expects forceRefresh to be a boolean or nil")
	module.isTypeOrNil(p9, "boolean", "GetOutfits thunk expects trackTTI to be a boolean or nil")

	local v5 = p4 or p2
	return function(p10, p11)
		local pageObjectManager = p11.pageObjectManager
		local avatarEditorService = p11.avatarEditorService
		return performFetch.Single(module9.OutfitsKey .. v5, function(p12)
			local v6

			if p3 == nil then
				v6 = Enum.OutfitSource.All
			else
				v6 = if p3 then Enum.OutfitSource.Created else Enum.OutfitSource.Purchased
			end

			local v7 = Enum.OutfitType.All

			if p5 == module9.OutfitTypes.Avatar then
				v7 = Enum.OutfitType.Avatar
			elseif p5 == module9.OutfitTypes.DynamicHead then
				v7 = Enum.OutfitType.DynamicHead
			elseif p5 == module9.OutfitTypes.Makeup then
				v7 = Enum.OutfitType.All
			end

			local v8 = p2 .. "." .. tostring(v6) .. tostring(v7)
			local v9

			if fFlagAXEnableExpiredUserLookCheckout and p7 then
				v9 = nil
			else
				v9 = pageObjectManager:getPageObject(v8)
			end

			if v9 and v9.IsFinished then
				return Promise.resolve(module8.ReachedLastPage)
			end

			return Promise.new(function(p13, p14)
				if v9 ~= nil then
					advancePage(p2, p12, p13, p14, v9, pageObjectManager, v6, p4, v7, p6, p8)
					return
				end

				fetchInitialPage(
					p2,
					p12,
					p13,
					p14,
					pageObjectManager,
					v6,
					avatarEditorService,
					p4,
					v7,
					p6,
					p8,
					if fFlagAXTTIEditorEnableMilestones then p9 else nil
				)
			end)
		end)(p10)
	end
end
