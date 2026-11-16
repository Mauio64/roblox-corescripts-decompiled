local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local Constants = require(AvatarExperienceCommon.Constants)

local createHumanoidDescriptionAccessoryInfo = require(AvatarExperienceCommon.Utils.Humanoid.createHumanoidDescriptionAccessoryInfo)
local setMakeupDescriptions = require(AvatarExperienceCommon.Utils.Humanoid.setMakeupDescriptions)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)

local function applyCurrentAssets(humanoidDescription, currentAssets)
	if currentAssets then
		local v = {}

		for k, item in currentAssets do
			local v2 = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[k]
			local v3 = {}

			for k2, v4 in item do
				if v2 then
					table.insert(v, createHumanoidDescriptionAccessoryInfo(k, k2, v4))
				else
					table.insert(v3, k2)
				end
			end

			if not (v2 == nil and #v3 > 0) then
				continue
			end

			local v4 = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[k]
			local joined = table.concat(v3, ",")

			if v4 then
				humanoidDescription[v4] = joined
			elseif k ~= Constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear and not isMakeupAssetType(k) then
				mutedError(string.format(
					"assetTypeId: %s not recognized as member of humanoidDescription",
					(tostring(k))
				))
			end
		end

		humanoidDescription:SetAccessories(v, true)
		setMakeupDescriptions(humanoidDescription, currentAssets)
	end
end

local function applyAvatarScales(humanoidDescription, avatarScales) -- 1 equivalent call inferred from this helper
	if avatarScales then
		for k, item in avatarScales do
			humanoidDescription[Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = item
		end
	end
end

local function applyBodyColor3s(humanoidDescription, bodyColor3s) -- 1 equivalent call inferred from this helper
	if bodyColor3s then
		for k, item in bodyColor3s do
			humanoidDescription[Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[k]] = item
		end
	end
end

local function applyEmotes(humanoidDescription, emotesSlotInfo)
	if emotesSlotInfo then
		local v = {}
		local v2 = {}

		for _, item in emotesSlotInfo do
			v[tostring(item.assetId)] = { (tonumber(item.assetId)) }
			table.insert(v2, { Slot = item.position, Name = tostring(item.assetId) })
		end

		humanoidDescription:SetEmotes(v)
		humanoidDescription:SetEquippedEmotes(v2)
	end
end

local function buildHumanoidDescription(data)
	local humanoidDescription = Instance.new("HumanoidDescription")

	applyCurrentAssets(humanoidDescription, data.currentAssets)
	applyAvatarScales(humanoidDescription, data.avatarScales) -- inferred equivalent call
	applyBodyColor3s(humanoidDescription, data.bodyColor3s) -- inferred equivalent call
	applyEmotes(humanoidDescription, data.emotesSlotInfo)

	return humanoidDescription
end

return buildHumanoidDescription
