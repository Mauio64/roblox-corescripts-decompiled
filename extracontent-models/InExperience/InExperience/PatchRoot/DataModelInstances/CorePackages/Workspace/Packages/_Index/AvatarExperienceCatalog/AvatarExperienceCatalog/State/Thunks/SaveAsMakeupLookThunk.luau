local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local createMakeupLook = require(AvatarExperienceCatalog.Api.CreateMakeupLook.createMakeupLook)
local parent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local Promise = require(parent.Promise)
local ToastRodux = require(parent.ToastRodux)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local Constants = AvatarExperienceCommon.Constants

local AVATAR_EDITOR_CONSTANTS = AvatarExperienceCommon.Constants.AVATAR_EDITOR_CONSTANTS
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local isMakeupOrEyebrowEyelashAssetType = AvatarExperienceCommon.Utils.isMakeupOrEyebrowEyelashAssetType

local constants = AvatarExperienceAnalytics.Constants
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local FIntAXLookOutfitCreationDelayMs = AvatarExperienceFlags.FIntAXLookOutfitCreationDelayMs
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local FFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceFlags.FFlagAXAvatarEditorServiceTelemetryV2

local FFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceFlags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1

local v = {
	toastMessage = "Feature.Avatar.Message.UnknownErrorCreatingMakeupLook",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p, name, items, callback, callback2)
	return PerformFetch.Single(AVATAR_EDITOR_CONSTANTS.CreateMakeupLookKey, function(object)
		local state = object:getState()
		local bodyColor3s = state.AvatarExperience.AvatarEditor.Character.BodyColor3s
		local avatarScales = state.AvatarExperience.AvatarEditor.Character.AvatarScales
		local avatarType = state.AvatarExperience.AvatarEditor.Character.AvatarType
		local equippedAssets

		if FFlagAXMISSaveWearFix then
			equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		end

		local bodyColor3s2 = {}

		for k, bodyColor3 in bodyColor3s do
			bodyColor3s2[k] = bodyColor3:ToHex()
		end

		local assets = {}

		for _, item in items do
			if
				item.itemSubType
				and isMakeupOrEyebrowEyelashAssetType(item.itemSubType)
				and item.selectedInTryOnManager
			then
				table.insert(assets, {
					id = tonumber(item.itemId),
					meta = { order = item.order, version = tonumber(item.version) }
				})
			end
		end

		if #assets == 0 then
			mutedError("SaveAsMakeupLookThunk: No valid makeup assets to save")
			return Promise.resolve()
		end

		if FFlagAXMISSaveWearFix and callback2 then
			local v2 = callback2(state, items)

			local ordersByAssetId = {}

			if v2 then
				for _, makeupDescription in v2:GetChildren() do
					if makeupDescription:IsA("MakeupDescription") then
						ordersByAssetId[tostring(makeupDescription.assetId)] = makeupDescription.order
					end
				end
			end

			for k, _ in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
				if not (equippedAssets and equippedAssets[k]) then
					continue
				end

				for k2, v3 in equippedAssets[k] do
					if ordersByAssetId[k2] ~= nil then
						table.insert(assets, {
							id = k2,
							meta = { order = ordersByAssetId[k2], version = tonumber(v3.version) }
						})
					end
				end
			end
		end

		local v2 = {
			name = name,
			bodyColor3s = bodyColor3s2,
			assets = assets,
			scale = avatarScales,
			playerAvatarType = avatarType,
			outfitType = "Makeup"
		}

		task.spawn(function()
			task.wait(FIntAXLookOutfitCreationDelayMs / 1000)

			if FFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					constants.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
				)
			end

			local makeupLook, _ = createMakeupLook(p, v2)

			return makeupLook:andThen(function(_)
				if FFlagAXAvatarEditorServiceTelemetryV2 then
					reportAvatarEditorServiceCounter(
						constants.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
					)
				end

				if callback then
					callback()
				end

				reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXCreateMakeupLook)
			end):catch(function(p2)
				warn("Failed to create makeup look", p2)
				object:dispatch(SetCurrentToastMessage(v))

				if not FFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
					reportAvatarEventCounterNoAnalyticsArgument(constants.AVATAR_EDITOR_SERVICE_ERRORS.CreateOutfit)
				end

				if FFlagAXAvatarEditorServiceTelemetryV2 then
					local v3

					if typeof(p2) == "table" and typeof(p2.HttpError) == "EnumItem" then
						v3 = p2.HttpError
					end

					reportAvatarEditorServiceCounter(
						constants.AVATAR_EDITOR_SERVICE_EVENTS.CreateMakeupLook,
						AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
						v3
					)
				end
			end)
		end)

		return Promise.resolve()
	end)
end
