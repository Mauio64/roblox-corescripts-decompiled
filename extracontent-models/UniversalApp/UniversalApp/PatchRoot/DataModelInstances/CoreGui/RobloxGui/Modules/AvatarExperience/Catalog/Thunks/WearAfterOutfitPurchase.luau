local CorePackages = game:GetService("CorePackages")
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local SetBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColor3s)
local AvatarWidgetBlockyUtils = require(Modules.AvatarExperience.Common.Util.AvatarWidgetBlockyUtils)
local UpdateAvatarEquips = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateAvatarEquips)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AddSaveDelay = AvatarExperienceRodux.Actions.AddSaveDelay
local FFlagParseHeadShapeFromAPIResponse = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagHeadRefinementFacialAnimationToggle
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType = AvatarExperienceFlags.FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType
local t1 = {
	Constants.AssetTypeIdStrings.Torso,
	Constants.AssetTypeIdStrings.RightArm,
	Constants.AssetTypeIdStrings.LeftArm,
	Constants.AssetTypeIdStrings.LeftLeg,
	Constants.AssetTypeIdStrings.RightLeg
}

local function isFullyQualifiedOutfit(p1) -- line: 48
	-- upvalues: t1 (copy)
	for _, v23 in t1 do
		if not p1[v23] then
			return false
		end
	end

	return true
end

return function(p2, p3, p4, _) -- line: 58
	-- upvalues: AvatarWidgetBlockyUtils (copy), FFlagAXMakeupEquipping (copy), Constants (copy), ToggleEquipAsset (copy), SetBodyColor3s (copy), SetAvatarScales (copy), Cryo (copy), AddSaveDelay (copy), Utils (copy), t1 (copy), EquipOutfit (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), UpdateAvatarEquips (copy)
	return function(p6) -- line: 59
		-- upvalues: AvatarWidgetBlockyUtils (copy), FFlagAXMakeupEquipping (copy), Constants (copy), ToggleEquipAsset (copy), p3 (copy), SetBodyColor3s (copy), SetAvatarScales (copy), Cryo (copy), p2 (copy), AddSaveDelay (copy), Utils (copy), t1 (copy), p4 (copy), EquipOutfit (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType (copy), UpdateAvatarEquips (copy)
		local v29 = p6:getState()
		local AssetInfos = v29.AvatarExperience.Common.AssetInfos
		local v31 = AvatarWidgetBlockyUtils.buildEquippedBodyStateMap(v29)
		local t2 = {}
		local EquippedAssets = v29.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local LookId = v29.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local LookType = v29.AvatarExperience.AvatarScene.OutfitTryOn.LookType
		local g58 = nil
		local v57 = nil

		if EquippedAssets and LookId then
			if FFlagAXMakeupEquipping then
				local t3 = {}

				if LookType == Constants.LookType.Makeup then
					t3[Constants.AssetCategories.Makeup] = true
				else
					t3[Constants.AssetCategories.Accessory] = true
					t3[Constants.AssetCategories.Clothing] = true
					t3[Constants.AssetCategories.Makeup] = true
				end

				for v37, v38 in EquippedAssets do
					local v39 = Constants.AssetTypeIdToCategory[v37]
					local v40 = LookType == Constants.LookType.Avatar and (v31 and v31[v37])

					if t3[v39] or v40 then
						for v41, _ in v38 do
							if t2 then
								table.insert(t2, {
									assetTypeId = v37,
									assetId = v41
								})
							else
								p6:dispatch(ToggleEquipAsset(v37, v41, p3, true))
							end
						end
					end
				end
			else
				for v43, v44 in EquippedAssets do
					local v45 = Constants.AssetTypeIdToCategory[v43]

					if v45 == Constants.AssetCategories.Accessory or v45 == Constants.AssetCategories.Clothing or LookType == Constants.LookType.Avatar and v31 and v31[v43] then
						for v46, _ in v44 do
							if t2 then
								table.insert(t2, {
									assetTypeId = v43,
									assetId = v46
								})
							else
								p6:dispatch(ToggleEquipAsset(v43, v46, p3, true))
							end
						end
					end
				end
			end
		end

		local BodyColor3s = v29.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
		local OutfitTryOnScale = v29.AvatarExperience.AvatarScene.OutfitTryOn.Scale

		if BodyColor3s then
			p6:dispatch(SetBodyColor3s(BodyColor3s))
		end

		if OutfitTryOnScale then
			p6:dispatch(SetAvatarScales(OutfitTryOnScale))
		end

		local t4 = {}

		if not Cryo.isEmpty(p2) and not v29.AvatarExperience.AvatarScene.Character.ShouldDelaySaveManager then
			p6:dispatch(AddSaveDelay())
		end

		for _, v52 in p2 do
			if (v52.purchased or v52.owned) and not v52.assetIsWearable and v52.bundleId then
				local v53 = Utils.getOutfitInfoFromBundleId(v29, v52.bundleId)

				if v53 then
					local assets = v53.assets

					for _, v56 in t1 do
						if not assets[v56] then
							v57 = false
							g58 = true
						end

						if g58 then
							break
						end
					end

					if not g58 then
						v57 = true
					end

					g58 = false

					if v57 then
						local t5 = {
							isSelected = false,
							fromOutfitPurchase = true,
							blockFullReset = true,
							outfitInfo = v53,
							analytics = p4,
							navigation = p3,
							tryOnBundleInfo = v52.tryOnBundleInfo
						}

						p6:dispatch(EquipOutfit(t5))
						t4[v52.bundleId] = true
					end
				end
			end
		end

		for _, v61 in p2 do
			local v62 = if not v61.assetIsWearable then v61.bundleId else v61.assetId

			if (v61.purchased or v61.owned) and v62 then
				if v61.assetType == Constants.ItemType.Bundle then
					if t4[v62] == nil then
						local v63 = Utils.getOutfitInfoFromBundleId(v29, v62)
						local v64 = Utils.getBundleInfoFromState(v29, v62)
						local tryOnBundleInfo = v61.tryOnBundleInfo

						if v63 then
							local t6 = {
								isSelected = false,
								fromOutfitPurchase = true,
								outfitInfo = v63,
								analytics = p4,
								navigation = p3,
								tryOnBundleInfo = v61.tryOnBundleInfo
							}

							p6:dispatch(EquipOutfit(t6))
						elseif tryOnBundleInfo and LookType == Constants.LookType.Avatar then
							assert(tryOnBundleInfo, "")

							for v67, v68 in tryOnBundleInfo do
								local headShape = nil
								local staticFacialAnimation = nil

								if FFlagParseHeadShapeFromAPIResponse and v68.assetType == Constants.AssetTypeIdStrings.DynamicHead then
									headShape = v68.headShape

									if FFlagHeadRefinementFacialAnimationToggle then
										staticFacialAnimation = v68.staticFacialAnimation
									end
								end

								local assetType = v68.assetType
								local v72 = v29.AvatarExperience.AvatarEditor.Character.EquippedAssets[assetType]
								local v73 = false

								if v72 then
									for v74, _ in v72 do
										if v74 == v67 then
											v73 = true

											break
										end
									end

									if v73 then
										continue
									end
								end

								if t2 then
									local t7 = nil

									if FFlagParseHeadShapeFromAPIResponse and headShape ~= nil then
										t7 = {
											headShape = headShape
										}
									end

									local t8 = nil

									if FFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
										t8 = {
											staticFacialAnimation = staticFacialAnimation
										}
									end

									local v78 = if not t7 and not t8 then nil else Cryo.Dictionary.join(t7 or {}, t8 or {})

									table.insert(t2, {
										overrideOrder = nil,
										assetTypeId = v68.assetType,
										assetId = v67,
										overrideAdjustments = v78
									})
								else
									p6:dispatch(ToggleEquipAsset(v68.assetType, v67, p3, true, nil))
								end
							end
						elseif v64 then
							assert(v64, "")

							for _, v80 in v64.items do
								local v81 = AssetInfos[v80.id]

								if v81 and v81.assetType then
									local v82 = v61.tryOnBundleInfo and (v61.tryOnBundleInfo[v80.id] and v61.tryOnBundleInfo[v80.id].order)

									p6:dispatch(ToggleEquipAsset(v81.assetType, v80.id, p3, true, v82))
								end
							end
						end
					end
				elseif v61.itemSubType and tostring(v61.itemSubType) ~= Constants.AssetTypeIdStrings.EmoteAnimation then
					local overrideOrder = v61.overrideOrder
					local overrideAdjustments = v61.overrideAdjustments
					local v85 = if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else LookType == Constants.LookType.Avatar
					local v86 = if not FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then nil else LookType == Constants.LookType.Makeup

					if FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType and (v86 or v85) or t2 and LookType == Constants.LookType.Avatar then
						table.insert(t2, {
							assetTypeId = tostring(v61.itemSubType),
							assetId = tostring(v62),
							overrideOrder = overrideOrder,
							overrideAdjustments = overrideAdjustments
						})
					else
						p6:dispatch(ToggleEquipAsset(tostring(v61.itemSubType), tostring(v62), p3, true, overrideOrder, overrideAdjustments))
					end
				end
			end
		end

		if t2 and #t2 > 0 then
			p6:dispatch(UpdateAvatarEquips({
				assets = t2
			}))
		end
	end
end
