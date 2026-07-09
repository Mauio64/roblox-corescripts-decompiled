local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local AssetTypeToAssetCategory = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Constants.AssetTypeToAssetCategory
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local selectDefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColorsToggled)
local selectDefaultTryOnBodyColors = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColors)
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local destroyMakeupDescriptions = AvatarExperienceCommon.Utils.destroyMakeupDescriptions
local getMakeupDescriptionsFromHumanoidDescription = AvatarExperienceCommon.Utils.getMakeupDescriptionsFromHumanoidDescription
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)
local AvatarWidgetBlockyUtils = require(Modules.AvatarExperience.Common.Util.AvatarWidgetBlockyUtils)
local GetFFlagFixCharacterManagerValueConversionWarning = require(Modules.AvatarExperience.Flags.GetFFlagFixCharacterManagerValueConversionWarning)
local GetFFlagAXFixOrderFieldUnlayeredItems = require(Modules.AvatarExperience.Flags.GetFFlagAXFixOrderFieldUnlayeredItems)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXMakeupFixAvatarLooksTryOn = AvatarExperienceFlags.FFlagAXMakeupFixAvatarLooksTryOn
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagEnableHeadShapeForCharacterManager = AvatarExperienceFlags.FFlagEnableHeadShapeForCharacterManager
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagFixHeadShapeColorSlider = AvatarExperienceFlags.FFlagFixHeadShapeColorSlider
local FFlagAXFixR6DefaultHeadShape = AvatarExperienceFlags.FFlagAXFixR6DefaultHeadShape
local selectLastTryOnClassicHeadShapeAssetId = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Selectors.selectLastTryOnClassicHeadShapeAssetId)
local v33 = game:DefineFastFlag("AXNilCheckEquippedAssets", false)
local t1 = {}

local function getIsInLCSortIsRemovedTuple(p1, p2) -- line: 81
	-- upvalues: FFlagHeadRefinementFacialAnimationToggle (copy), LayeredClothingSortUtils (copy)
	local v48 = p1.AvatarExperience and p1.AvatarExperience.LayeredClothingSort
	local v49 = v48 and v48.CurrentSort

	if FFlagHeadRefinementFacialAnimationToggle then
		if not v49 then
			return false, false
		end

		local v50 = v49.OrderedList or {}
		local v51 = v49.RemovedList or {}

		return LayeredClothingSortUtils.createAssetIdToOrderMapping(v50)[p2], v51[p2]
	end

	local OrderedList = p1.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList
	local RemovedList = p1.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList

	return LayeredClothingSortUtils.createAssetIdToOrderMapping(OrderedList)[p2], RemovedList[p2]
end

function t1.tryApplyClassicHeadShapeTryOn(p3, p4) -- line: 105
	-- upvalues: Utils2 (copy), selectLastTryOnClassicHeadShapeAssetId (copy)
	local v56 = p3.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
	local v57 = Utils2.isTryingOnDynamicHead(p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
	local v58 = selectLastTryOnClassicHeadShapeAssetId(p3)

	if v56 or (v57 or not v58) then
		return
	end

	p4.Head = v58
end

local function updateHumanoidDescriptionTryOnFromNormalizedAssets(p5, t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}) -- line: 120
	-- upvalues: Constants (copy), Utils2 (copy)
	if not t3 or #t3 == 0 then
		return t2
	end

	table.sort(t3, function(p6, p7) -- line: 134
		if p6.itemRecency and p7.itemRecency then
			return p6.itemRecency < p7.itemRecency
		end

		return false
	end)

	for v63, v64 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToCategory[v63] == Constants.AssetCategories.Body then
			local v65 = t4[v64]

			if v65 ~= nil then
				for _, v67 in v65 do
					for v68, _ in v67 do
						p5[v64] = v68
					end
				end
			end
		end
	end

	for _, v71 in t3 do
		if not v71.isRemovedInLCSort and v71.assetTypeId ~= Constants.AssetTypeIdStrings.Gear and v71.assetId then
			local v72 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[v71.assetTypeId]

			if Constants.AssetTypeIdToAccessoryTypeEnum[v71.assetTypeId] then
				local v73 = Utils2.createDefaultHumanoidDescriptionAccessoryInfo(v71.assetTypeId, v71.assetId)

				if v71.order ~= nil then
					v73.Order = v71.order
				end

				v73.Position = v71.position
				v73.Rotation = v71.rotation
				v73.Scale = v71.scale

				if not t2[v71.assetTypeId] or not v71.lookId then
					t2[v71.assetTypeId] = {}
				end

				table.insert(t2[v71.assetTypeId], v73)
			elseif v72 then
				p5[v72] = if not v71.lookId or v71.bundleId ~= tostring(Constants.BlockyBundleId) then v71.assetId else 0
			end
		end
	end

	return t2
end
local function updateHumanoidDescriptionTryOnOutfitAsset(p8, p9, s1: string, t5: {[any]: any}, p10) -- line: 215
	-- upvalues: Constants (copy), Utils2 (copy), GetFFlagAXFixOrderFieldUnlayeredItems (copy), getIsInLCSortIsRemovedTuple (copy)
	if not p9.selectedInTryOnManager then
		return
	end

	local itemSubType = p9.itemSubType

	if s1 and itemSubType ~= Constants.AssetTypeIdStrings.Gear then
		local v80 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[itemSubType]

		if Constants.AssetTypeIdToAccessoryTypeEnum[itemSubType] then
			local v81 = Utils2.createDefaultHumanoidDescriptionAccessoryInfo(itemSubType, s1)

			if p9.order ~= nil and (not GetFFlagAXFixOrderFieldUnlayeredItems() or v81.IsLayered) then
				v81.Order = p9.order
			end

			v81.Position = p9.position
			v81.Rotation = p9.rotation
			v81.Scale = p9.scale

			local _, v83 = getIsInLCSortIsRemovedTuple(p8, s1)

			if not v83 then
				table.insert(t5, v81)

				return
			end
		elseif v80 then
			p10[v80] = s1
		end
	end
end
local function updateHumanoidDescriptionTryOnOutfitBundle(p11, p12, p13, t6: {[any]: any}, p14) -- line: 263
	-- upvalues: Constants (copy), Utils2 (copy), GetFFlagAXFixOrderFieldUnlayeredItems (copy), getIsInLCSortIsRemovedTuple (copy), Cryo (copy)
	for v89, v90 in p12.assets do
		local v91 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[v89]
		local v92 = v91 and v89 ~= Constants.AssetTypeIdStrings.Gear

		if Constants.AssetTypeIdToAccessoryTypeEnum[v89] then
			for v93, v94 in v90 do
				local v95 = Utils2.createHumanoidDescriptionAccessoryInfo(v89, v93, v94)
				local bundleInfo = p13.bundleInfo

				if bundleInfo and bundleInfo[v93] and bundleInfo[v93].order ~= nil and (not GetFFlagAXFixOrderFieldUnlayeredItems() or v95.IsLayered) then
					v95.Order = bundleInfo[v93].order
				end

				if bundleInfo and bundleInfo[v93] then
					v95.Position = bundleInfo[v93].position
					v95.Rotation = bundleInfo[v93].rotation
					v95.Scale = bundleInfo[v93].scale
				end

				local _, v98 = getIsInLCSortIsRemovedTuple(p11, v93)

				if not v98 then
					table.insert(t6, v95)
				end
			end
		elseif v92 then
			local v99 = Cryo.Dictionary.keys(v90)

			p14[v91] = table.concat(v99, ",")
		end
	end
end
local function updateHumanoidDescriptionTryOnItemBundle(p15, p16, t7: {[any]: any}, p17) -- line: 315
	-- upvalues: AvatarWidgetBlockyUtils (copy), Constants (copy), Utils2 (copy), getIsInLCSortIsRemovedTuple (copy)
	local v104 = AvatarWidgetBlockyUtils.buildEquippedAssetMapByHumanoidDescriptionProp(p15)

	assert(p16.bundleInfo, "tryOnBundleItem.bundleInfo is non-nil. Silence type checker.")

	for v105, v106 in p16.bundleInfo do
		local v107 = Constants.AssetTypeIdStringToHumanoidDescriptionProp[v106.assetType]
		local v108 = v107 and v106.assetType ~= Constants.AssetTypeIdStrings.Gear

		if Constants.AssetTypeIdToAccessoryTypeEnum[v106.assetType] then
			if p16.selectedInTryOnManager then
				local v109 = Utils2.createDefaultHumanoidDescriptionAccessoryInfo(v106.assetType, v105)

				if v106.order ~= nil then
					v109.Order = v106.order
				end

				local _, v111 = getIsInLCSortIsRemovedTuple(p15, v105)

				if not v111 then
					table.insert(t7, v109)
				end
			end
		elseif v108 then
			p17[v107] = if p16.itemId ~= tostring(Constants.BlockyBundleId) then v105 else 0

			if not p16.selectedInTryOnManager then
				local v112 = v104[v107]

				p17[v107] = 0

				if v112 ~= nil then
					for _, v114 in v112 do
						for v115, _ in v114 do
							p17[v107] = v115
						end
					end
				end
			end
		end
	end
end
local function updateHumanoidDescriptionTryOnOutfitBundleNoUserOutfit(p18, p19, p20, t8: {[any]: any}) -- line: 397
	-- upvalues: Utils2 (copy), GetFFlagAXFixOrderFieldUnlayeredItems (copy), getIsInLCSortIsRemovedTuple (copy)
	local AssetInfos = p18.AvatarExperience.Common.AssetInfos
	local v122 = false

	if p20.items == nil then
		return
	end

	assert(p20.items, "bundleInfo.items is non-nil. Silence type checker.")

	for _, v124 in p20.items do
		local v125 = AssetInfos[v124.id]

		if not v125 or not v125.assetType then
			v122 = true
		end
	end

	if not v122 then
		for _, v127 in p20.items do
			local assetType = AssetInfos[v127.id].assetType
			local v129 = Utils2.createDefaultHumanoidDescriptionAccessoryInfo(assetType, v127.id)
			local bundleInfo = p19.bundleInfo

			if bundleInfo and bundleInfo[v127.id] and bundleInfo[v127.id].order ~= nil and (not GetFFlagAXFixOrderFieldUnlayeredItems() or v129.IsLayered) then
				v129.Order = bundleInfo[v127.id].order
			end

			local _, v132 = getIsInLCSortIsRemovedTuple(p18, v127.id)

			if not v132 then
				table.insert(t8, v129)
			end
		end
	end
end
local function isHumanoidDescriptionPropertyEmpty(p21) -- line: 448
	return p21 == "" or p21 == 0
end

function t1.isDHBundle(p22) -- line: 452
	-- upvalues: Constants (copy)
	return p22.itemType == Constants.ItemType.Bundle and (p22.itemSubType == Enum.BundleType.DynamicHead.Name or p22.itemSubType == Constants.BundleTypeIdStrings.DynamicHead)
end
function t1.isDHBundleTryOn(p23) -- line: 464
	-- upvalues: t1 (copy)
	for _, v137 in p23.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if t1.isDHBundle(v137) then
			return true
		end
	end

	return false
end
function t1.isClassicHeadOrClassicFaceTryOn(p24) -- line: 474
	-- upvalues: Constants (copy)
	for _, v140 in p24.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v140.itemSubType == Constants.AssetTypeIdStrings.Head or v140.itemSubType == Constants.AssetTypeIdStrings.Face then
			return true
		end
	end

	return false
end

local function setAccessoriesFromTryOn(p25, p26, p27) -- line: 491
	-- upvalues: Constants (copy), AssetTypeToAssetCategory (copy), FFlagAXMakeupEquipping (copy), t1 (copy)
	local Accessories = p26:GetAccessories(true)
	local Accessories2 = p27:GetAccessories(true)
	local RemovedList = p25.AvatarExperience.LayeredClothingSort.CurrentSort.RemovedList
	local t9 = {}
	local t10 = {}

	for _, v150 in Accessories2 do
		local v151 = AssetTypeToAssetCategory[Constants.AccessoryTypeEnumToAssetTypeId[v150.AccessoryType]]

		t9[v150.AccessoryType] = true

		if v151 then
			t10[v151] = true
		end
	end

	for _, v153 in RemovedList do
		local v154 = Constants.AssetTypeIdToAccessoryTypeEnum[v153]
		local v155 = AssetTypeToAssetCategory[v153]

		if FFlagAXMakeupEquipping and v154 then
			t9[v154] = true
		elseif not FFlagAXMakeupEquipping then
			t9[v154] = true
		end

		if v155 then
			t10[v155] = true
		end
	end

	for _, v157 in Accessories do
		local v158 = Constants.AccessoryTypeEnumToAssetTypeId[v157.AccessoryType]
		local v159 = not t9[v157.AccessoryType]
		local v160 = AssetTypeToAssetCategory[v158]

		if v160 then
			v159 = not t10[v160]
		end

		if t1.isDHBundleTryOn(p25) and Constants.DynamicHeadAssetTypes[v158] then
			v159 = false
		end

		if v159 then
			table.insert(Accessories2, v157)
		end
	end

	p26:SetAccessories(Accessories2, true)
end
local function getTryOnsBundleOutfitInfo(p28) -- line: 564
	-- upvalues: Constants (copy), Utils2 (copy)
	for _, v163 in p28.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v163.itemType ~= Constants.ItemType.Bundle or v163.itemSubType ~= Constants.BundleTypeIdStrings.BodyParts then
			continue
		end

		local v164 = Utils2.getOutfitInfoFromBundleId(p28, v163.itemId)

		if v164 then
			return v164
		end
	end

	return nil
end
local function normalizeTryOnAsset(p29, p30) -- line: 581
	-- upvalues: getIsInLCSortIsRemovedTuple (copy)
	local _, v168 = getIsInLCSortIsRemovedTuple(p30, p29.itemId)

	return {
		assetId = p29.itemId,
		assetTypeId = p29.itemSubType,
		itemRecency = p29.itemRecency,
		lookId = p29.lookId,
		order = p29.order,
		isRemovedInLCSort = v168,
		position = p29.position,
		rotation = p29.rotation,
		scale = p29.scale
	}
end
local function getNormalizedAssetsFromTryOnBundle(p31, p32) -- line: 599
	-- upvalues: Utils2 (copy), getIsInLCSortIsRemovedTuple (copy), FFlagEnableHeadShapeForCharacterManager (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagDynamicHeadsMigration (copy)
	local v171 = Utils2.getOutfitInfoFromBundleId(p32, p31.itemId)
	local t11 = {}

	if p31.bundleInfo and p31.lookId ~= nil then
		for v173, v174 in p31.bundleInfo do
			local _, v176 = getIsInLCSortIsRemovedTuple(p32, v173)

			table.insert(t11, {
				assetId = v173,
				assetTypeId = v174.assetType,
				itemRecency = p31.itemRecency,
				lookId = p31.lookId,
				order = v174.order,
				isRemovedInLCSort = v176,
				position = v174.position,
				rotation = v174.rotation,
				scale = v174.scale,
				bundleId = p31.itemId,
				headShape = if not FFlagEnableHeadShapeForCharacterManager then nil else v174.headShape,
				staticFacialAnimation = if not FFlagHeadRefinementFacialAnimationToggle then nil else v174.staticFacialAnimation
			})
		end

		return t11
	end

	if v171 and v171.assets then
		for v177, v178 in v171.assets do
			for v179, v180 in v178 do
				local _, v182 = getIsInLCSortIsRemovedTuple(p32, v179)
				local v183 = if not p31.bundleInfo or not p31.bundleInfo[v179] then {} else p31.bundleInfo[v179]

				table.insert(t11, {
					assetId = v179,
					assetTypeId = v177,
					itemRecency = p31.itemRecency,
					lookId = p31.lookId,
					order = v183.order,
					isRemovedInLCSort = v182,
					position = v183.position,
					rotation = v183.rotation,
					scale = v183.scale,
					bundleId = p31.itemId,
					headShape = if not FFlagEnableHeadShapeForCharacterManager then nil else v180.headShape,
					staticFacialAnimation = if not FFlagHeadRefinementFacialAnimationToggle then nil else v180.staticFacialAnimation
				})
			end
		end

		return t11
	end

	if FFlagDynamicHeadsMigration and p31.bundleInfo then
		for v184, v185 in p31.bundleInfo do
			local _, v187 = getIsInLCSortIsRemovedTuple(p32, v184)

			table.insert(t11, {
				assetId = v184,
				assetTypeId = v185.assetType,
				itemRecency = p31.itemRecency,
				lookId = p31.lookId,
				order = v185.order,
				isRemovedInLCSort = v187,
				position = v185.position,
				rotation = v185.rotation,
				scale = v185.scale,
				bundleId = p31.itemId,
				headShape = if not FFlagEnableHeadShapeForCharacterManager then nil else v185.headShape,
				staticFacialAnimation = if not FFlagHeadRefinementFacialAnimationToggle then nil else v185.staticFacialAnimation
			})
		end
	end

	return t11
end

function t1.setAvatarTryOnProperties(p33, p34) -- line: 689
	-- upvalues: selectDefaultTryOnBodyColorsToggled (copy), selectDefaultTryOnBodyColors (copy), Utils (copy), Constants (copy)
	local BodyColor3s = p34.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
	local OutfitTryOnScale = p34.AvatarExperience.AvatarScene.OutfitTryOn.Scale
	local v192 = selectDefaultTryOnBodyColorsToggled(p34)
	local v193 = selectDefaultTryOnBodyColors(p34)
	local v194 = if not v192 then BodyColor3s else v193

	if v194 then
		Utils.setHumanoidDescriptionColorsFromBodyColor3s(p33, v194)
	end

	if OutfitTryOnScale ~= nil then
		for v195, v196 in OutfitTryOnScale do
			p33[Constants.HumanoidDescriptionScaleToName[v195]] = v196
		end
	end
end
function t1.resetHumanoidDescriptionProperties(p35) -- line: 711
	-- upvalues: Constants (copy)
	for _, v199 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		local v200 = typeof(p35[v199])

		if v200 == "string" then
			p35[v199] = ""
		elseif v200 == "number" then
			p35[v199] = 0
		end
	end
end

if FFlagEnableHeadShapeForCharacterManager then
	function t1.getHeadShapeFromTryOn(p36) -- line: 728
		-- upvalues: Utils2 (copy), FFlagAXMISEnableMultiShopping (copy), getNormalizedAssetsFromTryOnBundle (copy), Constants (copy)
		local TryOnItems = p36.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local LookId = p36.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local v204 = false

		for _, v206 in TryOnItems do
			local v207 = Utils2.getOutfitInfoFromBundleId(p36, v206.itemId)
			local bundleInfo = v206.bundleInfo
			local v209 = if not FFlagAXMISEnableMultiShopping then nil else getNormalizedAssetsFromTryOnBundle(v206, p36)

			if v207 and LookId == nil then
				for v210, v211 in v207.assets do
					if v210 == Constants.AssetTypeIdStrings.DynamicHead then
						v204 = true

						for _, v213 in v211 do
							if v213.headShape then
								return v213.headShape, v204
							end
						end
					end
				end
			end

			if FFlagAXMISEnableMultiShopping and v209 then
				for _, v215 in v209 do
					if v215.assetTypeId ~= Constants.AssetTypeIdStrings.DynamicHead then
						continue
					end

					v204 = true

					if v215.headShape then
						return v215.headShape, v204
					end
				end
			end

			if bundleInfo then
				for _, v217 in bundleInfo do
					if v217.assetType ~= Constants.AssetTypeIdStrings.DynamicHead then
						continue
					end

					v204 = true

					if v217.headShape then
						return v217.headShape, v204
					end
				end
			end
		end

		return nil, v204
	end
	function t1.getHeadShapeFromEquippedAssets(p37) -- line: 785
		-- upvalues: v33 (copy), Constants (copy)
		local EquippedAssets = p37.AvatarExperience.AvatarEditor.Character.EquippedAssets

		if v33 and not EquippedAssets then
			return nil
		end

		for v220, v221 in EquippedAssets do
			if v220 == Constants.AssetTypeIdStrings.DynamicHead then
				for _, v223 in v221 do
					return v223.headShape
				end
			end
		end

		return nil
	end

	if FFlagHeadRefinementFacialAnimationToggle then
		function t1.getStaticFacialAnimationFromEquippedAssets(p38) -- line: 806
			-- upvalues: v33 (copy), Constants (copy)
			local EquippedAssets = p38.AvatarExperience.AvatarEditor.Character.EquippedAssets

			if v33 and not EquippedAssets then
				return nil
			end

			local v226 = EquippedAssets[Constants.AssetTypeIdStrings.DynamicHead]

			if v226 then
				for _, v228 in v226 do
					return v228.staticFacialAnimation
				end
			end

			return nil
		end
		function t1.getStaticFacialAnimationFromTryOn(p39) -- line: 827
			-- upvalues: Utils2 (copy), FFlagAXMISEnableMultiShopping (copy), getNormalizedAssetsFromTryOnBundle (copy), Constants (copy)
			for _, v231 in p39.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
				local v232 = Utils2.getOutfitInfoFromBundleId(p39, v231.itemId)
				local bundleInfo = v231.bundleInfo
				local v234 = if not FFlagAXMISEnableMultiShopping then nil else getNormalizedAssetsFromTryOnBundle(v231, p39)

				if v232 then
					for v235, v236 in v232.assets do
						if v235 == Constants.AssetTypeIdStrings.DynamicHead then
							for _, v238 in v236 do
								if v238.staticFacialAnimation ~= nil then
									return v238.staticFacialAnimation
								end
							end
						end
					end
				end

				if FFlagAXMISEnableMultiShopping and v234 then
					for _, v240 in v234 do
						if v240.assetTypeId == Constants.AssetTypeIdStrings.DynamicHead and v240.staticFacialAnimation ~= nil then
							return v240.staticFacialAnimation
						end
					end
				end

				if bundleInfo then
					for _, v242 in bundleInfo do
						if v242.assetType == Constants.AssetTypeIdStrings.DynamicHead and v242.staticFacialAnimation ~= nil then
							return v242.staticFacialAnimation
						end
					end
				end
			end

			return nil
		end
	end

	if FFlagFixHeadShapeColorSlider then
		function t1.getHeadShapeFromAssetMetadata(t12: {[any]: any}) -- line: 876
			-- upvalues: FFlagAXFixR6DefaultHeadShape (copy)
			for _, v245 in t12 do
				if v245.headShape and (not FFlagAXFixR6DefaultHeadShape or v245.headShape ~= "Default") then
					return v245.headShape
				end
			end

			return nil
		end
		function t1.applyHeadShapeFromAssetMetadata(p40, t13: {[any]: any}) -- line: 888
			-- upvalues: Cryo (copy), t1 (copy)
			local v248 = Cryo.Dictionary.keys(t13)

			for _, child in p40:GetChildren() do
				if child:IsA("BodyPartDescription") and child.BodyPart == Enum.BodyPart.Head then
					local v251 = t1.getHeadShapeFromAssetMetadata(t13)

					if v251 then
						child.HeadShape = v251
					end

					child.AssetId = tonumber(v248[1]) or 0
				end
			end
		end
	end

	function t1.applyHeadShapeToHumanoidDescription(p41, p42) -- line: 914
		-- upvalues: t1 (copy), FFlagHeadRefinementFacialAnimationToggle (copy), Constants (copy)
		local v254, v255 = t1.getHeadShapeFromTryOn(p42)
		local v256 = t1.getHeadShapeFromEquippedAssets(p42)

		if FFlagHeadRefinementFacialAnimationToggle then
			local v257 = nil

			if v255 then
				v257 = t1.getStaticFacialAnimationFromTryOn(p42)
			end

			if v257 == nil then
				v257 = t1.getStaticFacialAnimationFromEquippedAssets(p42)
			end

			if v257 ~= nil then
				p41[Constants.StaticFacialAnimation] = v257
			end
		end

		local v258 = if not v255 then v256 else v254

		if v258 == "Default" then
			v258 = nil
		end

		if v258 then
			for _, child in p41:GetChildren() do
				if child:IsA("BodyPartDescription") and child.BodyPart == Enum.BodyPart.Head and v258 then
					child.HeadShape = v258
				end
			end
		end
	end
end

function t1.updateHumanoidDescriptionUsingOutfitTryOn(p43, p44, t14: {[any]: any}?) -- line: 959
	-- upvalues: GetFFlagFixCharacterManagerValueConversionWarning (copy), t1 (copy), Constants (copy), Utils2 (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), setMakeupDescriptions (copy), FFlagAXMISEnableMultiShopping (copy), normalizeTryOnAsset (copy), getNormalizedAssetsFromTryOnBundle (copy), AvatarWidgetBlockyUtils (copy), updateHumanoidDescriptionTryOnFromNormalizedAssets (copy), FFlagAXCatalogMakeupSupport (copy), updateHumanoidDescriptionTryOnOutfitAsset (copy), updateHumanoidDescriptionTryOnOutfitBundle (copy), updateHumanoidDescriptionTryOnItemBundle (copy), updateHumanoidDescriptionTryOnOutfitBundleNoUserOutfit (copy)
	if GetFFlagFixCharacterManagerValueConversionWarning() then
		t1.resetHumanoidDescriptionProperties(p44)
	else
		for _, v265 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
			p44[v265] = ""
		end
	end

	p44:SetAccessories({}, true)

	local TryOnItems = p43.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local LookType = p43.AvatarExperience.AvatarScene.OutfitTryOn.LookType
	local t15 = {}
	local v269 = Utils2.sortOutfitTryOnItemsByRecency(TryOnItems, false)

	if FFlagAXMakeupEquipping then
		local t16 = {}

		for _, v272 in TryOnItems do
			if v272.selectedInTryOnManager and v272.itemType == Constants.ItemType.Asset then
				local itemSubType = v272.itemSubType

				if isMakeupAssetType(itemSubType) then
					if not t16[itemSubType] then
						t16[itemSubType] = {}
					end

					t16[itemSubType][v272.itemId] = v272
				end
			end
		end

		setMakeupDescriptions(p44, t16)
	end

	if FFlagAXMISEnableMultiShopping then
		local t17 = {}

		if t14 then
			for _, v276 in t14 do
				t17[v276.itemId] = true
			end
		end

		local t18 = {}

		for _, v279 in v269 do
			if v279.selectedInTryOnManager ~= false and (not t14 or t17[v279.itemId]) then
				if v279.itemType == Constants.ItemType.Asset then
					table.insert(t18, (normalizeTryOnAsset(v279, p43)))
				elseif v279.itemType == Constants.ItemType.Bundle then
					for _, v281 in (getNormalizedAssetsFromTryOnBundle(v279, p43)) do
						table.insert(t18, v281)
					end
				end
			end
		end

		local v282 = AvatarWidgetBlockyUtils.buildEquippedAssetMapByHumanoidDescriptionProp(p43)
		local v283 = updateHumanoidDescriptionTryOnFromNormalizedAssets(p44, {}, t18, v282)

		t1.tryApplyClassicHeadShapeTryOn(p43, p44)

		local t19 = {}

		for _, v286 in v283 do
			for _, v288 in v286 do
				table.insert(t19, v288)
			end
		end

		p44:SetAccessories(t19, true)

		return
	end

	for _, v290 in v269 do
		if v290.selectedInTryOnManager or LookType == Constants.LookType.Avatar and (not FFlagAXCatalogMakeupSupport or LookType == Constants.LookType.Makeup) then
			if v290.itemType == Constants.ItemType.Asset then
				updateHumanoidDescriptionTryOnOutfitAsset(p43, v290, v290.itemId, t15, p44)
			elseif v290.itemType == Constants.ItemType.Bundle then
				local v291 = Utils2.getBundleInfoFromState(p43, v290.itemId)
				local v292 = Utils2.getOutfitInfoFromBundleId(p43, v290.itemId)

				if v292 then
					updateHumanoidDescriptionTryOnOutfitBundle(p43, v292, v290, t15, p44)
				elseif v290.bundleInfo ~= nil and (LookType == Constants.LookType.Avatar or FFlagAXCatalogMakeupSupport and LookType == Constants.LookType.Makeup) then
					updateHumanoidDescriptionTryOnItemBundle(p43, v290, t15, p44)
				elseif v291 then
					updateHumanoidDescriptionTryOnOutfitBundleNoUserOutfit(p43, v290, v291, t15)
				end
			end
		end
	end

	t1.tryApplyClassicHeadShapeTryOn(p43, p44)
	p44:SetAccessories(t15, true)
end
function t1.makeupAssetsTryOn(p45, p46, p47) -- line: 1115
	-- upvalues: getMakeupDescriptionsFromHumanoidDescription (copy), Cryo (copy), getTryOnItemReducerKey (copy), Constants (copy), MAX_MAKEUP_LAYERS (copy), destroyMakeupDescriptions (copy)
	local v296 = getMakeupDescriptionsFromHumanoidDescription(p47)

	if #v296 == 0 then
		return
	end

	local TryOnItems = p45.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v298 = getMakeupDescriptionsFromHumanoidDescription(p46)

	if p45.AvatarExperience.LayeredClothingSort and p45.AvatarExperience.LayeredClothingSort.CurrentSort and #p45.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList > 0 then
		local OrderedList = p45.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList

		v298 = Cryo.List.filter(v298, function(p48) -- line: 1133
			-- upvalues: OrderedList (copy)
			for _, v358 in OrderedList do
				if tostring(v358.id) == tostring(p48.AssetId) then
					return true
				end
			end

			return false
		end)
	end

	table.sort(v298, function(p49, p50) -- line: 1144
		return p49.Order < p50.Order
	end)

	local t20 = {}

	for _, v302 in v298 do
		t20[v302.AssetId] = true
	end

	local t21 = {}

	for _, v305 in v296 do
		if not t20[v305.AssetId] then
			local v306 = TryOnItems[getTryOnItemReducerKey(tostring(v305.AssetId), Constants.ItemType.Asset)]

			v305.Order = if not v306 then MAX_MAKEUP_LAYERS else v306.order
			table.insert(t21, v305)
		end
	end

	local v307 = if not (#v298 + #t21 <= MAX_MAKEUP_LAYERS) then { table.unpack(v298, #v298 + #t21 - MAX_MAKEUP_LAYERS + 1) } else v298

	for _, v309 in t21 do
		table.insert(v307, v309)
	end

	table.sort(v307, function(p51, p52) -- line: 1186
		-- upvalues: getTryOnItemReducerKey (copy), Constants (copy), TryOnItems (copy)
		if p51.Order == p52.Order then
			local v363 = getTryOnItemReducerKey(tostring(p51.AssetId), Constants.ItemType.Asset)
			local v364 = getTryOnItemReducerKey(tostring(p52.AssetId), Constants.ItemType.Asset)

			if not TryOnItems[v363] then
				return true
			end

			if not TryOnItems[v364] then
				return false
			end

			return TryOnItems[v363].itemRecency < TryOnItems[v364].itemRecency
		end

		return p51.Order < p52.Order
	end)

	local t22 = {}

	for _, v312 in v307 do
		table.insert(t22, v312:Clone())
	end

	destroyMakeupDescriptions(p46)

	for v313, v314 in t22 do
		v314.Order = v313 - 1
		v314.Parent = p46
	end
end
function t1.singleMakeupAssetTryOn(p53, p54, p55) -- line: 1219
	-- upvalues: FFlagAXMakeupEquipping (copy), getMakeupDescriptionsFromHumanoidDescription (copy), getTryOnItemReducerKey (copy), Constants (copy), MAX_MAKEUP_LAYERS (copy), destroyMakeupDescriptions (copy)
	if not FFlagAXMakeupEquipping then
		return
	end

	local v318 = getMakeupDescriptionsFromHumanoidDescription(p55)[1]

	if not v318 then
		return
	end

	local v319 = p53.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(tostring(v318.AssetId), Constants.ItemType.Asset)]
	local v320 = getMakeupDescriptionsFromHumanoidDescription(p54)

	table.sort(v320, function(p56, p57) -- line: 1238
		return p56.Order < p57.Order
	end)

	for _, v322 in v320 do
		if v322.AssetId == v318.AssetId then
			return
		end
	end

	if #v320 < MAX_MAKEUP_LAYERS then
	else
		table.remove(v320, 1)
	end

	local v323 = if not v319 then nil else v319.order
	local v324 = #v320
	local v325 = if v323 ~= nil then math.max(0, (math.min(v323, v324))) else v324
	local t23 = {}

	for _, v328 in v320 do
		table.insert(t23, v328:Clone())
	end

	table.insert(t23, v325 + 1, v318)
	destroyMakeupDescriptions(p54)

	for v329, v330 in t23 do
		v330.Order = v329 - 1
		v330.Parent = p54
	end
end
function t1.lookMakeupTryOn(p58, p59) -- line: 1289
	-- upvalues: FFlagAXMakeupEquipping (copy), destroyMakeupDescriptions (copy), getMakeupDescriptionsFromHumanoidDescription (copy)
	if not FFlagAXMakeupEquipping then
		return
	end

	destroyMakeupDescriptions(p58)

	for _, v334 in getMakeupDescriptionsFromHumanoidDescription(p59) do
		v334:Clone().Parent = p58
	end
end
function t1.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p60, t24: {[any]: any}?) -- line: 1303
	-- upvalues: t1 (copy), Utils (copy), FFlagAXMakeupEquipping (copy), Constants (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogMakeupSupport (copy), destroyMakeupDescriptions (copy), AvatarWidgetBlockyUtils (copy), setAccessoriesFromTryOn (copy), FFlagAXMakeupFixAvatarLooksTryOn (copy), getTryOnsBundleOutfitInfo (copy), FFlagEnableHeadShapeForCharacterManager (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")

	t1.updateHumanoidDescriptionUsingOutfitTryOn(p60, HumanoidDescription, t24)

	local clone = Utils.getHumanoidDescriptionFromState(p60.AvatarExperience):Clone()
	local _ = p60.AvatarExperience.AvatarScene.OutfitTryOn.LookId
	local v340 = nil
	local v341 = nil

	if FFlagAXMakeupEquipping then
		v340 = p60.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
		v341 = v340 and p60.AvatarExperience.AvatarScene.OutfitTryOn.LookType == Constants.LookType.Makeup
	end

	local ShouldTryOnWithoutEquippedItems

	if FFlagAXMISEnableMultiShopping then
		v341 = p60.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId ~= nil
		ShouldTryOnWithoutEquippedItems = p60.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
	else
		v340 = p60.AvatarExperience.AvatarScene.OutfitTryOn.LookId ~= nil
		ShouldTryOnWithoutEquippedItems = v340 and not v341
	end

	if ShouldTryOnWithoutEquippedItems then
		clone:SetAccessories({}, true)
		clone.GraphicTShirt = 0
		clone.Shirt = 0
		clone.Pants = 0

		if FFlagAXCatalogMakeupSupport then
			destroyMakeupDescriptions(clone)
		end
	end

	for v343, v344 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToCategory[v343] == Constants.AssetCategories.Body and AvatarWidgetBlockyUtils.shouldUnequipBodyBeforeTryOn(p60) then
			clone[v344] = 0
		end

		if not Constants.AssetTypeIdToAccessoryTypeEnum[v343] then
			local v345 = HumanoidDescription[v344]

			if v345 ~= "" and v345 ~= 0 then
				clone[v344] = HumanoidDescription[v344]
			end
		end
	end

	setAccessoriesFromTryOn(p60, clone, HumanoidDescription)

	if FFlagAXMakeupFixAvatarLooksTryOn and v340 or v341 then
		t1.lookMakeupTryOn(clone, HumanoidDescription)
	elseif FFlagAXMISEnableMultiShopping then
		t1.makeupAssetsTryOn(p60, clone, HumanoidDescription)
	else
		t1.singleMakeupAssetTryOn(p60, clone, HumanoidDescription)
	end

	local v346 = getTryOnsBundleOutfitInfo(p60)

	if v346 then
		for v347, v348 in v346.scales do
			clone[Constants.HumanoidDescriptionScaleToName[v347]] = v348
		end

		Utils.setHumanoidDescriptionColorsFromBodyColor3s(clone, v346.bodyColor3s)
	end

	t1.setAvatarTryOnProperties(clone, p60)

	if FFlagEnableHeadShapeForCharacterManager then
		t1.applyHeadShapeToHumanoidDescription(clone, p60)
	end

	return clone
end

if FFlagAXMISEnableMultiShopping then
	function t1.getBundleOutfitInfoFromProvidedTryOns(p61, t25: {[any]: any}) -- line: 1412
		-- upvalues: Constants (copy), Utils2 (copy)
		for _, v352 in t25 do
			if v352.itemType ~= Constants.ItemType.Bundle or v352.itemSubType ~= Constants.BundleTypeIdStrings.BodyParts then
				continue
			end

			local v353 = Utils2.getOutfitInfoFromBundleId(p61, v352.itemId)

			if v353 then
				return v353
			end
		end

		return nil
	end
end

return t1
