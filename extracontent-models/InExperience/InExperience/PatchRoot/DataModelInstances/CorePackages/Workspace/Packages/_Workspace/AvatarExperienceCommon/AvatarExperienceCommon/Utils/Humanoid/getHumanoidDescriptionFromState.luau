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
local FFlagAXMakeupEquipping = require(AvatarExperienceCommonParent.AvatarExperienceFlags).FFlagAXMakeupEquipping

return function(p1) -- line: 18
	-- upvalues: ASSET_TYPE_TO_ACCESSORY_TYPE (copy), createHumanoidDescriptionAccessoryInfo (copy), ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy), HUMANOID_DESCRIPTION_SCALE_TO_NAME (copy), setHumanoidDescriptionColorsFromBodyColor3s (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")
	local EquippedAssets = p1.AvatarEditor.Character.EquippedAssets
	local AvatarScales = p1.AvatarEditor.Character.AvatarScales

	if EquippedAssets then
		local t1 = {}

		for v18, v19 in EquippedAssets do
			local t2 = {}
			local v21 = ASSET_TYPE_TO_ACCESSORY_TYPE[v18]

			for v22, v23 in v19 do
				if v21 then
					table.insert(t1, createHumanoidDescriptionAccessoryInfo(v18, v22, v23))
				else
					table.insert(t2, v22)
				end
			end

			if v21 == nil and #t2 > 0 then
				local v24 = ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[v18]
				local v25 = table.concat(t2, ",")

				if v24 then
					HumanoidDescription[v24] = v25
				elseif v18 ~= ASSET_TYPE_NAME_TO_ID_STRING.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v18)) then
					mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v18))))
				end
			end
		end

		HumanoidDescription:SetAccessories(t1, true)

		if FFlagAXMakeupEquipping then
			setMakeupDescriptions(HumanoidDescription, EquippedAssets)
		end
	end

	if AvatarScales then
		for v26, v27 in AvatarScales do
			HumanoidDescription[HUMANOID_DESCRIPTION_SCALE_TO_NAME[v26]] = v27
		end
	end

	setHumanoidDescriptionColorsFromBodyColor3s(HumanoidDescription, p1.AvatarEditor.Character.BodyColor3s)

	local t3 = {}
	local t4 = {}

	for _, v31 in p1.AvatarEditor.EquippedEmotes.slotInfo do
		t3[tostring(v31.assetId)] = { (tonumber(v31.assetId)) }
		table.insert(t4, {
			Slot = v31.position,
			Name = tostring(v31.assetId)
		})
	end

	HumanoidDescription:SetEmotes(t3)
	HumanoidDescription:SetEquippedEmotes(t4)

	return HumanoidDescription
end
