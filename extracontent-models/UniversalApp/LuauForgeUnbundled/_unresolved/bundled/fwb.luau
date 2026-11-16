local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dwM")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local module2 = require("@luauforge/bundled/dOT")
local module3 = require("@luauforge/bundled/fwc")
local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/fuD")

local module6 = require("@luauforge/bundled/dMI")
local receivedBundleInfoForTryOn = require("@luauforge/bundled/dHL").Actions.ReceivedBundleInfoForTryOn

local module7 = require("@luauforge/bundled/fwd")
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")
local module8 = require("@luauforge/bundled/dON")
local module9 = require("@luauforge/bundled/dNQ")
local module10 = require("@luauforge/bundled/dCn")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module12 = require("@luauforge/bundled/dMx")
local defineFastFlag = game:DefineFastFlag("AXSilenceGetOutfitMutedError", false)

local fFlagAXEnableExpiredUserLookCheckout = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEnableExpiredUserLookCheckout

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory
local module13 = require("@luauforge/bundled/fwg")

local function keyMapper(p2)
	return module4.OutfitInfoKey .. tostring(p2)
end

local function checkAssetExists(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromOutfitDetails then
		return assetInfo.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
	end

	return false
end

return function(p2, p3, p4, p5, p6)
	module.isType(p2, "string", "GetOutfit thunk expects outfitId to be a string")
	module.isTypeOrNil(p6, "boolean", "GetOutfit thunk expects forceRefresh to be a boolean or nil")
	return function(p7, p8)
		local avatarEditorService = p8.avatarEditorService
		return performFetch.Single(module4.OutfitInfoKey .. tostring(p2), function(object)
			local state = object:getState()

			local outfitInfo = state.AvatarExperience.AvatarEditor.OutfitInfos[p2]

			if fFlagAXEnableExpiredUserLookCheckout and p6 then
				return Promise.new(function(callback, callback2)
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local success, result = pcall(function()
						if not p5 then
							return avatarEditorService:GetOutfitDetailsAsync(tonumber(p2) or 0)
						end

						local v7, v8 = module13.GetOutfit(p5, p2, {
							checkAssetAvailability = true
						}):await()

						if v7 then
							return v8[1]
						end

						return callback2(`AvatarEditorWebApi failure in GetOutfit: {tostring(v8)}`)
					end)

					if success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						local v7 = module5.tableToCamelCaseKeys(result)

						if v7 then
							if not p5 then
								v7.bodyColor3s = {}

								if v7.bodyColors then
									for k, bodyColor in v7.bodyColors do
										v7.bodyColor3s[k .. "3"] = bodyColor:ToHex()
									end

									v7.bodyColors = nil
								end
							end

							local v8 = {}
							local assets = v7.assets

							local assets2 = {}

							local v9 = module3.fromWebApi(p2, p3, v7)

							if fFlagAXMigrateOutfitsToUserInventory then
								v9.receivedFromGetOutfit = true
							end

							if assets then
								for k, asset in assets do
									local id = tostring(asset.assetType.id)
									local id2 = tostring(asset.id)

									v8[id] = v8[id] or {}
									table.insert(v8[id], id2)
									local v10 = state.AvatarExperience.Common.AssetInfos[id2]
									local v11

									if v10 and v10.receivedFromOutfitDetails then
										v11 = v10.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
									else
										v11 = false
									end

									if not v11 then
										assets2[#assets2 + 1] = asset
									end
								end
							end

							if #assets2 > 0 then
								object:dispatch(module6(assets2, v9.moderationStatus))
							end

							object:dispatch(module2(v9))
							local outfitOrAsset = state.AvatarExperience.AvatarEditor.Character.OutfitOrAsset

							if outfitOrAsset and not outfitOrAsset[p2] then
								object:dispatch(module8({ (tostring(p2)) }, module9.OutfitOrAsset.Outfit))
							end

							if p4 then
								object:dispatch(receivedBundleInfoForTryOn(p4, (tostring(p2))))

								object:dispatch(module7(p4))
							end
						end

						callback(result)
					else
						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(module12.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								result
							)
						end

						logging.warn("AvatarEditorService failure in GetOutfitDetails for id " .. p2)

						if not defineFastFlag then
							module10(`[AvatarExperience] Error fetching outfit details for ID {p2}. Reason: {tostring(result)}`)
						end

						callback2(`AvatarEditorService failure in GetOutfitDetails for outfit ID {p2}: {tostring(result)}`)
					end
				end)
			end

			if fFlagAXMigrateOutfitsToUserInventory then
				if outfitInfo and outfitInfo.receivedFromGetOutfit then
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
						if not p5 then
							return avatarEditorService:GetOutfitDetailsAsync(tonumber(p2) or 0)
						end

						local v7, v8 = module13.GetOutfit(p5, p2, {
							checkAssetAvailability = true
						}):await()

						if v7 then
							return v8[1]
						end

						return callback2(`AvatarEditorWebApi failure in GetOutfit: {tostring(v8)}`)
					end)

					if success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						local v7 = module5.tableToCamelCaseKeys(result)

						if v7 then
							if not p5 then
								v7.bodyColor3s = {}

								if v7.bodyColors then
									for k, bodyColor in v7.bodyColors do
										v7.bodyColor3s[k .. "3"] = bodyColor:ToHex()
									end

									v7.bodyColors = nil
								end
							end

							local v8 = {}
							local assets = v7.assets

							local assets2 = {}

							local v9 = module3.fromWebApi(p2, p3, v7)

							if fFlagAXMigrateOutfitsToUserInventory then
								v9.receivedFromGetOutfit = true
							end

							if assets then
								for k, asset in assets do
									local id = tostring(asset.assetType.id)
									local id2 = tostring(asset.id)

									v8[id] = v8[id] or {}
									table.insert(v8[id], id2)
									local v10 = state.AvatarExperience.Common.AssetInfos[id2]
									local v11

									if v10 and v10.receivedFromOutfitDetails then
										v11 = v10.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
									else
										v11 = false
									end

									if not v11 then
										assets2[#assets2 + 1] = asset
									end
								end
							end

							if #assets2 > 0 then
								object:dispatch(module6(assets2, v9.moderationStatus))
							end

							object:dispatch(module2(v9))
							local outfitOrAsset = state.AvatarExperience.AvatarEditor.Character.OutfitOrAsset

							if outfitOrAsset and not outfitOrAsset[p2] then
								object:dispatch(module8({ (tostring(p2)) }, module9.OutfitOrAsset.Outfit))
							end

							if p4 then
								object:dispatch(receivedBundleInfoForTryOn(p4, (tostring(p2))))

								object:dispatch(module7(p4))
							end
						end

						callback(result)
					else
						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(module12.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								result
							)
						end

						logging.warn("AvatarEditorService failure in GetOutfitDetails for id " .. p2)

						if not defineFastFlag then
							module10(`[AvatarExperience] Error fetching outfit details for ID {p2}. Reason: {tostring(result)}`)
						end

						callback2(`AvatarEditorService failure in GetOutfitDetails for outfit ID {p2}: {tostring(result)}`)
					end
				end)
			elseif outfitInfo then
				return Promise.resolve()
			else
				return Promise.new(function(callback, callback2)
					if fFlagAXAvatarEditorServiceTelemetryV2 then
						reportAvatarEditorServiceCounter(
							AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
							AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
						)
					end

					local success, result = pcall(function()
						if not p5 then
							return avatarEditorService:GetOutfitDetailsAsync(tonumber(p2) or 0)
						end

						local v7, v8 = module13.GetOutfit(p5, p2, {
							checkAssetAvailability = true
						}):await()

						if v7 then
							return v8[1]
						end

						return callback2(`AvatarEditorWebApi failure in GetOutfit: {tostring(v8)}`)
					end)

					if success then
						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
							)
						end

						local v7 = module5.tableToCamelCaseKeys(result)

						if v7 then
							if not p5 then
								v7.bodyColor3s = {}

								if v7.bodyColors then
									for k, bodyColor in v7.bodyColors do
										v7.bodyColor3s[k .. "3"] = bodyColor:ToHex()
									end

									v7.bodyColors = nil
								end
							end

							local v8 = {}
							local assets = v7.assets

							local assets2 = {}

							local v9 = module3.fromWebApi(p2, p3, v7)

							if fFlagAXMigrateOutfitsToUserInventory then
								v9.receivedFromGetOutfit = true
							end

							if assets then
								for k, asset in assets do
									local id = tostring(asset.assetType.id)
									local id2 = tostring(asset.id)

									v8[id] = v8[id] or {}
									table.insert(v8[id], id2)
									local v10 = state.AvatarExperience.Common.AssetInfos[id2]
									local v11

									if v10 and v10.receivedFromOutfitDetails then
										v11 = v10.outfitModerationStatus ~= Enum.ModerationStatus.NotReviewed
									else
										v11 = false
									end

									if not v11 then
										assets2[#assets2 + 1] = asset
									end
								end
							end

							if #assets2 > 0 then
								object:dispatch(module6(assets2, v9.moderationStatus))
							end

							object:dispatch(module2(v9))
							local outfitOrAsset = state.AvatarExperience.AvatarEditor.Character.OutfitOrAsset

							if outfitOrAsset and not outfitOrAsset[p2] then
								object:dispatch(module8({ (tostring(p2)) }, module9.OutfitOrAsset.Outfit))
							end

							if p4 then
								object:dispatch(receivedBundleInfoForTryOn(p4, (tostring(p2))))

								object:dispatch(module7(p4))
							end
						end

						callback(result)
					else
						if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
							reportAvatarEventCounterNoAnalyticsArgument(module12.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
						end

						if fFlagAXAvatarEditorServiceTelemetryV2 then
							reportAvatarEditorServiceCounter(
								AVATAR_EDITOR_SERVICE_EVENTS.GetOutfitDetails,
								AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
								result
							)
						end

						logging.warn("AvatarEditorService failure in GetOutfitDetails for id " .. p2)

						if not defineFastFlag then
							module10(`[AvatarExperience] Error fetching outfit details for ID {p2}. Reason: {tostring(result)}`)
						end

						callback2(`AvatarEditorService failure in GetOutfitDetails for outfit ID {p2}: {tostring(result)}`)
					end
				end)
			end
		end)(p7)
	end
end
