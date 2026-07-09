local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local SetOutfitInfo = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOutfitInfo)
local OutfitInfo = require(Modules.AvatarExperience.AvatarEditor.Models.OutfitInfo)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SetAssetInfoFromOutfitDetails = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromOutfitDetails)
local ReceivedBundleInfoForTryOn = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ReceivedBundleInfoForTryOn
local UpdateSortOrderDueToLCBundleLoaded = require(Modules.AvatarExperience.Catalog.Thunks.UpdateSortOrderDueToLCBundleLoaded)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SetOutfitOrAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOutfitOrAsset)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local mutedError = require(Modules.LuaApp.mutedError)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local v20 = game:DefineFastFlag("AXSilenceGetOutfitMutedError", false)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXEnableExpiredUserLookCheckout = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableExpiredUserLookCheckout
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)

local function keyMapper(p1) -- line: 43
	-- upvalues: Constants (copy)
	return Constants.OutfitInfoKey .. tostring(p1)
end
local function checkAssetExists(p2, p3) -- line: 47
	local v30 = p2.AvatarExperience.Common.AssetInfos[p3]

	if v30 and v30.receivedFromOutfitDetails then
		if v30.outfitModerationStatus == Enum.ModerationStatus.NotReviewed then
			return false
		end

		return true
	end

	return false
end

return function(s1: string, n1: number?, s2: string?, p4, b1: boolean?) -- line: 61
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), FFlagAXEnableExpiredUserLookCheckout (copy), Promise (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), WebApi (copy), Utils (copy), OutfitInfo (copy), SetAssetInfoFromOutfitDetails (copy), SetOutfitInfo (copy), SetOutfitOrAsset (copy), Constants2 (copy), ReceivedBundleInfoForTryOn (copy), UpdateSortOrderDueToLCBundleLoaded (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), Logging (copy), v20 (copy), mutedError (copy)
	ArgCheck.isType(s1, "string", "GetOutfit thunk expects outfitId to be a string")
	ArgCheck.isTypeOrNil(b1, "boolean", "GetOutfit thunk expects forceRefresh to be a boolean or nil")

	return function(p5, p6) -- line: 70
		-- upvalues: PerformFetch (copy), s1 (copy), Constants (copy), FFlagAXEnableExpiredUserLookCheckout (copy), b1 (copy), Promise (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p4 (copy), WebApi (copy), Utils (copy), OutfitInfo (copy), n1 (copy), SetAssetInfoFromOutfitDetails (copy), SetOutfitInfo (copy), SetOutfitOrAsset (copy), Constants2 (copy), s2 (copy), ReceivedBundleInfoForTryOn (copy), UpdateSortOrderDueToLCBundleLoaded (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), Logging (copy), v20 (copy), mutedError (copy)
		local avatarEditorService = p6.avatarEditorService
		local Single = PerformFetch.Single
		local v40 = s1

		return Single(Constants.OutfitInfoKey .. tostring(v40), function(p7) -- line: 72
			-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), b1 (copy), s1 (copy), Promise (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p4 (copy), avatarEditorService (copy), WebApi (copy), Utils (copy), OutfitInfo (copy), n1 (copy), SetAssetInfoFromOutfitDetails (copy), SetOutfitInfo (copy), SetOutfitOrAsset (copy), Constants2 (copy), s2 (copy), ReceivedBundleInfoForTryOn (copy), UpdateSortOrderDueToLCBundleLoaded (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), Logging (copy), v20 (copy), mutedError (copy)
			local v42 = p7:getState()

			if (not FFlagAXEnableExpiredUserLookCheckout or not b1) and v42.AvatarExperience.AvatarEditor.OutfitInfos[s1] then
				return Promise.resolve()
			end

			return Promise.new(function(resolve, reject) -- line: 82
				-- upvalues: FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), p4 (copy), avatarEditorService (copy), s1 (copy), WebApi (copy), Utils (copy), OutfitInfo (copy), n1 (copy), v42 (copy), p7 (copy), SetAssetInfoFromOutfitDetails (copy), SetOutfitInfo (copy), SetOutfitOrAsset (copy), Constants2 (copy), s2 (copy), ReceivedBundleInfoForTryOn (copy), UpdateSortOrderDueToLCBundleLoaded (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants3 (copy), Logging (copy), v20 (copy), mutedError (copy)
				local v45 = FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables
				local ok, result = pcall(function() -- line: 85
					-- upvalues: v45 (copy), p4 (copy), avatarEditorService (copy), s1 (copy), WebApi (copy), reject (copy)
					if not v45 or not p4 then
						if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
							return avatarEditorService:GetOutfitDetailsAsync(tonumber(s1) or 0)
						end

						return avatarEditorService:GetOutfitDetails(tonumber(s1) or 0)
					end

					local v61, v62 = WebApi.GetOutfit(p4, s1, {
						checkAssetAvailability = true
					}):await()

					if not v61 then
						return reject(`AvatarEditorWebApi failure in GetOutfit: { tostring(v62) }`)
					end

					return v62[1]
				end)

				if ok then
					local v48 = Utils.tableToCamelCaseKeys(result)

					if v48 then
						if not v45 or not p4 then
							v48.bodyColor3s = {}

							if v48.bodyColors then
								for v49, v50 in v48.bodyColors do
									v48.bodyColor3s[v49 .. "3"] = v50:ToHex()
								end

								v48.bodyColors = nil
							end
						end

						local t1 = {}
						local assets = v48.assets
						local t2 = {}
						local v54 = OutfitInfo.fromWebApi(s1, n1, v48)

						if assets then
							for _, v56 in assets do
								local str = tostring(v56.assetType.id)
								local str2 = tostring(v56.id)

								t1[str] = t1[str] or {}
								table.insert(t1[str], str2)

								local v59 = v42.AvatarExperience.Common.AssetInfos[str2]

								if not v59 or (not v59.receivedFromOutfitDetails or v59.outfitModerationStatus == Enum.ModerationStatus.NotReviewed) then
									t2[#t2 + 1] = v56
								end
							end
						end

						if #t2 > 0 then
							p7:dispatch(SetAssetInfoFromOutfitDetails(t2, v54.moderationStatus))
						end

						p7:dispatch(SetOutfitInfo(v54))

						local OutfitOrAsset = v42.AvatarExperience.AvatarEditor.Character.OutfitOrAsset

						if OutfitOrAsset and not OutfitOrAsset[s1] then
							p7:dispatch(SetOutfitOrAsset({ (tostring(s1)) }, Constants2.OutfitOrAsset.Outfit))
						end

						if s2 then
							p7:dispatch(ReceivedBundleInfoForTryOn(s2, (tostring(s1))))
							p7:dispatch(UpdateSortOrderDueToLCBundleLoaded(s2))
						end
					end

					resolve(result)

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants3.Counter.AvatarEditorServiceErrors.GetOutfitDetails)
				end

				Logging.warn("AvatarEditorService failure in GetOutfitDetails for id " .. s1)

				if not v20 then
					mutedError(`[AvatarExperience] Error fetching outfit details for ID { s1 }. Reason: { tostring(result) }`)
				end

				reject(`AvatarEditorService failure in GetOutfitDetails for outfit ID { s1 }: { tostring(result) }`)
			end)
		end)(p5)
	end
end
