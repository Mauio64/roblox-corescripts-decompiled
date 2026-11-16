local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/fwc")
local module2 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dHK")
local module3 = require("@luauforge/bundled/dMZ")
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/AH")
local module4 = require("@luauforge/bundled/dCn")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module6 = require("@luauforge/bundled/dMx")

local defineFastFlag = game:DefineFastFlag("AXSilenceCombineGetOutfitDispatchesMutedError2", false)
local defineFastInt = game:DefineFastInt("AXCombineGetOutfitDispatchesChunkSize", 3)

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local module7 = require("@luauforge/bundled/fwg")

local function getShouldRefetchAsset(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromOutfitDetails then
		return assetInfo.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
	end

	return false
end

local function getOutfit(object, p2, item, p3)
	local avatarEditorService = p2.avatarEditorService
	local state = object:getState()

	local outfitInfo = state.AvatarExperience.AvatarEditor.OutfitInfos[item]

	if fFlagAXMigrateOutfitsToUserInventory then
		if outfitInfo and outfitInfo.receivedFromGetOutfit then
			return Promise.resolve()
		end
	elseif outfitInfo then
		return Promise.resolve()
	end

	return Promise.new(function(callback, callback2)
		if fFlagAXAvatarEditorServiceTelemetryV2 then
			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
			)
		end

		local success, result = pcall(function()
			if not p3 then
				return avatarEditorService:GetOutfitDetailsAsync(tonumber(item) or 0)
			end

			local v5, v6 = module7.GetOutfit(p3, item, { checkAssetAvailability = true }):await()

			if not v5 then
				callback2(`AvatarEditorWebApi failure in GetOutfit: {tostring(v6)}`)
			end

			return v6[1]
		end)

		if success then
			local tableToCamelCaseKeys = module2.tableToCamelCaseKeys(result)

			if tableToCamelCaseKeys then
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
					)
				end

				if not p3 then
					tableToCamelCaseKeys.bodyColor3s = {}

					if tableToCamelCaseKeys.bodyColors then
						for k, bodyColor in tableToCamelCaseKeys.bodyColors do
							tableToCamelCaseKeys.bodyColor3s[`{k}3`] = bodyColor:ToHex()
						end

						tableToCamelCaseKeys.bodyColors = nil
					end
				end

				local assets = {}

				if tableToCamelCaseKeys.assets then
					for k, asset in tableToCamelCaseKeys.assets do
						local assetInfo = state.AvatarExperience.Common.AssetInfos[k]
						local v5

						if assetInfo and assetInfo.receivedFromOutfitDetails then
							v5 = assetInfo.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
						else
							v5 = false
						end

						if not v5 then
							assets[#assets + 1] = asset
						end
					end
				end

				local v5 = module.fromWebApi(item, nil, tableToCamelCaseKeys)

				if fFlagAXMigrateOutfitsToUserInventory then
					v5.receivedFromGetOutfit = true
				end

				callback({
					outfitId = item,
					outfitInfo = v5,
					assetsToUpdate = assets,
					moderationStatus = v5.moderationStatus
				})
			else
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
						"AvatarEditorService returned no data"
					)
				end

				return callback2("AvatarEditorService returned no data for GetOutfitDetails")
			end
		else
			if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(module6.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
			end

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
					result
				)
			end

			return callback2(`AvatarEditorService failure in GetOutfitDetails: {tostring(result)}`)
		end
	end)
end

local function failureHandler(p2, p3): nil
	if not defineFastFlag then
		module4(`[AvatarExperience] Error fetching outfit details for ID {p2}. Reason: {tostring(p3)}`)
	end

	return nil
end

local function processPromises(object, p2)
	return Promise.allSettled(p2):andThen(function(items)
		local expectsByOutfitId = {}

		for k, item in items do
			if item ~= Promise.Status.Resolved then
				continue
			end

			local expect = p2[k]:expect()

			if item == Promise.Status.Resolved and expect then
				expectsByOutfitId[expect.outfitId] = expect
			end
		end

		if next(expectsByOutfitId) then
			object:dispatch(module3(expectsByOutfitId))
		end
	end)
end

local function splitTableIntoChunks(list, defineFastInt2)
	local result = {}

	for i = 1, #list, defineFastInt2 do
		local v5 = {}
		table.move(list, i, math.min(i + defineFastInt2 - 1, #list), 1, v5)
		table.insert(result, v5)
	end

	return result
end

return function(items, p2)
	return function(p3, p4)
		local v5 = {}

		for k, item in items do
			table.insert(v5, (getOutfit(p3, p4, item, p2):catch(function(p5): nil
				local v6 = item

				if not defineFastFlag then
					module4(`[AvatarExperience] Error fetching outfit details for ID {v6}. Reason: {tostring(p5)}`)
				end

				return nil
			end)))
		end

		local v6 = splitTableIntoChunks(v5, defineFastInt)

		local resolved = Promise.resolve()

		for k, v7 in v6 do
			resolved = resolved:andThen(function()
				return processPromises(p3, v7)
			end)
		end

		return resolved
	end
end
