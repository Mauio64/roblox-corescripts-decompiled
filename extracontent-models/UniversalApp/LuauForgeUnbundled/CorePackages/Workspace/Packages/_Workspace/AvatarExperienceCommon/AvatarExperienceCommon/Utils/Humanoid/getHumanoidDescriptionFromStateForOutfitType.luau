local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Loggers").mutedError
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setHumanoidDescriptionColorsFromBodyColor3s")
local setMakeupDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setMakeupDescriptions")
local createHumanoidDescriptionAccessoryInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/createHumanoidDescriptionAccessoryInfo")
local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")
local isValidAssetTypeForOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isValidAssetTypeForOutfitType")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")

return function(p2, p3)
	local humanoidDescription = Instance.new("HumanoidDescription")
	local equippedAssets = p2.AvatarEditor.Character.EquippedAssets
	local avatarScales = p2.AvatarEditor.Character.AvatarScales

	local staticFacialAnimation = nil

	if equippedAssets then
		local v5 = {}

		for k, equippedAsset in equippedAssets do
			if not isValidAssetTypeForOutfitType(k, p3) then
				continue
			end

			local v6 = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[k]
			local v7 = {}

			for k2, v8 in equippedAsset do
				if v6 then
					table.insert(v5, createHumanoidDescriptionAccessoryInfo(k, k2, v8))
				else
					table.insert(v7, k2)
				end
			end

			if not (v6 == nil and #v7 > 0) then
				continue
			end

			local v8 = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[k]
			local joined = table.concat(v7, ",")

			if v8 then
				if fFlagParseHeadShapeFromAPIResponse and Constants.BODY_PART_NAME_TO_ENUM[v8] then
					local bodyPartDescription = Instance.new("BodyPartDescription")
					bodyPartDescription.AssetId = v7[1]
					bodyPartDescription.Parent = humanoidDescription
					bodyPartDescription.BodyPart = Constants.BODY_PART_NAME_TO_ENUM[v8]

					if k == Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead then
						local headShape = nil

						for k2, v10 in v7 do
							local v11 = equippedAsset[v10]

							if
								fFlagHeadRefinementFacialAnimationToggle
								and v11
								and v11.staticFacialAnimation ~= nil
							then
								staticFacialAnimation = v11.staticFacialAnimation
							end

							if v11 and v11.headShape then
								headShape = if v11.headShape ~= "Default" then v11.headShape else nil
								break
							end
						end

						if headShape then
							bodyPartDescription.HeadShape = headShape
						end
					end
				else
					humanoidDescription[v8] = joined
				end
			elseif k ~= Constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear and not isMakeupAssetType(k) then
				mutedError(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v5, true)
		setMakeupDescriptions(humanoidDescription, equippedAssets)

		if fFlagHeadRefinementFacialAnimationToggle and staticFacialAnimation ~= nil then
			humanoidDescription[Constants.STATIC_FACIAL_ANIMATION] = staticFacialAnimation
		end
	end

	if avatarScales then
		for k, avatarScale in avatarScales do
			humanoidDescription[HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = avatarScale
		end
	end

	setHumanoidDescriptionColorsFromBodyColor3s(humanoidDescription, p2.AvatarEditor.Character.BodyColor3s)

	return humanoidDescription
end
