local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Loggers").mutedError
local ASSET_TYPE_NAME_TO_ID_STRING = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING
local ASSET_TYPE_TO_ACCESSORY_TYPE = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_TO_ACCESSORY_TYPE

local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setHumanoidDescriptionColorsFromBodyColor3s")
local createHumanoidDescriptionAccessoryInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/createHumanoidDescriptionAccessoryInfo")
local setMakeupDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setMakeupDescriptions")
local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")

local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXOutfitPageRevamp

local getHumanoidDescriptionFromStateForOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/getHumanoidDescriptionFromStateForOutfitType")

return function(p2)
	local values

	if fFlagAXOutfitPageRevamp then
		values = getHumanoidDescriptionFromStateForOutfitType(p2, nil)
	else
		values = Instance.new("HumanoidDescription")
		local equippedAssets = p2.AvatarEditor.Character.EquippedAssets
		local avatarScales = p2.AvatarEditor.Character.AvatarScales

		if equippedAssets then
			local v5 = {}

			for k, equippedAsset in equippedAssets do
				local v6 = ASSET_TYPE_TO_ACCESSORY_TYPE[k]
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

				local v8 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[k]
				local joined = table.concat(v7, ",")

				if v8 then
					values[v8] = joined
				elseif k ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear and not isMakeupAssetType(k) then
					mutedError(string.format(
						"assetTypeId: %s not recognized as member of humanoidDescription",
						(tostring(k))
					))
				end
			end

			values:SetAccessories(v5, true)
			setMakeupDescriptions(values, equippedAssets)
		end

		if avatarScales then
			for k, avatarScale in avatarScales do
				values[HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = avatarScale
			end
		end

		setHumanoidDescriptionColorsFromBodyColor3s(values, p2.AvatarEditor.Character.BodyColor3s)
	end

	local v5 = {}
	local v6 = {}

	for k, v7 in p2.AvatarEditor.EquippedEmotes.slotInfo do
		v5[tostring(v7.assetId)] = { (tonumber(v7.assetId)) }
		table.insert(v6, { Slot = v7.position, Name = tostring(v7.assetId) })
	end

	values:SetEmotes(v5)
	values:SetEquippedEmotes(v6)

	return values
end
