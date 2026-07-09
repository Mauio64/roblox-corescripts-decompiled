local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local mutedError = require(AvatarExperienceCommonParent.Loggers).mutedError
local Constants = require(AvatarExperienceCommon.Constants)
local createHumanoidDescriptionAccessoryInfo = require(AvatarExperienceCommon.Utils.Humanoid.createHumanoidDescriptionAccessoryInfo)
local setMakeupDescriptions = require(AvatarExperienceCommon.Utils.Humanoid.setMakeupDescriptions)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local FFlagAXMakeupEquipping = require(AvatarExperienceCommonParent.AvatarExperienceFlags).FFlagAXMakeupEquipping

local function applyCurrentAssets(p1, t1: {[any]: any}?) -- line: 24
	-- upvalues: Constants (copy), createHumanoidDescriptionAccessoryInfo (copy), FFlagAXMakeupEquipping (copy), isMakeupAssetType (copy), mutedError (copy), setMakeupDescriptions (copy)
	if t1 then
		local t2 = {}

		for v17, v18 in t1 do
			local t3 = {}
			local v20 = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[v17]

			for v21, v22 in v18 do
				if v20 then
					table.insert(t2, createHumanoidDescriptionAccessoryInfo(v17, v21, v22))
				else
					table.insert(t3, v21)
				end
			end

			if v20 == nil and #t3 > 0 then
				local v23 = Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP[v17]
				local v24 = table.concat(t3, ",")

				if v23 then
					p1[v23] = v24
				elseif v17 ~= Constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear and (not FFlagAXMakeupEquipping or not isMakeupAssetType(v17)) then
					mutedError(string.format("assetTypeId: %s not recognized as member of humanoidDescription", (tostring(v17))))
				end
			end
		end

		p1:SetAccessories(t2, true)

		if FFlagAXMakeupEquipping then
			setMakeupDescriptions(p1, t1)
		end
	end
end
local function applyAvatarScales(p2, t4: {[any]: any}?) -- line: 66
	-- upvalues: Constants (copy)
	if t4 then
		for v27, v28 in t4 do
			p2[Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME[v27]] = v28
		end
	end
end
local function applyBodyColor3s(p3, t5: {[any]: any}?) -- line: 76
	-- upvalues: Constants (copy)
	if t5 then
		for v31, v32 in t5 do
			p3[Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[v31]] = v32
		end
	end
end
local function applyEmotes(p4, t6: {[any]: any}?) -- line: 87
	if t6 then
		local t7 = {}
		local t8 = {}

		for _, v38 in t6 do
			t7[tostring(v38.assetId)] = { (tonumber(v38.assetId)) }
			table.insert(t8, {
				Slot = v38.position,
				Name = tostring(v38.assetId)
			})
		end

		p4:SetEmotes(t7)
		p4:SetEquippedEmotes(t8)
	end
end
local function buildHumanoidDescription(t9: {[any]: any}) -- line: 108
	-- upvalues: applyCurrentAssets (copy), Constants (copy), applyEmotes (copy)
	local HumanoidDescription = Instance.new("HumanoidDescription")

	applyCurrentAssets(HumanoidDescription, t9.currentAssets)

	local avatarScales = t9.avatarScales

	if avatarScales then
		for v42, v43 in avatarScales do
			HumanoidDescription[Constants.HUMANOID_DESCRIPTION_SCALE_TO_NAME[v42]] = v43
		end
	end

	local bodyColor3s = t9.bodyColor3s

	if bodyColor3s then
		for v45, v46 in bodyColor3s do
			HumanoidDescription[Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[v45]] = v46
		end
	end

	applyEmotes(HumanoidDescription, t9.emotesSlotInfo)

	return HumanoidDescription
end

return buildHumanoidDescription
