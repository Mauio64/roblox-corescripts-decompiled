local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local mutedError = require(AvatarExperienceCommonParent.Loggers).mutedError
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = require(AvatarExperienceCommon.Constants).HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require(script.Parent.setHumanoidDescriptionColorsFromBodyColor3s)
local setMakeupDescriptions = require(script.Parent.setMakeupDescriptions)
local createHumanoidDescriptionAccessoryInfo = require(script.Parent.createHumanoidDescriptionAccessoryInfo)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local isValidAssetTypeForOutfitType = require(AvatarExperienceCommon.Utils.isValidAssetTypeForOutfitType)
local Constants = require(AvatarExperienceCommon.Constants)
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)

return function(p1, p2) -- line: 22
	-- upvalues: isValidAssetTypeForOutfitType (copy), Constants (copy), createHumanoidDescriptionAccessoryInfo (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy), HUMANOID_DESCRIPTION_SCALE_TO_NAME (copy), setHumanoidDescriptionColorsFromBodyColor3s (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")
	local EquippedAssets = p1.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p1.AvatarEditor.Character.AvatarScales
	local staticFacialAnimation = nil

	if EquippedAssets then
		local t1 = {}

		for v22, v23 in EquippedAssets do
			if isValidAssetTypeForOutfitType(v22, p2) then
				local t2 = {}
				local v25 = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[v22]

				for v26, v27 in v23 do
					if v25 then
						table.insert(t1, createHumanoidDescriptionAccessoryInfo(v22, v26, v27))
					else
						table.insert(t2, v26)
					end
				end

				if v25 == nil and #t2 > 0 then
					local v28 = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[v22]
					local v29 = table.concat(t2, ",")

					if v28 then
						if FFlagParseHeadShapeFromAPIResponse and Constants.BODY_PART_NAME_TO_ENUM[v28] then
							local BodyPartDescription = Instance.new("BodyPartDescription")

							BodyPartDescription.AssetId = t2[1]
							BodyPartDescription.Parent = HumanoidDescription
							BodyPartDescription.BodyPart = Constants.BODY_PART_NAME_TO_ENUM[v28]

							if v22 == Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead then
								local v31 = nil

								for _, v33 in t2 do
									local v34 = v23[v33]

									if FFlagHeadRefinementFacialAnimationToggle and v34 and v34.staticFacialAnimation ~= nil then
										staticFacialAnimation = v34.staticFacialAnimation
									end

									if v34 and v34.headShape then
										v31 = if v34.headShape ~= "Default" then v34.headShape else nil

										break
									end
								end

								if v31 then
									BodyPartDescription.HeadShape = v31
								end
							end
						else
							HumanoidDescription[v28] = v29
						end
					elseif v22 ~= Constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v22)) then
						mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v22))))
					end
				end
			end
		end

		HumanoidDescription:SetAccessories(t1, true)

		if FFlagAXMakeupEquipping then
			setMakeupDescriptions(HumanoidDescription, EquippedAssets)
		end

		if FFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
			HumanoidDescription[Constants.STATIC_FACIAL_ANIMATION] = staticFacialAnimation
		end
	end

	if AvatarScales then
		for v35, v36 in AvatarScales do
			HumanoidDescription[HUMANOID_DESCRIPTION_SCALE_TO_NAME[v35]] = v36
		end
	end

	setHumanoidDescriptionColorsFromBodyColor3s(HumanoidDescription, p1.AvatarEditor.Character.BodyColor3s)

	return HumanoidDescription
end
