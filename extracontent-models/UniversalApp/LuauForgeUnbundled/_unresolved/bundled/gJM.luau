local HttpService = game:GetService("HttpService")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module2 = require("@luauforge/bundled/dKU")

local module3 = require("@luauforge/bundled/dRP")
local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/bundled/dRf")
local module6 = require("@luauforge/bundled/dRi")
local module7 = require("@luauforge/bundled/gJN")
local clearTryOns = module2.Actions.ClearTryOns
local applyProfileConfiguration = module2.Actions.ApplyProfileConfiguration
local module8 = require("@luauforge/bundled/dPk")
local module9 = require("@luauforge/bundled/fCI")
local module10 = require("@luauforge/bundled/dzP")
local module11 = require("@luauforge/bundled/dXh")
local module12 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")

local module13 = require("@luauforge/bundled/dSb")
local module14 = require("@luauforge/bundled/dRs")
local inventoryItemAvailability = require("@luauforge/bundled/fCn").Enums.InventoryItemAvailability

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local fFlagAXLogFacialAnimationOnHeadChange = AvatarExperienceFlags.FFlagAXLogFacialAnimationOnHeadChange
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local inventoryOutfitType = require("@luauforge/bundled/dPt").Enums.InventoryOutfitType
local getEquippedAvatarOutfitIdStore = AvatarExperienceCommon.Stores.getEquippedAvatarOutfitIdStore
local fFlagEnableSplitPaneAvatarOverlay = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneAvatarOverlay

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local defineFastFlag = game:DefineFastFlag("AXMakeAnalyticsOptionalInEquipOutfit", false)

local v5 = {
	Torso = "27",
	RightArm = "28",
	LeftArm = "29",
	LeftLeg = "30",
	RightLeg = "31"
}

local function isFullyQualifiedOutfit(p2): boolean
	for k, v6 in v5 do
		if not p2[v6] then
			return false
		end
	end

	return true
end

local function getEquippedDynamicHeadInfo(p2)
	local v6 = p2[module12.AssetTypeIdStrings.DynamicHead]

	if v6 then
		for k, v7 in v6 do
			return k, v7.staticFacialAnimation
		end
	end

	return nil, nil
end

local function logFacialAnimationChangeOnHeadSwap(equippedAssets, equippedAssets2)
	local v6 = equippedAssets[module12.AssetTypeIdStrings.DynamicHead]
	local staticFacialAnimation, v7

	if v6 then
		local flag = true

		for k, v8 in v6 do
			staticFacialAnimation = v8.staticFacialAnimation
			v7 = k
			flag = false
			break
		end

		if flag then
			staticFacialAnimation = nil
		end
	end

	local v8 = equippedAssets2[module12.AssetTypeIdStrings.DynamicHead]
	local staticFacialAnimation2, v9

	if v8 then
		local flag = true

		for k, v10 in v8 do
			staticFacialAnimation2 = v10.staticFacialAnimation
			v9 = k
			flag = false
			break
		end

		if flag then
			staticFacialAnimation2 = nil
		end
	end

	if v7 ~= v9 and v9 ~= nil and staticFacialAnimation ~= staticFacialAnimation2 then
		sendUnifiedEventLog({
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			elementName = "FACIAL_ANIMATION_TOGGLE",
			surface = unifiedLoggingSurface.CUSTOMIZE,
			itemId = tostring(v9),
			elementMetadata = HttpService:JSONEncode({
				trigger = "HEAD_CHANGE",
				change_from_FACS_status = tostring(not staticFacialAnimation),
				change_to_FACS_status = tostring(not staticFacialAnimation2)
			})
		})
	end
end

local function applyOutfitBackground(object, p2)
	if module9.isPresetOutfit(p2) then
		return
	end

	local profileConfiguration = p2.profileConfiguration
	local v6 = if profileConfiguration == nil or profileConfiguration.BackgroundAssetId == nil then AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID else profileConfiguration.BackgroundAssetId
	object:dispatch(applyProfileConfiguration({ BackgroundAssetId = v6 }))
end

local function recordEquippedAvatarOutfitBaseline(data)
	if data.outfitType ~= module12.OutfitTypes.Avatar or not data.isEditable or data.outfitId == nil then
		return
	end

	local outfitId = tostring(data.outfitId)
	getEquippedAvatarOutfitIdStore(false).setLastEquippedAvatarOutfitId(outfitId)
end

return function(data)
	local v6 = data.outfitInfo
	local analytics = data.analytics
	local navigation = data.navigation
	local isSelected = data.isSelected
	local fromOutfitPurchase = data.fromOutfitPurchase
	local tryOnBundleInfo = data.tryOnBundleInfo
	local blockFullReset = data.blockFullReset

	return function(object): boolean
		module10.isType(v6, "table", "EquipOutfit thunk expects outfitInfo to be a table")

		if fFlagEnableSplitPaneAvatarOverlay then
			module10.isTypeOrNil(analytics, "table", "EquipOutfit thunk expects analytics")
			module10.isTypeOrNil(navigation, "table", "EquipOutfit thunk expects navigation")
		else
			if defineFastFlag then
				module10.isTypeOrNil(analytics, "table", "EquipOutfit thunk expects analytics")
			else
				module10.isType(analytics, "table", "EquipOutfit thunk expects analytics")
			end

			module10.isType(navigation, "table", "EquipOutfit thunk expects navigation")
		end

		module10.isTypeOrNil(blockFullReset, "boolean", "EquipOutfit thunk expects blockFullReset")

		v6 = if fFlagAXModeratedItemsFlow then module9.filterOutfitAssetsWithStatus(v6, {
			inventoryItemAvailability.Unavailable,
			inventoryItemAvailability.Revoked
		}) else v6

		local v8 = v6.outfitType == module12.OutfitTypes.Avatar

		if not (v6.isEditable and v8) then
			if module13() then
				v8 = module9.isFullyQualifiedOutfit(v6.assets)
			else
				local assets = v6.assets
				local flag = true

				for k, v9 in v5 do
					if not assets[v9] then
						v8 = false
						flag = false
						break
					end
				end

				if flag then
					v8 = true
				end
			end
		end

		if analytics then
			analytics.outfitClicked(v6.outfitId, v6.outfitType, v6.isEditable)
		end

		local v9 = v6.outfitType == module12.OutfitTypes.DynamicHead

		if v9 then
			for k, dynamicHeadAssetType in module12.DynamicHeadAssetTypes do
				if not v6.assets[k] then
					v6.assets[k] = {}
				end
			end

			v6.assets[module12.AssetTypeIdStrings.Head] = {}

			v6.assets[module12.AssetTypeIdStrings.Face] = {}
		end

		local v10 = if module14() then v6.outfitType == module12.OutfitTypes.Shoes else nil
		local v11

		if module14() then
			if fFlagAXMigrateOutfitsToUserInventory then
				v11 = v6.inventoryType == inventoryOutfitType.Animations
			else
				v11 = v6.inventoryType == module12.OutfitTypes.Animations
			end
		end

		if (v9 or module14() and v10 or module14() and v11) and isSelected then
			object:dispatch(module4(v6.assets))
			return false
		end

		if v6.outfitType == module12.OutfitTypes.Makeup then
			for k, v12 in {
				module12.AssetTypeIdStrings.EyebrowAccessory,
				module12.AssetTypeIdStrings.EyelashAccessory,
				module12.AssetTypeIdStrings.FaceMakeup,
				module12.AssetTypeIdStrings.EyeMakeup,
				module12.AssetTypeIdStrings.LipMakeup
			} do
				if not v6.assets[v12] then
					v6.assets[v12] = {}
				end
			end
		end

		local v12 = {}

		for k, v13 in {
			module12.AssetTypeIdStrings.FaceMakeup,
			module12.AssetTypeIdStrings.EyeMakeup,
			module12.AssetTypeIdStrings.LipMakeup
		} do
			if not v6.assets[v13] then
				continue
			end

			for k2, v14 in v6.assets[v13] do
				table.insert(v12, { itemId = k2, assetTypeId = v13, metadata = v14 })
			end
		end

		table.sort(v12, function(a, b): boolean
			return a.metadata.order ~= nil
				and (b.metadata.order == nil or a.metadata.order < b.metadata.order)
		end)

		for k, v13 in v12 do
			v6.assets[v13.assetTypeId][v13.itemId].order = k - 1
		end

		local equippedAssets

		if fFlagAXLogFacialAnimationOnHeadChange and fFlagHeadRefinementFacialAnimationToggle then
			local state = object:getState()
			equippedAssets = state.AvatarExperience
				and state.AvatarExperience.AvatarEditor
				and state.AvatarExperience.AvatarEditor.Character
				and state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		end

		object:dispatch(module8())

		if tryOnBundleInfo then
			local v13 = {}

			for k, asset in v6.assets do
				local v14 = {}

				for k2, v15 in asset do
					if v15.order and tryOnBundleInfo[k2] and tryOnBundleInfo[k2].order then
						v15.order = tryOnBundleInfo[k2].order
					end

					v14[k2] = v15
				end

				v13[k] = v14
			end

			object:dispatch(module3(module9.removeEmoteAnimationAsset(v13), not blockFullReset and v8))
		else
			object:dispatch(module3(module9.removeEmoteAnimationAsset(v6.assets), v8))
		end

		if
			fFlagAXLogFacialAnimationOnHeadChange
			and fFlagHeadRefinementFacialAnimationToggle
			and equippedAssets
		then
			logFacialAnimationChangeOnHeadSwap(
				equippedAssets,
				object:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
			)
		end

		if not fromOutfitPurchase then
			object:dispatch(clearTryOns())

			if fFlagEnableSplitPaneAvatarOverlay then
				if navigation then
					module11.closeFiltersAndItemDetails(navigation)
				end
			else
				module11.closeFiltersAndItemDetails(navigation)
			end
		end

		local defaultBodyColorRanges = object:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

		if v8 then
			if not module9.isPresetOutfit(v6) then
				object:dispatch(module7(v6.bodyColor3s, defaultBodyColorRanges))
			end

			object:dispatch(module6(v6.scales))
			object:dispatch(module5(v6.avatarType))

			if fFlagAXBackgroundsOutfitPersistence then
				applyOutfitBackground(object, v6)
			end
		end

		if not fFlagEnableSplitPaneAvatarOverlay then
			return true
		end

		local v13 = v6

		if v13.outfitType == module12.OutfitTypes.Avatar and v13.isEditable and v13.outfitId ~= nil then
			local outfitId = tostring(v13.outfitId)
			getEquippedAvatarOutfitIdStore(false).setLastEquippedAvatarOutfitId(outfitId)
		end

		return true
	end
end
