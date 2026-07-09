local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local mutedError = require(Modules.LuaApp.mutedError)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local SetEquippedDynamicHeadShape = AvatarExperienceHeadRefinement.Actions.SetEquippedDynamicHeadShape
local SetEquippedStaticFacialAnimation = AvatarExperienceHeadRefinement.Actions.SetEquippedStaticFacialAnimation
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local Constants = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Constants
local AssetTypeToAssetCategory = Constants.AssetTypeToAssetCategory
local AssetCategoryToAssetTypes = Constants.AssetCategoryToAssetTypes
local UpdateAvatarEquips = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateAvatarEquips)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.ToggleEquipAsset)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.EquipOutfit)
local UnequipOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.UnequipOutfit)
local BatchUnequipByAssetType = require(Modules.AvatarExperience.AvatarEditor.Actions.BatchUnequipByAssetType)
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local NormalizeAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.NormalizeAvatar)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)
local LayeredMakeupSortUtils = require(Modules.AvatarExperience.LayeredMakeupSort.LayeredMakeupSortUtils)
local AssetMetadata = require(Modules.AvatarExperience.Common.Models.AssetMetadata)
local RemoveLayeredClothing = require(Modules.AvatarExperience.AvatarEditor.Actions.RemoveLayeredClothing)
local RemoveMakeup = require(Modules.AvatarExperience.AvatarEditor.Actions.RemoveMakeup)
local SetOrder = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetOrder)
local SetAccessoryAdjustments = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAccessoryAdjustments)

require(Modules.AvatarExperience.Common.Types)

local HeadShape = AvatarExperienceHeadRefinement.Enums.HeadShape
local HeadShapeProperties = AvatarExperienceHeadRefinement.Enums.HeadShapeProperties
local GetFFlagAXEnableBatchUnequips = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableBatchUnequips)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local PurchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local MAKEUP_LOOK_ASSET_TYPES = AvatarExperienceCommon.Constants.MAKEUP_LOOK_ASSET_TYPES
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local GetFFlagEnableNewCustomizeBundleEquip = require(Modules.AvatarExperience.Flags.GetFFlagEnableNewCustomizeBundleEquip)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local v48 = game:DefineFastFlag("AXRefactorToggleEquipAsset3", false)
local FFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXSkipEmotesInAvatarData = AvatarExperienceFlags.FFlagAXSkipEmotesInAvatarData
local FFlagAXBlockMakeupEquipR6 = AvatarExperienceFlags.FFlagAXBlockMakeupEquipR6

local function checkIfWearingAsset(p1, p2) -- line: 91
	if p1 and p1[p2] then
		return true
	end

	return false
end
local function replaceOutfitParts(p3, p4) -- line: 103
	-- upvalues: GetFFlagEnableNewCustomizeBundleEquip (copy), Constants2 (copy), Cryo (copy)
	if GetFFlagEnableNewCustomizeBundleEquip() then
		if p4[Constants2.AssetTypeIdStrings.Head] or p4[Constants2.AssetTypeIdStrings.DynamicHead] then
			local t1 = {
				[Constants2.AssetTypeIdStrings.Head] = {},
				[Constants2.AssetTypeIdStrings.DynamicHead] = {}
			}

			for v62, _ in Constants2.DynamicHeadAssetTypes do
				t1[v62] = {}
			end

			p4 = Cryo.Dictionary.join(t1, p4)
		end

		return (Cryo.Dictionary.join(p3, p4))
	end

	return Cryo.Dictionary.join(p3, p4)
end
local function toggleSingleAsset(p5, t2: {[any]: any}, t3: {[any]: any}?) -- line: 165
	-- upvalues: Constants2 (copy), Cryo (copy), AssetMetadata (copy), FFlagAXCustomizeMakeupSupport (copy), LayeredMakeupSortUtils (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), MAX_MAKEUP_LAYERS (copy), LayeredClothingSortUtils (copy), mutedError (copy), Constants3 (copy), AssetTypeToAssetCategory (copy), AssetCategoryToAssetTypes (copy), HeadShapeProperties (copy), HeadShape (copy)
	local v67 = p5 or {}

	if t2.assetTypeId == Constants2.AssetTypeIdStrings.EmoteAnimation then
		return v67
	end

	local v68 = v67[t2.assetTypeId]
	local assetId = t2.assetId

	if v68 and v68[assetId] then
		local v70 = v67[t2.assetTypeId] or {}

		return Cryo.Dictionary.join(v67, {
			[t2.assetTypeId] = Cryo.Dictionary.join(v70, {
				[t2.assetId] = Cryo.None
			})
		})
	end

	local v71 = AssetMetadata.getDefaultMetadata(t2.assetTypeId)

	if t2.overrideOrder then
		v71.order = t2.overrideOrder

		local v72 = if not FFlagAXCustomizeMakeupSupport then nil else LayeredMakeupSortUtils.getSortedEquippedLayeredMakeup(v67)

		if FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[t2.assetTypeId] and v72 and #v72 == MAX_MAKEUP_LAYERS then
			local v73 = v72[#v72]

			v67 = Cryo.Dictionary.join(v67, {
				[v73.typeId] = Cryo.Dictionary.join(v67[v73.typeId] or {}, {
					[v73.id] = Cryo.None
				})
			})
		end
	elseif v71.isLayered and (not FFlagAXCustomizeMakeupSupport or Constants2.AssetTypeIdToAccessoryTypeEnum[t2.assetTypeId]) then
		local v74 = LayeredClothingSortUtils.getSortedEquippedLCIfNoDefault(v67)

		if v74 then
			local t4 = {
				id = t2.assetId,
				typeId = t2.assetTypeId
			}
			local v76, _ = LayeredClothingSortUtils.getTableAndOrderAfterEquippingIntoSort(v74, t4)

			for v78, v79 in v76 do
				if v79.id ~= t2.assetId then
					if not v67[v79.typeId] then
						mutedError(`EquippedAssets.lua missing asset typeId post sort ID:{ v79.id } typeId: { v79.typeId }`)
					else
						v67 = Cryo.Dictionary.join(v67, {
							[v79.typeId] = Cryo.Dictionary.join(v67[v79.typeId], {
								[v79.id] = Cryo.Dictionary.join(v67[v79.typeId][v79.id], {
									order = #v76 - v78
								})
							})
						})
					end
				else
					v71.order = #v76 - v78
				end
			end
		end
	elseif FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[t2.assetTypeId] then
		local v80 = LayeredMakeupSortUtils.getSortedEquippedLayeredMakeup(v67)

		if v80 then
			local t5 = {
				id = t2.assetId,
				typeId = t2.assetTypeId
			}
			local v82, _ = LayeredMakeupSortUtils.getTableAndOrderAfterEquippingIntoSort(v80, t5)

			for v84, v85 in v82 do
				if v85.id ~= t2.assetId then
					local v86 = v67[v85.typeId] or {}
					local v87 = v86[v85.id] or {}

					v67 = Cryo.Dictionary.join(v67, {
						[v85.typeId] = Cryo.Dictionary.join(v86, {
							[v85.id] = Cryo.Dictionary.join(v87, {
								order = #v82 - v84
							})
						})
					})
				else
					v71.order = math.min(#v82 - v84, MAX_MAKEUP_LAYERS - 1)
				end
			end

			if #v80 > MAX_MAKEUP_LAYERS then
				for i = MAX_MAKEUP_LAYERS + 1, #v80 do
					v67 = Cryo.Dictionary.join(v67, {
						[v80[i].typeId] = Cryo.Dictionary.join(v67[v80[i].typeId] or {}, {
							[v80[i].id] = Cryo.None
						})
					})
				end
			end

			return Cryo.Dictionary.join(v67, {
				[t2.assetTypeId] = Cryo.Dictionary.join(v67[t2.assetTypeId] or {}, {
					[t2.assetId] = v71
				})
			})
		end
	elseif t2.overrideAdjustments then
		v71 = Cryo.Dictionary.join(v71, t2.overrideAdjustments)
	end

	local t6 = {
		[t2.assetId] = v71
	}
	local v90 = v67[t2.assetTypeId] or {}

	if t2.assetTypeId == Constants2.AssetTypeIdStrings.Hat and (not t3 or not t3.ignoreAccessoryLimits) then
		if #Cryo.Dictionary.keys(v90) >= Constants3.MaxHats then
			return v67
		end

		return Cryo.Dictionary.join(v67, {
			[t2.assetTypeId] = Cryo.Dictionary.join(v90, t6)
		})
	end

	local v91 = AssetTypeToAssetCategory[t2.assetTypeId]

	if v91 then
		for _, v93 in AssetCategoryToAssetTypes[v91] do
			if v67[v93] and next(v67[v93]) then
				v67 = Cryo.Dictionary.join(v67, {
					[v93] = {}
				})
			end
		end
	end

	if t2.assetTypeId == Constants2.AssetTypeIdStrings.Head then
		for v94, _ in Constants2.DynamicHeadAssetTypes do
			v67 = Cryo.Dictionary.join(v67, {
				[v94] = {}
			})
		end
	end

	if t2.assetTypeId == Constants2.AssetTypeIdStrings.DynamicHead then
		v67 = Cryo.Dictionary.join(v67, {
			[Constants2.AssetTypeIdStrings.Head] = {}
		})
	end

	if t2.assetId and tostring(t2.assetId) == tostring(HeadShapeProperties[HeadShape.Default].assetId) then
		return (Cryo.Dictionary.join(v67, {
			[Constants2.AssetTypeIdStrings.Head] = {},
			[Constants2.AssetTypeIdStrings.DynamicHead] = {}
		}))
	end

	local v96 = Constants2.BypassAccessoryLimitsAccessoryAssetTypeIdStrings[t2.assetTypeId]

	if FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[t2.assetTypeId] then
		return Cryo.Dictionary.join(v67, {
			[t2.assetTypeId] = Cryo.Dictionary.join(v90, t6)
		})
	end

	return Cryo.Dictionary.join(v67, {
		[t2.assetTypeId] = if not t3 or (not t3.ignoreAccessoryLimits or not v96) then t6 else Cryo.Dictionary.join(v90, t6)
	})
end

return Rodux.createReducer(nil, {
	[ReceivedAvatarData.name] = function(p6, p7) -- line: 391
		-- upvalues: FFlagAXSkipEmotesInAvatarData (copy), Constants2 (copy), AssetMetadata (copy), FFlagAXModeratedItemsFlow (copy), Cryo (copy)
		local assets = p7.avatarData.assets

		if assets == nil then
			return p6
		end

		local t7 = {}

		for _, v102 in assets do
			local str = tostring(v102.assetType.id)
			local str2 = tostring(v102.id)

			if not FFlagAXSkipEmotesInAvatarData or str ~= Constants2.AssetTypeIdStrings.EmoteAnimation then
				local v105 = t7[str] or {}

				v105[str2] = AssetMetadata.fromMetadata(v102.meta, str)

				if FFlagAXModeratedItemsFlow then
					v105[str2].availabilityStatus = v102.availabilityStatus
				end

				t7[str] = v105
			end
		end

		local v106 = t7[Constants2.AssetTypeIdStrings.DynamicHead] or {}
		local v107 = t7[Constants2.AssetTypeIdStrings.Face] or {}

		if not Cryo.isEmpty(v106) and not Cryo.isEmpty(v107) then
			t7[Constants2.AssetTypeIdStrings.Face] = {}
		end

		return t7
	end,
	[ToggleEquipAsset.name] = function(p8, p9) -- line: 433
		-- upvalues: v48 (copy), toggleSingleAsset (copy), Constants2 (copy), Cryo (copy), AssetMetadata (copy), FFlagAXCustomizeMakeupSupport (copy), LayeredMakeupSortUtils (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), MAX_MAKEUP_LAYERS (copy), LayeredClothingSortUtils (copy), mutedError (copy), Constants3 (copy), AssetTypeToAssetCategory (copy), AssetCategoryToAssetTypes (copy), HeadShapeProperties (copy), HeadShape (copy)
		if v48 then
			return toggleSingleAsset(p8, p9)
		end

		local v110 = p8 or {}

		if p9.assetTypeId == Constants2.AssetTypeIdStrings.EmoteAnimation then
			return v110
		end

		local v111 = v110[p9.assetTypeId]
		local assetId = p9.assetId

		if v111 and v111[assetId] then
			local v113 = v110[p9.assetTypeId] or {}

			return Cryo.Dictionary.join(v110, {
				[p9.assetTypeId] = Cryo.Dictionary.join(v113, {
					[p9.assetId] = Cryo.None
				})
			})
		end

		local v114 = AssetMetadata.getDefaultMetadata(p9.assetTypeId)

		if p9.overrideOrder then
			v114.order = p9.overrideOrder

			local v115 = if not FFlagAXCustomizeMakeupSupport then nil else LayeredMakeupSortUtils.getSortedEquippedLayeredMakeup(v110)

			if FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p9.assetTypeId] and v115 and #v115 == MAX_MAKEUP_LAYERS then
				local v116 = v115[#v115]

				v110 = Cryo.Dictionary.join(v110, {
					[v116.typeId] = Cryo.Dictionary.join(v110[v116.typeId] or {}, {
						[v116.id] = Cryo.None
					})
				})
			end
		elseif v114.isLayered and (not FFlagAXCustomizeMakeupSupport or Constants2.AssetTypeIdToAccessoryTypeEnum[p9.assetTypeId]) then
			local v117 = LayeredClothingSortUtils.getSortedEquippedLCIfNoDefault(v110)

			if v117 then
				local t8 = {
					id = p9.assetId,
					typeId = p9.assetTypeId
				}
				local v119, _ = LayeredClothingSortUtils.getTableAndOrderAfterEquippingIntoSort(v117, t8)

				for v121, v122 in v119 do
					if v122.id ~= p9.assetId then
						if not v110[v122.typeId] then
							mutedError(`EquippedAssets.lua missing asset typeId post sort ID:{ v122.id } typeId: { v122.typeId }`)
						else
							v110 = Cryo.Dictionary.join(v110, {
								[v122.typeId] = Cryo.Dictionary.join(v110[v122.typeId], {
									[v122.id] = Cryo.Dictionary.join(v110[v122.typeId][v122.id], {
										order = #v119 - v121
									})
								})
							})
						end
					else
						v114.order = #v119 - v121
					end
				end
			end
		elseif FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p9.assetTypeId] then
			local v123 = LayeredMakeupSortUtils.getSortedEquippedLayeredMakeup(v110)

			if v123 then
				local t9 = {
					id = p9.assetId,
					typeId = p9.assetTypeId
				}
				local v125, _ = LayeredMakeupSortUtils.getTableAndOrderAfterEquippingIntoSort(v123, t9)

				for v127, v128 in v125 do
					if v128.id ~= p9.assetId then
						local v129 = v110[v128.typeId] or {}
						local v130 = v129[v128.id] or {}

						v110 = Cryo.Dictionary.join(v110, {
							[v128.typeId] = Cryo.Dictionary.join(v129, {
								[v128.id] = Cryo.Dictionary.join(v130, {
									order = #v125 - v127
								})
							})
						})
					else
						v114.order = math.min(#v125 - v127, MAX_MAKEUP_LAYERS - 1)
					end
				end

				if #v123 > MAX_MAKEUP_LAYERS then
					for i = MAX_MAKEUP_LAYERS + 1, #v123 do
						v110 = Cryo.Dictionary.join(v110, {
							[v123[i].typeId] = Cryo.Dictionary.join(v110[v123[i].typeId] or {}, {
								[v123[i].id] = Cryo.None
							})
						})
					end
				end

				return Cryo.Dictionary.join(v110, {
					[p9.assetTypeId] = Cryo.Dictionary.join(v110[p9.assetTypeId] or {}, {
						[p9.assetId] = v114
					})
				})
			end
		elseif p9.overrideAdjustments then
			v114 = Cryo.Dictionary.join(v114, p9.overrideAdjustments)
		end

		local t10 = {
			[p9.assetId] = v114
		}
		local v133 = v110[p9.assetTypeId] or {}

		if p9.assetTypeId == Constants2.AssetTypeIdStrings.Hat then
			if #Cryo.Dictionary.keys(v133) >= Constants3.MaxHats then
				return v110
			end

			return Cryo.Dictionary.join(v110, {
				[p9.assetTypeId] = Cryo.Dictionary.join(v133, t10)
			})
		end

		local v134 = AssetTypeToAssetCategory[p9.assetTypeId]

		if v134 then
			for _, v136 in AssetCategoryToAssetTypes[v134] do
				if v110[v136] and next(v110[v136]) then
					v110 = Cryo.Dictionary.join(v110, {
						[v136] = {}
					})
				end
			end
		end

		if p9.assetTypeId == Constants2.AssetTypeIdStrings.Head then
			for v137, _ in Constants2.DynamicHeadAssetTypes do
				v110 = Cryo.Dictionary.join(v110, {
					[v137] = {}
				})
			end
		end

		if p9.assetTypeId == Constants2.AssetTypeIdStrings.DynamicHead then
			v110 = Cryo.Dictionary.join(v110, {
				[Constants2.AssetTypeIdStrings.Head] = {}
			})
		end

		if p9.assetId and tostring(p9.assetId) == tostring(HeadShapeProperties[HeadShape.Default].assetId) then
			return (Cryo.Dictionary.join(v110, {
				[Constants2.AssetTypeIdStrings.Head] = {},
				[Constants2.AssetTypeIdStrings.DynamicHead] = {}
			}))
		end

		if FFlagAXCustomizeMakeupSupport and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p9.assetTypeId] then
			return Cryo.Dictionary.join(v110, {
				[p9.assetTypeId] = Cryo.Dictionary.join(v133, t10)
			})
		end

		return Cryo.Dictionary.join(v110, {
			[p9.assetTypeId] = t10
		})
	end,
	[UpdateAvatarEquips.name] = function(p10, p11) -- line: 647
		-- upvalues: Cryo (copy), toggleSingleAsset (copy)
		local assets = p11.assets

		if assets and not Cryo.isEmpty(assets) then
			for _, v143 in assets do
				p10 = toggleSingleAsset(p10, v143, {
					ignoreAccessoryLimits = true
				})
			end
		end

		return p10
	end,
	[EquipOutfit.name] = function(p12, p13) -- line: 662
		-- upvalues: replaceOutfitParts (copy)
		local v146 = p12 or {}

		if p13.fullReset then
			return p13.assets
		end

		return replaceOutfitParts(v146, p13.assets)
	end,
	[UnequipOutfit.name] = function(p14, p15) -- line: 674
		-- upvalues: Cryo (copy)
		local v149 = p14 or {}

		for v150, v151 in p15.assetTypeIdToAssetIdToAssetMetadataModel do
			for v152, _ in v151 do
				v149 = Cryo.Dictionary.join(v149, {
					[v150] = Cryo.Dictionary.join(v149[v150], {
						[v152] = Cryo.None
					})
				})
			end
		end

		return v149
	end,
	[RemoveLayeredClothing.name] = function(p16, p17) -- line: 692
		-- upvalues: Constants2 (copy)
		local v156 = p16 or {}
		local v157 = false
		local t11 = {}

		for k, v in pairs(v156) do
			local t12 = {}
			local v162 = false

			for v163, v164 in v do
				local v165 = k == Constants2.AssetTypeIdStrings.HairAccessory

				if v164.isLayered and (not v165 or p17.hasLayeredHair) then
					v162 = true
				else
					t12[v163] = v164
				end
			end

			if v162 then
				v157 = true
				t11[k] = t12
			else
				t11[k] = v
			end
		end

		if v157 then
			return t11
		end

		return v156
	end,
	[SetOrder.name] = function(p18, p19) -- line: 726
		-- upvalues: Cryo (copy)
		for v168, v169 in p19.assetIdToOrderAndAssetTypeId do
			local assetTypeId = v169.assetTypeId
			local order = v169.order
			local v172 = p18[assetTypeId]
			local v173 = v172[v168]

			p18 = Cryo.Dictionary.join(p18, {
				[assetTypeId] = Cryo.Dictionary.join(v172, {
					[v168] = Cryo.Dictionary.join(v173, {
						order = order
					})
				})
			})
		end

		return p18
	end,
	[SetAccessoryAdjustments.name] = function(p20, p21) -- line: 750
		-- upvalues: Cryo (copy)
		for v176, v177 in p20 do
			for v178, v179 in v177 do
				if v178 == p21.itemId then
					return Cryo.Dictionary.join(p20, {
						[v176] = Cryo.Dictionary.join(v177, {
							[v178] = Cryo.Dictionary.join(v179, {
								position = p21.position,
								rotation = p21.rotation,
								scale = p21.scale
							})
						})
					})
				end
			end
		end

		return p20
	end,
	[BatchUnequipByAssetType.name] = function(p22, p23) -- line: 771
		-- upvalues: GetFFlagAXEnableBatchUnequips (copy), Constants2 (copy), Cryo (copy)
		if not GetFFlagAXEnableBatchUnequips() then
			return p22
		end

		local v182 = p22 or {}

		for _, v184 in p23.assetTypeIds do
			if v184 == Constants2.AssetTypeIdStrings.DynamicHead then
				for v185, _ in Constants2.DynamicHeadAssetTypes do
					v182 = Cryo.Dictionary.join(v182, {
						[v185] = Cryo.None
					})
				end
			end

			v182 = Cryo.Dictionary.join(v182, {
				[v184] = Cryo.None
			})
		end

		return v182
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p24, p25) -- line: 800
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p25.equipped and p25.equipped.EquippedAssets) then
			return table.clone(p25.equipped.EquippedAssets)
		end

		return p24
	end,
	[SetEquippedDynamicHeadShape.name] = if not FFlagDynamicHeadsMigration then nil else function(p26, p27) -- line: 812
		-- upvalues: Constants2 (copy), Cryo (copy)
		local v191 = p26[Constants2.AssetTypeIdStrings.DynamicHead]

		if not v191 then
			return p26
		end

		local t13 = {}
		local v193 = false

		for v194, v195 in v191 do
			if v195.supportsHeadShapes ~= false then
				t13[v194] = Cryo.Dictionary.join(v195, {
					headShape = p27.headShapeName
				})
				v193 = true
			else
				t13[v194] = v195
			end
		end

		if not v193 then
			return p26
		end

		return Cryo.Dictionary.join(p26, {
			[Constants2.AssetTypeIdStrings.DynamicHead] = t13
		})
	end,
	[SetEquippedStaticFacialAnimation.name] = if not FFlagHeadRefinementFacialAnimationToggle then nil else function(p28, p29) -- line: 852
		-- upvalues: Constants2 (copy), Cryo (copy)
		local v198 = p28[Constants2.AssetTypeIdStrings.DynamicHead]

		if not v198 then
			return p28
		end

		local t14 = {}

		for v200, v201 in v198 do
			t14[v200] = Cryo.Dictionary.join(v201, {
				staticFacialAnimation = p29.isEnabled
			})
		end

		return Cryo.Dictionary.join(p28, {
			[Constants2.AssetTypeIdStrings.DynamicHead] = t14
		})
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p30, p31) -- line: 872
		-- upvalues: MAKEUP_LOOK_ASSET_TYPES (copy), FFlagAXBackgroundsCustomizeHydration (copy), AvatarBackground (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), Cryo (copy), toggleSingleAsset (copy), FFlagAXMISSaveWearFix (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy)
		local v204 = p30 or {}

		if p31.equippableAssets and #p31.equippableAssets > 0 then
			if p31.shouldClearEquippedMakeup then
				for v205, _ in MAKEUP_LOOK_ASSET_TYPES do
					v204[v205] = {}
				end
			end

			if p31.replaceAllEquippedAssets then
				v204 = {}
			end

			for _, v208 in p31.equippableAssets do
				local v209 = v204[v208.assetTypeId]
				local assetId = v208.assetId

				if (not v209 or not v209[assetId]) and tostring(v208.assetTypeId) ~= tostring(Enum.AvatarAssetType.EmoteAnimation.Value) and (not FFlagAXBackgroundsCustomizeHydration or not AvatarBackground or v208.assetTypeId ~= AvatarBackground) then
					local t15 = nil

					if FFlagParseHeadShapeFromAPIResponse and v208.headShape ~= nil then
						t15 = {
							headShape = v208.headShape
						}
					end

					local t16 = nil

					if FFlagHeadRefinementFacialAnimationToggle then
						local staticFacialAnimation = v208.staticFacialAnimation

						if staticFacialAnimation ~= nil then
							t16 = {
								staticFacialAnimation = staticFacialAnimation
							}
						end
					end

					local v214 = if not t15 and not t16 then nil else Cryo.Dictionary.join(t15 or {}, t16 or {})

					v204 = toggleSingleAsset(v204, {
						assetId = v208.assetId,
						assetTypeId = v208.assetTypeId,
						overrideOrder = v208.order,
						overrideAdjustments = v214
					}, {
						ignoreAccessoryLimits = true
					})
				end
			end

			if FFlagAXMISSaveWearFix and p31.makeupAssetsOnHumanoid then
				for v215, _ in ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
					if v204[v215] then
						for v217, _ in v204[v215] do
							if p31.makeupAssetsOnHumanoid[v217] ~= nil then
								v204[v215][v217].order = p31.makeupAssetsOnHumanoid[v217]
							else
								v204[v215][v217] = nil
							end
						end
					end
				end
			end
		end

		return v204
	end,
	[NormalizeAvatar.name] = FFlagAXCustomizeMakeupSupport and function(p32, _) -- line: 947
		-- upvalues: FFlagAXBlockMakeupEquipR6 (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), Cryo (copy)
		local v221 = p32 or {}
		local t17 = {}

		for v223, _ in if not FFlagAXBlockMakeupEquipR6 then pairs(ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE) else ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
			local v225 = v221[v223]

			if v225 then
				for v226, v227 in v225 do
					table.insert(t17, {
						assetId = v226,
						assetTypeId = v223,
						metadata = v227
					})
				end
			end
		end

		table.sort(t17, function(p34, p35) -- line: 974
			return p34.metadata.order ~= nil and (p35.metadata.order == nil or p34.metadata.order < p35.metadata.order)
		end)

		for v228, v229 in t17 do
			local assetTypeId = v229.assetTypeId
			local assetId = v229.assetId
			local v232 = v221[assetTypeId] and v221[assetTypeId][assetId] or v229.metadata
			local v233 = Cryo.Dictionary.join(v232, {
				order = v228 - 1
			})

			v221 = Cryo.Dictionary.join(v221, {
				[assetTypeId] = Cryo.Dictionary.join(v221[assetTypeId] or {}, {
					[assetId] = v233
				})
			})
		end

		return v221
	end or nil,
	[RemoveMakeup.name] = FFlagAXBlockMakeupEquipR6 and function(p36, _) -- line: 1000
		-- upvalues: isMakeupAssetType (copy), Cryo (copy)
		local v236 = p36 or {}

		for v237, _ in v236 do
			if isMakeupAssetType(v237) then
				v236 = Cryo.Dictionary.join(v236, {
					[v237] = Cryo.None
				})
			end
		end

		return v236
	end or nil
})
