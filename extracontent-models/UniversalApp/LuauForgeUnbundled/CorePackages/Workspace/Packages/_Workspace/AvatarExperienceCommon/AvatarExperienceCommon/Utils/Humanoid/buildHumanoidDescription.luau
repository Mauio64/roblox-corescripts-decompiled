local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Loggers").mutedError

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")
local fFlagAXSpawnEffectSaveRoundTrip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXSpawnEffectSaveRoundTrip

local createHumanoidDescriptionAccessoryInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/createHumanoidDescriptionAccessoryInfo")
local setAvatarEffectDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setAvatarEffectDescriptions")
local setMakeupDescriptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/Humanoid/setMakeupDescriptions")
local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")
local isSpawnEffectAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isSpawnEffectAssetType")

local function applyCurrentAssets(humanoidDescription, currentAssets)
	if currentAssets then
		local v5 = {}

		for k, item in currentAssets do
			local v6 = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[k]
			local v7 = {}

			for k2, v8 in item do
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
				humanoidDescription[v8] = joined
			elseif
				k ~= Constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear
				and not (isMakeupAssetType(k) or fFlagAXSpawnEffectSaveRoundTrip and isSpawnEffectAssetType(k))
			then
				mutedError(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v5, true)
		setMakeupDescriptions(humanoidDescription, currentAssets)

		if fFlagAXSpawnEffectSaveRoundTrip then
			setAvatarEffectDescriptions(humanoidDescription, currentAssets)
		end
	end
end

local function applyAvatarScales(p2, items)
	if items then
		for k, item in items do
			p2[Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = item
		end
	end
end

local function applyBodyColor3s(p2, items)
	if items then
		for k, item in items do
			p2[Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[k]] = item
		end
	end
end

local function applyEmotes(humanoidDescription, emotesSlotInfo)
	if emotesSlotInfo then
		local v5 = {}
		local v6 = {}

		for k, item in emotesSlotInfo do
			v5[tostring(item.assetId)] = { (tonumber(item.assetId)) }
			table.insert(v6, { Slot = item.position, Name = tostring(item.assetId) })
		end

		humanoidDescription:SetEmotes(v5)
		humanoidDescription:SetEquippedEmotes(v6)
	end
end

local function buildHumanoidDescription(data)
	local humanoidDescription = Instance.new("HumanoidDescription")

	applyCurrentAssets(humanoidDescription, data.currentAssets)
	local avatarScales = data.avatarScales

	if avatarScales then
		for k, avatarScale in avatarScales do
			humanoidDescription[Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = avatarScale
		end
	end

	local bodyColor3s = data.bodyColor3s

	if bodyColor3s then
		for k, bodyColor3 in bodyColor3s do
			humanoidDescription[Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[k]] = bodyColor3
		end
	end

	applyEmotes(humanoidDescription, data.emotesSlotInfo)

	return humanoidDescription
end

return buildHumanoidDescription
