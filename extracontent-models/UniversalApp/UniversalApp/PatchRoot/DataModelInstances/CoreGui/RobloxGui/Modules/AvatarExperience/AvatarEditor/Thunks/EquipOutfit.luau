local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.EquipOutfit)
local UnequipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.UnequipOutfit)
local SetAvatarType = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarType)
local SetAvatarScales = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarScales)
local SetBodyColor3sFromOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetBodyColor3sFromOutfit)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns
local ApplyProfileConfiguration = AvatarExperienceRodux.Actions.ApplyProfileConfiguration
local StartedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.StartedWaitingOnLCUpdate)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local GetFFlagEnableNewCustomizeBundleEquip = require(Modules.AvatarExperience.Flags.GetFFlagEnableNewCustomizeBundleEquip)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXLogFacialAnimationOnHeadChange = AvatarExperienceFlags.FFlagAXLogFacialAnimationOnHeadChange
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local t1 = {
	Torso = "27",
	RightArm = "28",
	LeftArm = "29",
	LeftLeg = "30",
	RightLeg = "31"
}

local function isFullyQualifiedOutfit(p1) -- line: 63
	-- upvalues: t1 (copy)
	for _, v39 in t1 do
		if not p1[v39] then
			return false
		end
	end

	return true
end
local function getEquippedDynamicHeadInfo(t2: {[any]: any}) -- line: 72
	-- upvalues: Constants (copy)
	local v41 = t2[Constants.AssetTypeIdStrings.DynamicHead]

	if v41 then
		for v42, v43 in v41 do
			return v42, v43.staticFacialAnimation
		end
	end

	return nil, nil
end
local function logFacialAnimationChangeOnHeadSwap(t3: {[any]: any}, t4: {[any]: any}) -- line: 84
	-- upvalues: Constants (copy), sendUnifiedEventLog (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), HttpService (copy)
	local v46 = t3[Constants.AssetTypeIdStrings.DynamicHead]
	local g51 = nil
	local g57 = nil
	local v49 = nil
	local v55 = nil
	local staticFacialAnimation = nil
	local staticFacialAnimation2 = nil

	if v46 then
		for v47, v48 in v46 do
			v49 = v47
			staticFacialAnimation = v48.staticFacialAnimation
			g51 = true

			if g51 then
				break
			end
		end
	end

	if not g51 then
		v49 = nil
		staticFacialAnimation = nil
	end

	g51 = false

	local v52 = t4[Constants.AssetTypeIdStrings.DynamicHead]

	if v52 then
		for v53, v54 in v52 do
			v55 = v53
			staticFacialAnimation2 = v54.staticFacialAnimation
			g57 = true

			if g57 then
				break
			end
		end
	end

	if not g57 then
		v55 = nil
		staticFacialAnimation2 = nil
	end

	g57 = false

	if v49 ~= v55 and v55 ~= nil and staticFacialAnimation ~= staticFacialAnimation2 then
		sendUnifiedEventLog({
			elementName = "FACIAL_ANIMATION_TOGGLE",
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = UnifiedLoggingSurface.CUSTOMIZE,
			itemId = tostring(v55),
			elementMetadata = HttpService:JSONEncode({
				trigger = "HEAD_CHANGE",
				change_from_FACS_status = tostring(not staticFacialAnimation),
				change_to_FACS_status = tostring(not staticFacialAnimation2)
			})
		})
	end
end
local function applyOutfitBackground(p2, p3) -- line: 111
	-- upvalues: Utils (copy), AvatarExperienceCommon (copy), ApplyProfileConfiguration (copy)
	if Utils.isPresetOutfit(p3) then
		return
	end

	local profileConfiguration = p3.profileConfiguration
	local v61 = if profileConfiguration == nil or profileConfiguration.BackgroundAssetId == nil then AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID else profileConfiguration.BackgroundAssetId

	p2:dispatch(ApplyProfileConfiguration({
		BackgroundAssetId = v61
	}))
end

return function(t5: {[any]: any}) -- line: 133
	-- upvalues: ArgCheck (copy), FFlagAXModeratedItemsFlow (copy), Utils (copy), InventoryItemAvailability (copy), FFlagAXCustomizeMakeupSupport (copy), Constants (copy), GetFFlagEnableNewCustomizeBundleEquip (copy), t1 (copy), GetFFlagAXEnableSlotBasedEditor (copy), UnequipOutfit (copy), FFlagAXLogFacialAnimationOnHeadChange (copy), FFlagHeadRefinementFacialAnimationToggle (copy), StartedWaitingOnLCUpdate (copy), EquipOutfit (copy), logFacialAnimationChangeOnHeadSwap (copy), ClearTryOns (copy), NavigationUtils (copy), SetBodyColor3sFromOutfit (copy), SetAvatarScales (copy), SetAvatarType (copy), FFlagAXBackgroundsOutfitPersistence (copy), applyOutfitBackground (copy)
	local outfitInfo = t5.outfitInfo
	local analytics = t5.analytics
	local navigation = t5.navigation
	local isSelected = t5.isSelected
	local fromOutfitPurchase = t5.fromOutfitPurchase
	local tryOnBundleInfo = t5.tryOnBundleInfo
	local blockFullReset = t5.blockFullReset

	return function(p4) -- line: 142
		-- upvalues: ArgCheck (copy), outfitInfo (ref), analytics (copy), navigation (copy), blockFullReset (copy), FFlagAXModeratedItemsFlow (copy), Utils (copy), InventoryItemAvailability (copy), FFlagAXCustomizeMakeupSupport (copy), Constants (copy), GetFFlagEnableNewCustomizeBundleEquip (copy), t1 (copy), GetFFlagAXEnableSlotBasedEditor (copy), isSelected (copy), UnequipOutfit (copy), FFlagAXLogFacialAnimationOnHeadChange (copy), FFlagHeadRefinementFacialAnimationToggle (copy), StartedWaitingOnLCUpdate (copy), tryOnBundleInfo (copy), EquipOutfit (copy), logFacialAnimationChangeOnHeadSwap (copy), fromOutfitPurchase (copy), ClearTryOns (copy), NavigationUtils (copy), SetBodyColor3sFromOutfit (copy), SetAvatarScales (copy), SetAvatarType (copy), FFlagAXBackgroundsOutfitPersistence (copy), applyOutfitBackground (copy)
		ArgCheck.isType(outfitInfo, "table", "EquipOutfit thunk expects outfitInfo to be a table")
		ArgCheck.isType(analytics, "table", "EquipOutfit thunk expects analytics")
		ArgCheck.isType(navigation, "table", "EquipOutfit thunk expects navigation")
		ArgCheck.isTypeOrNil(blockFullReset, "boolean", "EquipOutfit thunk expects blockFullReset")
		outfitInfo = if not FFlagAXModeratedItemsFlow then outfitInfo else Utils.filterOutfitAssetsWithStatus(outfitInfo, {
			InventoryItemAvailability.Unavailable,
			InventoryItemAvailability.Revoked
		})

		local v71 = if not FFlagAXCustomizeMakeupSupport then nil else outfitInfo.outfitType == Constants.OutfitTypes.Avatar
		local v72 = if not FFlagAXCustomizeMakeupSupport then outfitInfo.isEditable else outfitInfo.isEditable and v71
		local g76

		if not v72 then
			if GetFFlagEnableNewCustomizeBundleEquip() then
				v72 = Utils.isFullyQualifiedOutfit(outfitInfo.assets)
			else
				local assets = outfitInfo.assets

				g76 = nil

				for _, v75 in t1 do
					if not assets[v75] then
						v72 = false
						g76 = true
					end

					if g76 then
						break
					end
				end

				if not g76 then
					v72 = true
				end
			end
		end

		g76 = false

		if analytics then
			analytics.outfitClicked(outfitInfo.outfitId, outfitInfo.outfitType, outfitInfo.isEditable)
		end

		local v77 = outfitInfo.outfitType == Constants.OutfitTypes.DynamicHead

		if v77 then
			for v78, _ in Constants.DynamicHeadAssetTypes do
				if not outfitInfo.assets[v78] then
					outfitInfo.assets[v78] = {}
				end
			end

			outfitInfo.assets[Constants.AssetTypeIdStrings.Head] = {}
			outfitInfo.assets[Constants.AssetTypeIdStrings.Face] = {}
		end

		local v80 = if not GetFFlagAXEnableSlotBasedEditor() then nil else outfitInfo.outfitType == Constants.OutfitTypes.Shoes
		local v81 = if not GetFFlagAXEnableSlotBasedEditor() then nil else outfitInfo.inventoryType == Constants.OutfitTypes.Animations

		if (v77 or GetFFlagAXEnableSlotBasedEditor() and v80 or GetFFlagAXEnableSlotBasedEditor() and v81) and isSelected then
			p4:dispatch(UnequipOutfit(outfitInfo.assets))

			return false
		end

		local v82 = if not FFlagAXCustomizeMakeupSupport then nil else outfitInfo.outfitType == Constants.OutfitTypes.Makeup

		if FFlagAXCustomizeMakeupSupport and v82 then
			for _, v84 in {
				Constants.AssetTypeIdStrings.EyebrowAccessory,
				Constants.AssetTypeIdStrings.EyelashAccessory,
				Constants.AssetTypeIdStrings.FaceMakeup,
				Constants.AssetTypeIdStrings.EyeMakeup,
				Constants.AssetTypeIdStrings.LipMakeup
			} do
				if not outfitInfo.assets[v84] then
					outfitInfo.assets[v84] = {}
				end
			end
		end

		if FFlagAXCustomizeMakeupSupport then
			local t6 = {}

			for _, v87 in {
				Constants.AssetTypeIdStrings.FaceMakeup,
				Constants.AssetTypeIdStrings.EyeMakeup,
				Constants.AssetTypeIdStrings.LipMakeup
			} do
				if outfitInfo.assets[v87] then
					for v88, v89 in outfitInfo.assets[v87] do
						table.insert(t6, {
							itemId = v88,
							assetTypeId = v87,
							metadata = v89
						})
					end
				end
			end

			table.sort(t6, function(p5, p6) -- line: 250
				return p5.metadata.order ~= nil and (p6.metadata.order == nil or p5.metadata.order < p6.metadata.order)
			end)

			for v90, v91 in t6 do
				outfitInfo.assets[v91.assetTypeId][v91.itemId].order = v90 - 1
			end
		end

		local v92 = nil

		if FFlagAXLogFacialAnimationOnHeadChange and FFlagHeadRefinementFacialAnimationToggle then
			local v93 = p4:getState()

			v92 = v93.AvatarExperience and (v93.AvatarExperience.AvatarEditor and (v93.AvatarExperience.AvatarEditor.Character and v93.AvatarExperience.AvatarEditor.Character.EquippedAssets))
		end

		p4:dispatch(StartedWaitingOnLCUpdate())

		if tryOnBundleInfo then
			local t7 = {}

			for v95, v96 in outfitInfo.assets do
				local t8 = {}

				for v98, v99 in v96 do
					if v99.order and tryOnBundleInfo[v98] and tryOnBundleInfo[v98].order then
						v99.order = tryOnBundleInfo[v98].order
					end

					t8[v98] = v99
				end

				t7[v95] = t8
			end

			local v100 = v72

			if blockFullReset then
				v100 = false
			end

			p4:dispatch(EquipOutfit(Utils.removeEmoteAnimationAsset(t7), v100))
		else
			p4:dispatch(EquipOutfit(Utils.removeEmoteAnimationAsset(outfitInfo.assets), v72))
		end

		if FFlagAXLogFacialAnimationOnHeadChange and FFlagHeadRefinementFacialAnimationToggle and v92 then
			local EquippedAssets = p4:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

			logFacialAnimationChangeOnHeadSwap(v92, EquippedAssets)
		end

		if not fromOutfitPurchase then
			p4:dispatch(ClearTryOns())
			NavigationUtils.closeFiltersAndItemDetails(navigation)
		end

		local DefaultBodyColorRanges = p4:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

		if v72 then
			if not Utils.isPresetOutfit(outfitInfo) then
				p4:dispatch(SetBodyColor3sFromOutfit(outfitInfo.bodyColor3s, DefaultBodyColorRanges))
			end

			p4:dispatch(SetAvatarScales(outfitInfo.scales))
			p4:dispatch(SetAvatarType(outfitInfo.avatarType))

			if FFlagAXBackgroundsOutfitPersistence then
				applyOutfitBackground(p4, outfitInfo)
			end
		end

		return true
	end
end
