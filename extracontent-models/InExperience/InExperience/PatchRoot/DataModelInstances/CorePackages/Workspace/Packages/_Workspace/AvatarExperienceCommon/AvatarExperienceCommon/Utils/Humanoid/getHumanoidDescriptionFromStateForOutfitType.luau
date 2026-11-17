local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local Constants = require(AvatarExperienceCommon.Constants)
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require(script.Parent.setHumanoidDescriptionColorsFromBodyColor3s)
local setMakeupDescriptions = require(script.Parent.setMakeupDescriptions)
local createHumanoidDescriptionAccessoryInfo = require(script.Parent.createHumanoidDescriptionAccessoryInfo)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local isSpawnEffectAssetType = require(AvatarExperienceCommon.Utils.isSpawnEffectAssetType)
local isValidAssetTypeForOutfitType = require(AvatarExperienceCommon.Utils.isValidAssetTypeForOutfitType)

local Constants2 = require(AvatarExperienceCommon.Constants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXSpawnEffectSaveRoundTrip = AvatarExperienceFlags.FFlagAXSpawnEffectSaveRoundTrip

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)

return function(p, p2)
	local humanoidDescription = Instance.new("HumanoidDescription")
	local equippedAssets = p.AvatarEditor.Character.EquippedAssets
	local avatarScales = p.AvatarEditor.Character.AvatarScales

	local staticFacialAnimation = nil

	if equippedAssets then
		local v = {}

		for k, equippedAsset in equippedAssets do
			if not isValidAssetTypeForOutfitType(k, p2) then
				continue
			end

			local v2 = Constants2.ASSET_TYPE_TO_ACCESSORY_TYPE[k]
			local v3 = {}

			for k2, v4 in equippedAsset do
				if v2 then
					table.insert(v, createHumanoidDescriptionAccessoryInfo(k, k2, v4))
				else
					table.insert(v3, k2)
				end
			end

			if not (v2 == nil and #v3 > 0) then
				continue
			end

			local v4 = Constants2.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[k]
			local joined = table.concat(v3, ",")

			if v4 then
				if FFlagParseHeadShapeFromAPIResponse and Constants2.BODY_PART_NAME_TO_ENUM[v4] then
					local bodyPartDescription = Instance.new("BodyPartDescription")
					bodyPartDescription.AssetId = v3[1]
					bodyPartDescription.Parent = humanoidDescription
					bodyPartDescription.BodyPart = Constants2.BODY_PART_NAME_TO_ENUM[v4]

					if k == Constants2.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead then
						local headShape = nil

						for _, v5 in v3 do
							local v6 = equippedAsset[v5]

							if FFlagHeadRefinementFacialAnimationToggle and v6 and v6.staticFacialAnimation ~= nil then
								staticFacialAnimation = v6.staticFacialAnimation
							end

							if v6 and v6.headShape then
								if v6.headShape == "Default" then
									headShape = nil
								else
									headShape = v6.headShape
								end

								break
							end
						end

						if headShape then
							bodyPartDescription.HeadShape = headShape
						end
					end
				else
					humanoidDescription[v4] = joined
				end
			elseif
				k ~= Constants2.ASSET_TYPE_NAME_TO_ID_STRING.Gear
				and not (isMakeupAssetType(k) or FFlagAXSpawnEffectSaveRoundTrip and isSpawnEffectAssetType(k))
			then
				mutedError(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v, true)
		setMakeupDescriptions(humanoidDescription, equippedAssets)

		if FFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
			humanoidDescription[Constants2.STATIC_FACIAL_ANIMATION] = staticFacialAnimation
		end
	end

	if avatarScales then
		for k, avatarScale in avatarScales do
			humanoidDescription[HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = avatarScale
		end
	end

	setHumanoidDescriptionColorsFromBodyColor3s(humanoidDescription, p.AvatarEditor.Character.BodyColor3s)

	return humanoidDescription
end
