local createMakeupLook = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/CreateMakeupLook/createMakeupLook")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").PerformFetch
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/ToastRodux")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Loggers").mutedError
local constants = AvatarExperienceCommon.Constants

local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local isMakeupOrEyebrowEyelashAssetType = AvatarExperienceCommon.Utils.isMakeupOrEyebrowEyelashAssetType

local constants2 = AvatarExperienceAnalytics.Constants
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = constants2.AVATAR_EDITOR_SERVICE_COUNTER_STATUS

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local fIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local fFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local v5 = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingMakeupLook",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

return function(p2, p3, items, callback, callback2)
	return performFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateMakeupLookKey, function(object)
		local state = object:getState()
		local bodyColor3s = state.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local avatarScales = state.AvatarExperience.AvatarEditor.Character.AvatarScales
		local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
		local equippedAssets

		if fFlagAXMISSaveWearFix then
			equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		end

		local v6 = {}

		for k, bodyColor3 in bodyColor3s do
			v6[k] = bodyColor3:ToHex()
		end

		local v7 = {}

		for k, item in items do
			if
				item.itemSubType
				and isMakeupOrEyebrowEyelashAssetType(item.itemSubType)
				and item.selectedInTryOnManager
			then
				table.insert(v7, {
					id = tonumber(item.itemId),
					meta = { order = item.order, version = tonumber(item.version) }
				})
			end
		end

		if #v7 == 0 then
			mutedError("SaveAsMakeupLookThunk: No valid makeup assets to save")
			return Promise.resolve()
		end

		if fFlagAXMISSaveWearFix and callback2 then
			local v8 = callback2(state, items)

			local ordersByAssetId = {}

			if v8 then
				for i, makeupDescription in v8:GetChildren() do
					if makeupDescription:IsA("MakeupDescription") then
						ordersByAssetId[tostring(makeupDescription.assetId)] = makeupDescription.order
					end
				end
			end

			for k, v9 in constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
				if not (equippedAssets and equippedAssets[k]) then
					continue
				end

				for k2, v10 in equippedAssets[k] do
					if ordersByAssetId[k2] ~= nil then
						table.insert(v7, {
							id = k2,
							meta = {
								order = ordersByAssetId[k2],
								version = tonumber(v10.version)
							}
						})
					end
				end
			end
		end

		local v8 = {
			name = p3,
			bodyColor3s = v6,
			assets = v7,
			scale = avatarScales,
			playerAvatarType = avatarType,
			outfitType = "Makeup"
		}

		task.spawn(function()
			task.wait(fIntAXLookOutfitCreationDelayMs / 1000)

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					constants2.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			local v9, v10 = createMakeupLook(p2, v8)

			return v9:andThen(function(p4)
				if fFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						constants2.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
					)
				end

				if callback then
					callback()
				end

				reportAvatarEventCounterV1(constants2.AVATAR_EVENT_COUNTER_NAME.AXCreateMakeupLook)
			end):catch(function(p4)
				warn("Failed to create makeup look", p4)
				object:dispatch(setCurrentToastMessage(v5))

				if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
					reportAvatarEventCounterNoAnalyticsArgument(constants2.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
				end

				if fFlagAXAvatarEditorServiceTelemetryV2 then
					local v11 = if typeof(p4) == "table" and typeof(p4.HttpError) == "EnumItem" then p4.HttpError else nil

					reportAvatarEditorServiceCounter(
						constants2.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
						v11
					)
				end
			end)
		end)

		return Promise.resolve()
	end)
end
