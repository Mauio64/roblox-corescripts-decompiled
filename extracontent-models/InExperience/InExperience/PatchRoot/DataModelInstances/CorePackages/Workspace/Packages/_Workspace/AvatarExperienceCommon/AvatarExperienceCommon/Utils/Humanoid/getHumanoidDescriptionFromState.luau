local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local mutedError = require(AvatarExperienceCommonParent.Loggers).mutedError
local ASSET_TYPE_NAME_TO_ID_STRING = require(AvatarExperienceCommon.Constants).ASSET_TYPE_NAME_TO_ID_STRING
local ASSET_TYPE_TO_ACCESSORY_TYPE = require(AvatarExperienceCommon.Constants).ASSET_TYPE_TO_ACCESSORY_TYPE
local ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = require(AvatarExperienceCommon.Constants).ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP
local HUMANOID_DESCRIPTION_SCALE_TO_NAME = require(AvatarExperienceCommon.Constants).HUMANOID_DESCRIPTION_SCALE_TO_NAME
local setHumanoidDescriptionColorsFromBodyColor3s = require(script.Parent.setHumanoidDescriptionColorsFromBodyColor3s)
local createHumanoidDescriptionAccessoryInfo = require(script.Parent.createHumanoidDescriptionAccessoryInfo)
local setMakeupDescriptions = require(script.Parent.setMakeupDescriptions)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local getHumanoidDescriptionFromStateForOutfitType = require(AvatarExperienceCommon.Utils.Humanoid.getHumanoidDescriptionFromStateForOutfitType)

return function(p1) -- line: 22
	-- upvalues: FFlagAXOutfitPageRevamp (copy), getHumanoidDescriptionFromStateForOutfitType (copy), ASSET_TYPE_TO_ACCESSORY_TYPE (copy), createHumanoidDescriptionAccessoryInfo (copy), ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy), HUMANOID_DESCRIPTION_SCALE_TO_NAME (copy), setHumanoidDescriptionColorsFromBodyColor3s (copy)
	local v17

	if FFlagAXOutfitPageRevamp then
		v17 = getHumanoidDescriptionFromStateForOutfitType(p1, nil)
	else
		v17 = Instance.new("HumanoidDescription")

		local EquippedAssets = p1.AvatarEditor.Character.EquippedAssets
		local AvatarScales = p1.AvatarEditor.Character.AvatarScales

		if EquippedAssets then
			local t1 = {}

			for v21, v22 in EquippedAssets do
				local t2 = {}
				local v24 = ASSET_TYPE_TO_ACCESSORY_TYPE[v21]

				for v25, v26 in v22 do
					if v24 then
						table.insert(t1, createHumanoidDescriptionAccessoryInfo(v21, v25, v26))
					else
						table.insert(t2, v25)
					end
				end

				if v24 == nil and #t2 > 0 then
					local v27 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[v21]
					local v28 = table.concat(t2, ",")

					if v27 then
						v17[v27] = v28
					elseif v21 ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v21)) then
						mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v21))))
					end
				end
			end

			v17:SetAccessories(t1, true)

			if FFlagAXMakeupEquipping then
				setMakeupDescriptions(v17, EquippedAssets)
			end
		end

		if AvatarScales then
			for v29, v30 in AvatarScales do
				v17[HUMANOID_DESCRIPTION_SCALE_TO_NAME[v29]] = v30
			end
		end

		setHumanoidDescriptionColorsFromBodyColor3s(v17, p1.AvatarEditor.Character.BodyColor3s)
	end

	local t3 = {}
	local t4 = {}

	for _, v34 in p1.AvatarEditor.EquippedEmotes.slotInfo do
		t3[tostring(v34.assetId)] = { (tonumber(v34.assetId)) }
		table.insert(t4, {
			Slot = v34.position,
			Name = tostring(v34.assetId)
		})
	end

	v17:SetEmotes(t3)
	v17:SetEquippedEmotes(t4)

	return v17
end
