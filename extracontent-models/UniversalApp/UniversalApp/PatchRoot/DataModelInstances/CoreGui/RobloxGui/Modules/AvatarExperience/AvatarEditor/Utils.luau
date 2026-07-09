local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local ColorPickerUtils = require(Modules.AvatarExperience.ColorPicker.ColorPickerUtils)

require(Modules.AvatarExperience.Common.Types)

local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
require(Modules.AvatarExperience.AvatarEditor.Reducers.Character)
require(Modules.AvatarExperience.Common.Reducers.AvatarExperience)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local setMakeupDescriptions = AvatarExperienceCommon.Utils.setMakeupDescriptions
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType
local isLayeredClothingAssetType = AvatarExperienceCommon.Utils.isLayeredClothingAssetType
local GetFFlagAvatarEditorServiceCreateOutfitSupportsGears = require(Modules.AvatarExperience.Flags.GetFFlagAvatarEditorServiceCreateOutfitSupportsGears)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXFixOutfitEquipCheckEmptyArray = AvatarExperienceFlags.FFlagAXFixOutfitEquipCheckEmptyArray
local t1 = {}
local GetFFlagEnableNewCustomizeBundleEquip = require(Modules.AvatarExperience.Flags.GetFFlagEnableNewCustomizeBundleEquip)
local FFlagAXFixCheckOnOutfitAssets = require(Modules.AvatarExperience.Flags.FFlagAXFixCheckOnOutfitAssets)
local FFlagAXSimplifyOutfitEquipCheck = require(Modules.AvatarExperience.Flags.FFlagAXSimplifyOutfitEquipCheck)
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

t1.ReverseKeyValuePairs = memoize(function(p1) -- line: 59
	local t2 = {}

	for _, v38 in p1 do
		if not t2[v38] then
			t2[v38] = 0
		end
	end

	return t2
end)

function t1.Contains(p2, p3) -- line: 77
	-- upvalues: t1 (copy)
	if t1.ReverseKeyValuePairs(p2)[p3] then
		return true
	end

	return false
end
function t1.isFullyQualifiedOutfit(p4) -- line: 94
	-- upvalues: Constants2 (copy), FFlagAXFixCheckOnOutfitAssets (copy)
	local t3 = {
		Torso = Constants2.AssetTypeIdStrings.Torso,
		RightArm = Constants2.AssetTypeIdStrings.RightArm,
		LeftArm = Constants2.AssetTypeIdStrings.LeftArm,
		LeftLeg = Constants2.AssetTypeIdStrings.LeftLeg,
		RightLeg = Constants2.AssetTypeIdStrings.RightLeg
	}

	if FFlagAXFixCheckOnOutfitAssets and not p4 then
		return false
	end

	for _, v44 in t3 do
		if not p4[v44] then
			return false
		end
	end

	for v45, _ in p4 do
		if Constants2.AssetTypeIdToAccessoryTypeEnum[v45] ~= Enum.AccessoryType.Hair and (Constants2.AssetTypeIdToAccessoryTypeEnum[v45] or v45 == Constants2.AssetTypeIdStrings.Gear) then
			return true
		end
	end

	return false
end
function t1.isWearingDynamicHeadOutfit(p5, p6) -- line: 129
	-- upvalues: t1 (copy), Constants2 (copy)
	local v49 = t1.getEquippedAssetIds(p5.assets)

	if not p6 then
		return false
	end

	for v50, _ in p5.assets do
		if not p6[v50] then
			return false
		end

		local v52 = next(p6[v50])

		if next(p5.assets[v50]) then
			local v53 = false

			for _, v55 in v49 do
				if v55 == v52 then
					v53 = true
				end
			end

			if v53 then
				continue
			end

			return false
		end
	end

	if not p5.assets[Constants2.AssetTypeIdStrings.DynamicHead] then
		return false
	end

	return true
end
function t1.getAssetMetadata(p7, p8) -- line: 170
	-- upvalues: FFlagAXInventoryDurablesSupport (copy)
	for _, v59 in p8 do
		for v60, v61 in v59 do
			if p7 == v60 then
				if FFlagAXInventoryDurablesSupport then
					local v62 = table.clone(v61)

					v62.availabilityStatus = nil

					return v62
				end

				return v61
			end
		end
	end

	return nil
end
function t1.isSameAssetMetadata(t4: {[any]: any}, t5: {[any]: any}) -- line: 187
	-- upvalues: Cryo (copy), Utils (copy)
	if t4 == nil and t5 == nil then
		return true
	end

	if t4 == nil or t5 == nil then
		return false
	end

	local v65 = Cryo.Dictionary.keys(t4)
	local v66 = Cryo.Dictionary.keys(t5)

	if #v65 ~= #v66 then
		return false
	end

	for v67, v68 in t4 do
		local v69 = t5[v67]

		if typeof(v68) ~= "Vector3" or typeof(v69) ~= "Vector3" then
			if v68 == v69 then
				continue
			end

			return false
		end

		if not Utils.fuzzyEq(v68.X, v69.X) or (not Utils.fuzzyEq(v68.Y, v69.Y) or not Utils.fuzzyEq(v68.Z, v69.Z)) then
			return false
		end
	end

	return true
end
function t1.removeEmoteAnimationAsset(p9) -- line: 218
	-- upvalues: Constants2 (copy), Cryo (copy)
	if not p9[Constants2.AssetTypeIdStrings.EmoteAnimation] then
		return p9
	end

	return Cryo.Dictionary.join(p9, {
		[Constants2.AssetTypeIdStrings.EmoteAnimation] = Cryo.None
	})
end
function t1.getEquippedAssetIds(p10) -- line: 228
	-- upvalues: Constants2 (copy)
	local t6 = {}

	if not p10 then
		return t6
	end

	for _, v74 in Constants2.AssetTypeIdStrings do
		local v75 = p10[v74]

		if v75 then
			for v76, _ in v75 do
				table.insert(t6, v76)
			end
		end
	end

	return t6
end
function t1.getEquippedAssetIdsForType(p11, p12) -- line: 247
	local t7 = {}

	if not p11 then
		return t7
	end

	local v81 = p11[p12]

	if v81 then
		for v82, _ in v81 do
			table.insert(t7, v82)
		end
	end

	return t7
end
function t1.getEquippedAssetIdsForCategory(p13, p14) -- line: 264
	-- upvalues: t1 (copy)
	local t8 = {}

	if not p14.AssetTypeIdStrings then
		return t8
	end

	for _, v88 in p14.AssetTypeIdStrings do
		for _, v90 in (t1.getEquippedAssetIdsForType(p13, v88)) do
			t8[#t8 + 1] = v90
		end
	end

	return t8
end
function t1.isAssetEquipped(p15, p16, p17) -- line: 280
	if p17 then
		local v94 = p17[p16]

		if v94 == nil or not next(v94) then
			return false
		end

		if v94[p15] then
			return true
		end
	end

	return false
end
function t1.isPresetOutfit(p18) -- line: 295
	return not p18.isEditable
end
function t1.isDuplicateOutfitName(p19, p20, p21, p22) -- line: 299
	-- upvalues: FFlagAXOutfitPageRevamp (copy), t1 (copy), Constants (copy)
	local v100 = string.lower(utf8.nfdnormalize(p21))

	for _, v102 in p19[(if not FFlagAXOutfitPageRevamp or not p22 then Constants.EditableCharacterKey else t1.getOutfitSubtypeKey(p22, true))] or {} do
		local str = tostring(v102)

		if p20[str] and v100 == string.lower(utf8.nfdnormalize(p20[str].name)) then
			return true
		end
	end

	return false
end

local function diffListTruncated(t9: {[any]: any}, t10: {[any]: any}) -- line: 326
	-- upvalues: Cryo (copy)
	local v106 = Cryo.List.toSet(t10)

	return (Cryo.List.filter(t9, function(p23, _) -- line: 328
		-- upvalues: v106 (copy)
		return not v106[p23]
	end))
end

function t1.diffList(t11: {[any]: any}, t12: {[any]: any}) -- line: 335
	-- upvalues: Cryo (copy)
	local v109 = Cryo.List.toSet(t12)
	local v110 = Cryo.List.filter(t11, function(p25, _) -- line: 328
		-- upvalues: v109 (copy)
		return not v109[p25]
	end)
	local v111 = Cryo.List.toSet(t11)
	local v112 = Cryo.List.filter(t12, function(p27, _) -- line: 328
		-- upvalues: v111 (copy)
		return not v111[p27]
	end)

	return (Cryo.List.join(v110, v112))
end
function t1.getEquippedDiffs(t13: {[any]: any}, t14: {[any]: any}) -- line: 342
	-- upvalues: t1 (copy)
	local t15 = {}

	for v116, _ in t14 do
		local v118 = t1.getEquippedAssetIdsForType(t14, v116)
		local v119 = t1.getEquippedAssetIdsForType(t13, v116)

		if next(v119) then
			local v120 = t1.diffList(v118, v119)

			if next(v120) ~= nil then
				t15[v116] = v120
			end
		elseif next(v118) then
			t15[v116] = v118
		end
	end

	for v121, _ in t13 do
		local v123 = t1.getEquippedAssetIdsForType(t13, v121)
		local v124 = t1.getEquippedAssetIdsForType(t14, v121)

		if next(v124) then
			local v125 = t1.diffList(v123, v124)

			if next(v125) ~= nil then
				t15[v121] = v125
			end
		elseif next(v123) then
			t15[v121] = v123
		end
	end

	return t15
end
function t1.isDynamicHeadEquipped(p29) -- line: 374
	-- upvalues: Cryo (copy), t1 (copy), Constants2 (copy)
	return not Cryo.isEmpty(t1.getEquippedAssetIdsForType(p29, Constants2.AssetTypeIdStrings.DynamicHead))
end
function t1.isClassicHeadEquipped(p30) -- line: 380
	-- upvalues: Cryo (copy), t1 (copy), Constants2 (copy)
	return not Cryo.isEmpty(t1.getEquippedAssetIdsForType(p30, Constants2.AssetTypeIdStrings.Head))
end
function t1.hasWrapLayer(p31) -- line: 386
	if not p31 then
		return false
	end

	return p31:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
end

t1.hasLayeredAssetsEquipped = memoize(function(p32) -- line: 393
	if not p32 then
		return false
	end

	for _, v131 in p32 do
		for _, v133 in v131 do
			if v133.isLayered then
				return true
			end
		end
	end

	return false
end)

function t1.setHumanoidDescriptionColorsFromBodyColor3s(p33, p34) -- line: 408
	-- upvalues: Constants2 (copy)
	if p34 then
		for v136, v137 in p34 do
			p33[Constants2.BodyPartForSkinColoringIdToHumanoidDescription[v136]] = v137
		end
	end
end
function t1.setHumanoidDescriptionColorsFromCharacter(p35, p36) -- line: 421
	-- upvalues: t1 (copy)
	t1.setHumanoidDescriptionColorsFromBodyColor3s(p35, p36.AvatarEditor.Character.BodyColor3s)
end
function t1.getGearAssetIdFromState(p37) -- line: 431
	-- upvalues: GetFFlagAvatarEditorServiceCreateOutfitSupportsGears (copy), t1 (copy), Constants2 (copy)
	if not GetFFlagAvatarEditorServiceCreateOutfitSupportsGears() then
		return 0
	end

	local EquippedAssets = p37.AvatarEditor.Character.EquippedAssets

	if EquippedAssets == nil then
		return 0
	end

	local v142 = t1.getEquippedAssetIdsForType(EquippedAssets, Constants2.AssetTypeIdStrings.Gear)
	local _, v144 = next(v142)

	if v144 then
		return (tonumber(v144))
	end

	return 0
end
function t1.getHumanoidDescriptionFromState(p38) -- line: 450
	-- upvalues: Constants2 (copy), Utils (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy), t1 (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")
	local EquippedAssets = p38.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p38.AvatarEditor.Character.AvatarScales
	local staticFacialAnimation = nil

	if EquippedAssets then
		local t16 = {}

		for v151, v152 in EquippedAssets do
			local t17 = {}
			local v154 = Constants2.AssetTypeIdToAccessoryTypeEnum[v151]

			for v155, v156 in v152 do
				if v154 then
					table.insert(t16, Utils.createHumanoidDescriptionAccessoryInfo(v151, v155, v156))
				else
					table.insert(t17, v155)
				end
			end

			if v154 == nil and #t17 > 0 then
				local v157 = Constants2.AssetTypeIdStringToHumanoidDescriptionProp[v151]
				local v158 = table.concat(t17, ",")

				if v157 then
					if FFlagParseHeadShapeFromAPIResponse and Constants2.BodyPartNameToEnum[v157] then
						local BodyPartDescription = Instance.new("BodyPartDescription")

						BodyPartDescription.AssetId = v158
						BodyPartDescription.Parent = HumanoidDescription
						BodyPartDescription.BodyPart = Constants2.BodyPartNameToEnum[v157]

						if v151 == Constants2.AssetTypeIdStrings.DynamicHead then
							local v160 = nil

							for _, v162 in t17 do
								local v163 = v152[v162]

								if FFlagHeadRefinementFacialAnimationToggle and v163 and v163.staticFacialAnimation ~= nil then
									staticFacialAnimation = v163.staticFacialAnimation
								end

								if v163 and v163.headShape then
									v160 = if v163.headShape ~= "Default" then v163.headShape else nil

									break
								end
							end

							if v160 then
								BodyPartDescription.HeadShape = v160
							end
						end
					else
						HumanoidDescription[v157] = v158
					end
				elseif v151 ~= Constants2.AssetTypeIdStrings.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v151)) then
					mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v151))))
				end
			end
		end

		HumanoidDescription:SetAccessories(t16, true)

		if FFlagAXMakeupEquipping then
			setMakeupDescriptions(HumanoidDescription, EquippedAssets)
		end

		if FFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
			HumanoidDescription[Constants2.StaticFacialAnimation] = staticFacialAnimation
		end
	end

	if AvatarScales then
		for v164, v165 in AvatarScales do
			HumanoidDescription[Constants2.HumanoidDescriptionScaleToName[v164]] = v165
		end
	end

	t1.setHumanoidDescriptionColorsFromCharacter(HumanoidDescription, p38)

	local t18 = {}
	local t19 = {}

	for _, v169 in p38.AvatarEditor.EquippedEmotes.slotInfo do
		t18[tostring(v169.assetId)] = { (tonumber(v169.assetId)) }
		table.insert(t19, {
			Slot = v169.position,
			Name = tostring(v169.assetId)
		})
	end

	HumanoidDescription:SetEmotes(t18)
	HumanoidDescription:SetEquippedEmotes(t19)

	return HumanoidDescription
end
function t1.getHumanoidDescriptionFromOutfitInfo(p39) -- line: 559
	-- upvalues: Constants2 (copy), Utils (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy), t1 (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")
	local assets = p39.assets
	local scales = p39.scales

	if assets then
		local t20 = {}

		for v175, v176 in assets do
			local t21 = {}
			local v178 = Constants2.AssetTypeIdToAccessoryTypeEnum[v175]

			for v179, v180 in v176 do
				if v178 then
					table.insert(t20, Utils.createHumanoidDescriptionAccessoryInfo(v175, v179, v180))
				else
					table.insert(t21, v179)
				end
			end

			if v178 == nil and #t21 > 0 then
				local v181 = Constants2.AssetTypeIdStringToHumanoidDescriptionProp[v175]
				local v182 = table.concat(t21, ",")

				if v181 then
					HumanoidDescription[v181] = v182
				elseif v175 ~= Constants2.AssetTypeIdStrings.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v175)) then
					mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v175))))
				end
			end
		end

		HumanoidDescription:SetAccessories(t20, true)

		if FFlagAXMakeupEquipping then
			setMakeupDescriptions(HumanoidDescription, assets)
		end
	end

	if scales then
		for v183, v184 in scales do
			HumanoidDescription[Constants2.HumanoidDescriptionScaleToName[v183]] = v184
		end
	end

	t1.setHumanoidDescriptionColorsFromBodyColor3s(HumanoidDescription, p39.bodyColor3s)

	return HumanoidDescription
end
function t1.shouldNotifyAssetTypes(p40, p41) -- line: 621
	for _, v188 in p40 do
		if p41[v188] == true then
			return true
		end
	end

	return false
end
function t1.shouldNotifyBundleTypes(p42, p43) -- line: 634
	-- upvalues: Constants2 (copy)
	for _, v192 in p42 do
		if p43[Constants2.BundleTypeIdStringToOutfitType[v192]] == true then
			return true
		end
	end

	return false
end
function t1.shouldNotifyCategory(p44, t22: {[any]: any}) -- line: 648
	-- upvalues: t1 (copy)
	local AssetTypeIdStrings = p44.AssetTypeIdStrings
	local BundleTypeIdStrings = p44.BundleTypeIdStrings
	local Subcategories = p44.Subcategories
	local SubcategoryFilters = p44.SubcategoryFilters

	if AssetTypeIdStrings and t1.shouldNotifyAssetTypes(AssetTypeIdStrings, t22) then
		return true
	end

	if BundleTypeIdStrings and t1.shouldNotifyBundleTypes(BundleTypeIdStrings, t22) then
		return true
	end

	if Subcategories then
		for _, v200 in Subcategories do
			if t1.shouldNotifyCategory(v200, t22) then
				return true
			end
		end
	elseif SubcategoryFilters then
		for _, v202 in SubcategoryFilters do
			if t1.shouldNotifyCategory(v202, t22) then
				return true
			end
		end
	end

	return false
end
function t1.getNotificationItemTypesForCategory(p45, t23: {[any]: any}) -- line: 680
	-- upvalues: Constants2 (copy), t1 (copy), Cryo (copy)
	local t24 = {}
	local AssetTypeIdStrings = p45.AssetTypeIdStrings
	local BundleTypeIdStrings = p45.BundleTypeIdStrings
	local Subcategories = p45.Subcategories
	local SubcategoryFilters = p45.SubcategoryFilters

	if AssetTypeIdStrings then
		for _, v211 in AssetTypeIdStrings do
			if t23[v211] then
				t24[v211] = true
			end
		end
	end

	if BundleTypeIdStrings then
		for _, v213 in BundleTypeIdStrings do
			local v214 = Constants2.BundleTypeIdStringToOutfitType[v213]

			if t23[v214] then
				t24[v214] = true
			end
		end
	end

	if Subcategories then
		for _, v216 in Subcategories do
			for _, v218 in t1.getNotificationItemTypesForCategory(v216, t23) do
				t24[v218] = true
			end
		end
	end

	if SubcategoryFilters then
		for _, v220 in SubcategoryFilters do
			for _, v222 in t1.getNotificationItemTypesForCategory(v220, t23) do
				t24[v222] = true
			end
		end
	end

	return Cryo.Dictionary.keys(t24)
end
function t1.doAESCallAndAwaitResult(p46, p47, p48, ...) -- line: 725
	local v226 = p47(p46, ...)

	while not v226 do
		p48:Wait()
		v226 = p47(p46, ...)
	end

	return p48:Wait()
end

t1.getColor3AtValueInRange = memoize(function(t25: {[any]: any}, n1: number) -- line: 736
	-- upvalues: ColorPickerUtils (copy), mutedError (copy)
	local v229, v230 = ColorPickerUtils.clampBetween0And1(n1)

	if v230 then
		mutedError(string.format("getColor3AtValueInRange: value %s should be between 0 and 1 inclusive", (tostring(n1))))
	end

	if v229 == 0 then
		return t25[1]
	end

	if v229 == 1 then
		return t25[#t25]
	end

	local v231 = v229 * (#t25 - 1)
	local v232 = math.floor(v231 + 1)
	local v233 = v231 + 1 - v232

	return t25[v232]:Lerp(t25[v232 + 1], v233)
end)

local function v33(color3: Color3, color3_2: Color3, color3_3: Color3) -- line: 767
	local vector3 = Vector3.new(color3.R, color3.G, color3.B)
	local vector3_2 = Vector3.new(color3_2.R, color3_2.G, color3_2.B)
	local vector3_3 = Vector3.new(color3_3.R, color3_3.G, color3_3.B)
	local v240 = vector3_2 - vector3
	local v241 = vector3_3 - vector3

	if v241:Dot(v240) <= 0 then
		return v241.Magnitude, 0
	end

	local v242 = vector3_3 - vector3_2

	if v242:Dot(v240) >= 0 then
		return v242.Magnitude, 1
	end

	return v240:Cross(v241).Magnitude / v241.Magnitude, v240.Unit:Dot(v241) / v240.Magnitude
end
local function v34(t26: {[any]: any}, color3: Color3) -- line: 812
	-- upvalues: v33 (copy)
	local n2 = 10
	local n3 = 0

	for i = 1, #t26 - 1 do
		local v248 = t26[i]
		local v249 = t26[i + 1]
		local v250, v251 = v33(v248, v249, color3)

		if v250 < n2 then
			n2 = v250
			n3 = (i - 1 + v251) / (#t26 - 1)
		end
	end

	return n2, n3
end

function t1.findRangeAndSliderValueForColor3(color3: Color3, p49) -- line: 838
	-- upvalues: v34 (copy)
	local n4 = 10
	local n5 = 0
	local rangeId = nil

	for _, v258 in p49 do
		local v259, v260 = v34(v258.range, color3)

		if v259 < n4 then
			n4 = v259
			n5 = v260
			rangeId = v258.rangeId
		end
	end

	return rangeId, n5
end

t1.getRangeStructForRangeId = memoize(function(s1: string, p50) -- line: 858
	for _, v264 in p50 do
		if s1 == v264.rangeId then
			return v264
		end
	end

	return nil
end)
t1.getColor3AtValueForRangeId = memoize(function(s2: string, n6: number, p51) -- line: 869
	-- upvalues: ColorPickerUtils (copy), mutedError (copy), t1 (copy)
	local v268, v269 = ColorPickerUtils.clampBetween0And1(n6)

	if v269 then
		mutedError(string.format("getColor3AtValueInRange: value %s should be between 0 and 1 inclusive", (tostring(n6))))
	end

	local v270 = t1.getRangeStructForRangeId(s2, p51)

	if v270 then
		return t1.getColor3AtValueInRange(v270.range, v268)
	end

	return nil
end)

function t1.getInfoForRangeIdAndBodyPartIndex(s3: string, n7: number, p52) -- line: 893
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isNotNil(s3, "rangeId")
	ArgCheck.assert(n7 >= 1, "selectedBodyPartIndex too low")
	ArgCheck.assert(n7 <= #Constants.BodyPartButtonData, "selectedBodyPartIndex too high")

	if p52 == nil or p52[s3] == nil then
		return nil
	end

	local v274 = p52[s3]
	local v275 = nil

	for _, v277 in Constants.BodyPartButtonData[n7].bodyPartForSkinColoringIds do
		if not v274[v277] then
			continue
		end

		if v275 ~= nil then
			if v275.color3 == v274[v277].color3 then
				continue
			end

			return nil
		end

		v275 = v274[v277]
	end

	return v275
end

t1.getColor3ForRangeIdAndBodyPartIndex = memoize(function(s4: string, n8: number, p53, p54) -- line: 941
	-- upvalues: ArgCheck (copy), t1 (copy)
	ArgCheck.isNotNil(p54, "defaultBodyColorRanges")

	local v282 = t1.getInfoForRangeIdAndBodyPartIndex(s4, n8, p53)

	if v282 then
		return v282.color3
	end

	return t1.getColor3AtValueForRangeId(s4, 0.5, p54)
end)
t1.getSliderValueForRangeIdAndBodyPartIndex = memoize(function(s5: string, n9: number, p55) -- line: 965
	-- upvalues: t1 (copy)
	local v286 = t1.getInfoForRangeIdAndBodyPartIndex(s5, n9, p55)

	if v286 then
		return v286.sliderValue
	end

	return 0.5
end)

function t1.getBodyColorsSliderFrameHeight(p56, p57, p58, p59) -- line: 989
	local v291 = p58 - math.max(p57, p59)

	if p56 < v291 then
		return v291
	end

	return p56
end
function t1.getSearchUuidAndAssetTypes(p60, p61, p62) -- line: 1005
	-- upvalues: FFlagAXEditorSubcategoryFilters (copy)
	if p60.SubButtons then
		local v295 = p61 or 1
		local v296 = p60.SubButtons[v295]

		return v296.SearchUuid, v296.AssetTypeIdStrings
	end

	if FFlagAXEditorSubcategoryFilters and p60.SubcategoryFilters then
		local v297 = p62 or 1
		local v298 = p60.SubcategoryFilters[v297] or p60.SubcategoryFilters[1]

		return v298.SearchUuid, v298.AssetTypeIdStrings
	end

	return p60.SearchUuid, p60.AssetTypeIdStrings
end
function t1.getCategoryIndicesFromAssetType(p63) -- line: 1026
	-- upvalues: GetAvatarEditorCategories (copy)
	for v300, v301 in (GetAvatarEditorCategories()) do
		if v301.Subcategories then
			for v302, v303 in v301.Subcategories do
				if v303.AssetTypeIdStrings then
					for _, v305 in v303.AssetTypeIdStrings do
						if p63 == v305 then
							return v300, v302
						end
					end
				end
			end
		end
	end

	return nil, nil
end
function t1.findAvatarEditorCategory(p64, p65) -- line: 1049
	-- upvalues: GetAvatarEditorCategories (copy)
	for v308, v309 in (GetAvatarEditorCategories()) do
		if p64 == v309.SearchUuid then
			for v310, v311 in v309.Subcategories do
				if p65 == v311.SearchUuid then
					return v308, v310
				end
			end
		end
	end

	return nil, nil
end
function t1.selectAssetTypeKey(p66) -- line: 1063
	-- upvalues: FFlagAXEditorSubcategoryFilters (copy), Utils (copy), t1 (copy)
	local category = p66.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p66.AvatarExperience.AvatarEditor.Categories.subcategory
	local subButton = p66.AvatarExperience.AvatarEditor.Categories.subButton
	local v316 = if not FFlagAXEditorSubcategoryFilters then nil else p66.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	local v317 = Utils.getAvatarEditorCategoryInfo(category, subcategory)
	local v318, _ = t1.getSearchUuidAndAssetTypes(v317, subButton, if not FFlagAXEditorSubcategoryFilters then nil else v316)

	return v318 or v317.Name
end

t1.getColor3SharedByBodyParts = memoize(function(t27: {[any]: any}, p67) -- line: 1087
	local v322 = nil

	for _, v324 in t27 do
		local v325 = p67[v324]

		if v322 ~= nil then
			if not v325 or v322:ToHex() == v325:ToHex() then
				continue
			end

			return nil
		end

		v322 = v325
	end

	return v322
end)
t1.getRangeIdSharedByBodyParts = memoize(function(t28: {[any]: any}, p68) -- line: 1114
	local v328 = nil

	for _, v330 in t28 do
		local v331 = p68[v330]

		if v328 ~= nil then
			if v328 == v331 then
				continue
			end

			return nil
		end

		v328 = v331
	end

	return v328
end)

function t1.ExponentialRepeat(p69: ((...any) -> ...any), p70: ((...any) -> ...any), n10: number?) -- line: 1144
	local v335 = n10 or 6
	local n11 = 1

	while n11 <= v335 and p69() do
		if p70() then
			return
		end

		task.wait(n11 ^ 2)
		n11 += 1
	end
end

if FFlagAXCustomizeMakeupSupport then
	function t1.isWearingOutfitNoState(p71, p72, p73, p74, p75, _, _: boolean?) -- line: 1183
		-- upvalues: Constants2 (copy), t1 (copy), Dash (copy), isMakeupAssetType (copy), Cryo (copy), isLayeredClothingAssetType (copy), FFlagAXFixOutfitEquipCheckEmptyArray (copy)
		if p71.outfitType == Constants2.OutfitTypes.DynamicHead then
			return t1.isWearingDynamicHeadOutfit(p71, p74)
		end

		local v344 = t1.removeEmoteAnimationAsset(p71.assets)
		local v345 = p71.outfitType == Constants2.OutfitTypes.Avatar and p71.isEditable or t1.isFullyQualifiedOutfit(p71.assets)

		if v345 then
			for v346, v347 in p75 do
				if v347 ~= p71.scales[v346] then
					return false
				end
			end

			if p72 ~= p71.avatarType then
				return false
			end

			if not t1.isPresetOutfit(p71) then
				for v348, v349 in p73 do
					if not p71.bodyColor3s then
						return false
					end

					if p71.bodyColor3s[v348]:ToHex() ~= v349:ToHex() then
						return false
					end
				end
			end
		end

		local t29 = {}
		local t30 = {}

		for v352, v353 in v344 do
			if not p74[v352] then
				return false
			end

			for v354, v355 in v353 do
				if not p74[v352][v354] or not t1.isSameAssetMetadata(Dash.omit(v355, {
					"order",
					"availabilityStatus"
				}), Dash.omit(p74[v352][v354], {
					"order",
					"availabilityStatus"
				})) then
					return false
				end

				if isMakeupAssetType(v352) then
					if v355.order ~= nil then
						table.insert(t30, Cryo.Dictionary.join(v355, {
							assetId = v354,
							assetTypeId = v352
						}))
					end
				elseif isLayeredClothingAssetType(v352) and v355.order ~= nil then
					table.insert(t29, Cryo.Dictionary.join(v355, {
						assetId = v354,
						assetTypeId = v352
					}))
				end
			end
		end

		local t31 = {
			[Constants2.AssetTypeIdStrings.EyebrowAccessory] = true,
			[Constants2.AssetTypeIdStrings.EyelashAccessory] = true,
			[Constants2.AssetTypeIdStrings.FaceMakeup] = true,
			[Constants2.AssetTypeIdStrings.EyeMakeup] = true,
			[Constants2.AssetTypeIdStrings.LipMakeup] = true
		}

		if v345 or p71.outfitType == Constants2.OutfitTypes.Makeup then
			for v357, v358 in p74 do
				if FFlagAXFixOutfitEquipCheckEmptyArray and next(v358) == nil or p71.outfitType == Constants2.OutfitTypes.Makeup and not t31[v357] then
					continue
				end

				if v344[v357] == nil then
					return false
				end

				for v359, _ in v358 do
					if v344[v357][v359] == nil then
						return false
					end
				end
			end
		end

		local function sortByOrder(p77, p78) -- line: 1307
			return p77.order < p78.order
		end

		table.sort(t29, sortByOrder)
		table.sort(t30, sortByOrder)

		local order = nil

		for _, v364 in t29 do
			if order ~= nil then
				if order > p74[v364.assetTypeId][v364.assetId].order then
					return false
				end

				order = p74[v364.assetTypeId][v364.assetId].order

				continue
			end

			order = p74[v364.assetTypeId][v364.assetId].order
		end

		local order2 = nil

		for _, v367 in t30 do
			if order2 ~= nil then
				if order2 > p74[v367.assetTypeId][v367.assetId].order then
					return false
				end

				order2 = p74[v367.assetTypeId][v367.assetId].order

				continue
			end

			order2 = p74[v367.assetTypeId][v367.assetId].order
		end

		return true
	end
elseif FFlagAXSimplifyOutfitEquipCheck() then
	function t1.isWearingOutfitNoState(p79, _, _, p82, _, p84, b2: boolean?) -- line: 1354
		-- upvalues: t1 (copy), Constants2 (copy), FFlagAXSimplifyOutfitEquipCheck (copy), GetFFlagEnableNewCustomizeBundleEquip (copy)
		local v375 = t1.removeEmoteAnimationAsset(p79.assets)

		if p79.outfitType == Constants2.OutfitTypes.DynamicHead then
			return t1.isWearingDynamicHeadOutfit(p79, p82)
		end

		local v376 = t1.getEquippedAssetIds(v375)
		local v377 = t1.getEquippedAssetIds(p82)

		if FFlagAXSimplifyOutfitEquipCheck() or #v376 ~= #v377 then
			for _, v379 in v376 do
				if not t1.Contains(v377, v379) then
					return false
				end
			end

			if b2 then
				for _, v381 in v377 do
					if not t1.Contains(v376, v381) then
						return false
					end
				end
			end

			if GetFFlagEnableNewCustomizeBundleEquip() and p84 and t1.isFullyQualifiedOutfit(v375) then
				return true
			end
		end

		return true
	end
else
	function t1.isWearingOutfitNoState(p85, p86, p87, p88, p89, p90, _: boolean?) -- line: 1412
		-- upvalues: t1 (copy), Constants2 (copy), GetFFlagEnableNewCustomizeBundleEquip (copy)
		local v389 = t1.removeEmoteAnimationAsset(p85.assets)

		if p85.outfitType == Constants2.OutfitTypes.DynamicHead then
			return t1.isWearingDynamicHeadOutfit(p85, p88)
		end

		local v390 = t1.getEquippedAssetIds(v389)
		local v391 = t1.getEquippedAssetIds(p88)

		if #v390 ~= #v391 then
			if GetFFlagEnableNewCustomizeBundleEquip() and p90 and not t1.isFullyQualifiedOutfit(v389) then
				for _, v393 in v390 do
					if not table.find(v391, v393) then
						return false
					end
				end

				return true
			end

			return false
		end

		for _, v395 in v390 do
			local v396 = false

			for _, v398 in v391 do
				if v395 == v398 then
					local v399 = t1.getAssetMetadata(v395, v389)
					local v400 = t1.getAssetMetadata(v398, p88)

					if t1.isSameAssetMetadata(v399, v400) then
						v396 = true
					end
				end
			end

			if not v396 then
				return false
			end
		end

		if not t1.isPresetOutfit(p85) then
			for v401, v402 in p87 do
				if not p85.bodyColor3s then
					return false
				end

				if p85.bodyColor3s[v401]:ToHex() ~= v402:ToHex() then
					return false
				end
			end
		end

		for v403, v404 in p89 do
			if v404 ~= p85.scales[v403] then
				return false
			end
		end

		if p86 ~= p85.avatarType then
			return false
		end

		return true
	end
end

function t1.isWearingOutfit(p91, p92) -- line: 1491
	-- upvalues: t1 (copy)
	local AvatarType = p91.AvatarExperience.AvatarEditor.Character.AvatarType
	local BodyColor3s = p91.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local EquippedAssets = p91.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p91.AvatarExperience.AvatarEditor.Character.AvatarScales

	return t1.isWearingOutfitNoState(p92, AvatarType, BodyColor3s, EquippedAssets, AvatarScales)
end
function t1.getIdOfOutfitBeingWorn(t32: {[any]: any}, p93, p94) -- line: 1504
	-- upvalues: t1 (copy), FFlagAXSimplifyOutfitEquipCheck (copy), FFlagAXCustomizeMakeupSupport (copy)
	local AvatarType = p94.AvatarType
	local BodyColor3s = p94.BodyColor3s
	local EquippedAssets = p94.EquippedAssets
	local AvatarScales = p94.AvatarScales

	for _, v419 in t32 do
		local v420 = p93[tostring(v419)]

		if v420 and t1.isWearingOutfitNoState(v420, AvatarType, BodyColor3s, EquippedAssets, AvatarScales, FFlagAXSimplifyOutfitEquipCheck() and true or (not not FFlagAXCustomizeMakeupSupport or nil), FFlagAXSimplifyOutfitEquipCheck() and true or (not not FFlagAXCustomizeMakeupSupport or nil)) then
			return v419
		end
	end

	return nil
end
function t1.filterOutfitAssetsWithStatus(p95, p96) -- line: 1535
	-- upvalues: Cryo (copy)
	local t33 = {}

	if p95.assets then
		for v424, v425 in p95.assets do
			if v425 then
				t33[v424] = {}

				for v426, v427 in v425 do
					if typeof(p96) == "table" then
						if not table.find(p96, v427.availabilityStatus) then
							t33[v424][v426] = v427
						end
					elseif v427 and p96 ~= v427.availabilityStatus then
						t33[v424][v426] = v427
					end
				end
			end

			if next(t33[v424]) == nil then
				t33[v424] = nil
			end
		end
	end

	return Cryo.Dictionary.join(p95, {
		assets = t33
	})
end
function t1.hasMakeup(p97) -- line: 1570
	-- upvalues: isMakeupAssetType (copy)
	if not p97 then
		return false
	end

	for v429, _ in p97 do
		if isMakeupAssetType(v429) then
			return true
		end
	end

	return false
end
function t1.getOutfitSubtypeKey(p98, b4: boolean?) -- line: 1582
	-- upvalues: FFlagAXOutfitPageRevamp (copy), Constants2 (copy), Constants (copy)
	if not FFlagAXOutfitPageRevamp then
		return ""
	end

	return ({
		[Constants2.OutfitTypes.Avatar] = if not b4 then Constants.PurchasedCharacterKey else Constants.EditableCharacterKey,
		[Constants2.OutfitTypes.Makeup] = Constants.MakeupOutfitKey
	})[p98] or Constants.EditableCharacterKey
end

return t1
