local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local Constants = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local Constants2 = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_TO_ACCESSORY_TYPE = Constants2.ASSET_TYPE_TO_ACCESSORY_TYPE

local Constants3 = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = Constants3.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local Constants4 = require(AvatarExperienceCommon.Constants)
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = Constants4.HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require(script.Parent.setHumanoidDescriptionColorsFromBodyColor3s)
local createHumanoidDescriptionAccessoryInfo = require(script.Parent.createHumanoidDescriptionAccessoryInfo)
local setMakeupDescriptions = require(script.Parent.setMakeupDescriptions)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local getHumanoidDescriptionFromStateForOutfitType = require(AvatarExperienceCommon.Utils.Humanoid.getHumanoidDescriptionFromStateForOutfitType)

return function(p)
	local values

	if FFlagAXOutfitPageRevamp then
		values = getHumanoidDescriptionFromStateForOutfitType(p, nil)
	else
		values = Instance.new("HumanoidDescription")
		local equippedAssets = p.AvatarEditor.Character.EquippedAssets
		local avatarScales = p.AvatarEditor.Character.AvatarScales

		if equippedAssets then
			local v = {}

			for k, equippedAsset in equippedAssets do
				local v2 = ASSET_TYPE_TO_ACCESSORY_TYPE[k]
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

				local v4 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[k]
				local joined = table.concat(v3, ",")

				if v4 then
					values[v4] = joined
				elseif k ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear and not isMakeupAssetType(k) then
					mutedError(string.format(
						"assetTypeId: %s not recognized as member of humanoidDescription",
						(tostring(k))
					))
				end
			end

			values:SetAccessories(v, true)
			setMakeupDescriptions(values, equippedAssets)
		end

		if avatarScales then
			for k, avatarScale in avatarScales do
				values[HUMANOID_DESCRIPTION_SCALE_TO_NAME[k]] = avatarScale
			end
		end

		setHumanoidDescriptionColorsFromBodyColor3s(values, p.AvatarEditor.Character.BodyColor3s)
	end

	local v = {}
	local v2 = {}

	for _, v3 in p.AvatarEditor.EquippedEmotes.slotInfo do
		v[tostring(v3.assetId)] = { (tonumber(v3.assetId)) }
		table.insert(v2, { Slot = v3.position, Name = tostring(v3.assetId) })
	end

	values:SetEmotes(v)
	values:SetEquippedEmotes(v2)

	return values
end
