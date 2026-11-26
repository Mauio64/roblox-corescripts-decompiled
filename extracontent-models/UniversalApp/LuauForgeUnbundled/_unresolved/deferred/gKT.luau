local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/dKU")
local Cryo = require(CorePackages.Packages.Cryo)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local module2 = require("@luauforge/bundled/fCe")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/bundled/gJM")
local module6 = require("@luauforge/bundled/fCH")
local module7 = require("@luauforge/bundled/dRi")
local module8 = require("@luauforge/bundled/dRm")
local module9 = require("@luauforge/bundled/gKU")
local module10 = require("@luauforge/bundled/dRN")

require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dKT")
local addSaveDelay = module.Actions.AddSaveDelay

local fFlagParseHeadShapeFromAPIResponse = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagParseHeadShapeFromAPIResponse

local fFlagHeadRefinementFacialAnimationToggle = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagHeadRefinementFacialAnimationToggle

local fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType = AvatarExperienceFlags.FFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType

local v5 = {
	module4.AssetTypeIdStrings.Torso,
	module4.AssetTypeIdStrings.RightArm,
	module4.AssetTypeIdStrings.LeftArm,
	module4.AssetTypeIdStrings.LeftLeg,
	module4.AssetTypeIdStrings.RightLeg
}

local function isFullyQualifiedOutfit(p2): boolean
	for k, v6 in v5 do
		if not p2[v6] then
			return false
		end
	end

	return true
end

return function(items, p2, p3, p4)
	return function(object)
		local state = object:getState()
		local assetInfos = state.AvatarExperience.Common.AssetInfos
		local equippedBodyStateMap = module9.buildEquippedBodyStateMap(state)

		local v6 = {}

		local equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local lookId = state.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local lookType = state.AvatarExperience.AvatarScene.OutfitTryOn.LookType

		if equippedAssets and lookId then
			local set = {}

			if lookType ~= module4.LookType.Makeup then
				set[module4.AssetCategories.Accessory] = true
				set[module4.AssetCategories.Clothing] = true
			end

			set[module4.AssetCategories.Makeup] = true

			for k, equippedAsset in equippedAssets do
				local category = module4.AssetTypeIdToCategory[k]
				local v7 = lookType == module4.LookType.Avatar
					and (equippedBodyStateMap and equippedBodyStateMap[k])

				if not (set[category] or v7) then
					continue
				end

				for k2, v8 in equippedAsset do
					if v6 then
						table.insert(v6, { assetTypeId = k, assetId = k2 })
					else
						object:dispatch(module6(k, k2, p2, true))
					end
				end
			end
		end

		local bodyColor3s = state.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
		local scale = state.AvatarExperience.AvatarScene.OutfitTryOn.Scale

		if bodyColor3s then
			object:dispatch(module8(bodyColor3s))
		end

		if scale then
			object:dispatch(module7(scale))
		end

		local bundleIdSet = {}

		if not (Cryo.isEmpty(items) or state.AvatarExperience.AvatarScene.Character.ShouldDelaySaveManager) then
			object:dispatch(addSaveDelay())
		end

		for k, item in items do
			if not (item.purchased or item.owned) or item.assetIsWearable or not item.bundleId then
				continue
			end

			local outfitInfoFromBundleId = module2.getOutfitInfoFromBundleId(state, item.bundleId)

			if not outfitInfoFromBundleId then
				continue
			end

			local assets = outfitInfoFromBundleId.assets
			local flag = true
			local flag2

			for k2, v7 in v5 do
				if not assets[v7] then
					flag2 = false
					flag = false
					break
				end
			end

			if flag then
				flag2 = true
			end

			if not flag2 then
				continue
			end

			object:dispatch(module5({
				outfitInfo = outfitInfoFromBundleId,
				analytics = p3,
				navigation = p2,
				isSelected = false,
				fromOutfitPurchase = true,
				tryOnBundleInfo = item.tryOnBundleInfo,
				blockFullReset = true
			}))

			bundleIdSet[item.bundleId] = true
		end

		for k, item in items do
			local v7 = if item.assetIsWearable then item.assetId else item.bundleId

			if not ((item.purchased or item.owned) and v7) then
				continue
			end

			if item.assetType == module4.ItemType.Bundle then
				if bundleIdSet[v7] == nil then
					local outfitInfoFromBundleId = module2.getOutfitInfoFromBundleId(state, v7)
					local bundleInfoFromState = module2.getBundleInfoFromState(state, v7)
					local tryOnBundleInfo = item.tryOnBundleInfo

					if outfitInfoFromBundleId then
						object:dispatch(module5({
							outfitInfo = outfitInfoFromBundleId,
							analytics = p3,
							navigation = p2,
							isSelected = false,
							fromOutfitPurchase = true,
							tryOnBundleInfo = item.tryOnBundleInfo
						}))
					elseif tryOnBundleInfo and lookType == module4.LookType.Avatar then
						assert(tryOnBundleInfo, "")

						for k2, v8 in tryOnBundleInfo do
							local staticFacialAnimation = nil
							local headShape

							if
								fFlagParseHeadShapeFromAPIResponse
								and v8.assetType == module4.AssetTypeIdStrings.DynamicHead
							then
								headShape = v8.headShape

								if fFlagHeadRefinementFacialAnimationToggle then
									staticFacialAnimation = v8.staticFacialAnimation
								end
							end

							local assetType = v8.assetType
							local equippedAsset = state.AvatarExperience.AvatarEditor.Character.EquippedAssets[assetType]

							local flag = false

							if equippedAsset then
								for k3, v10 in equippedAsset do
									if k3 == k2 then
										flag = true
										break
									end
								end

								if flag then
									continue
								end
							end

							if v6 then
								local v9 = fFlagParseHeadShapeFromAPIResponse
									and headShape ~= nil
									and { headShape = headShape }
									or nil

								local v10 = fFlagHeadRefinementFacialAnimationToggle
									and staticFacialAnimation ~= nil
									and {
										staticFacialAnimation = staticFacialAnimation
									}
									or nil

								local v11 = if v9 or v10 then Cryo.Dictionary.join(v9 or {}, v10 or {}) else nil

								table.insert(v6, {
									assetTypeId = v8.assetType,
									assetId = k2,
									overrideOrder = nil,
									overrideAdjustments = v11
								})
							else
								object:dispatch(module6(v8.assetType, k2, p2, true, nil))
							end
						end
					elseif bundleInfoFromState then
						assert(bundleInfoFromState, "")

						for k2, item2 in bundleInfoFromState.items do
							local assetInfo = assetInfos[item2.id]

							if not (assetInfo and assetInfo.assetType) then
								continue
							end

							local order = item.tryOnBundleInfo
								and item.tryOnBundleInfo[item2.id]
								and item.tryOnBundleInfo[item2.id].order
							object:dispatch(module6(assetInfo.assetType, item2.id, p2, true, order))
						end
					end
				end
			elseif
				item.itemSubType
				and tostring(item.itemSubType) ~= module4.AssetTypeIdStrings.EmoteAnimation
			then
				local overrideOrder = item.overrideOrder
				local overrideAdjustments = item.overrideAdjustments
				local v8

				if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then
					v8 = lookType == module4.LookType.Avatar
				end

				local v9

				if fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType then
					v9 = lookType == module4.LookType.Makeup
				end

				if
					fFlagAXUnifiedPurchasePromptMakeupLooksSaveLookType and (v9 or v8)
					or v6 and lookType == module4.LookType.Avatar
				then
					table.insert(v6, {
						assetTypeId = tostring(item.itemSubType),
						assetId = tostring(v7),
						overrideOrder = overrideOrder,
						overrideAdjustments = overrideAdjustments
					})
				else
					object:dispatch(module6(
						tostring(item.itemSubType),
						tostring(v7),
						p2,
						true,
						overrideOrder,
						overrideAdjustments
					))
				end
			end
		end

		if v6 and #v6 > 0 then
			object:dispatch(module10({ assets = v6 }))
		end
	end
end
