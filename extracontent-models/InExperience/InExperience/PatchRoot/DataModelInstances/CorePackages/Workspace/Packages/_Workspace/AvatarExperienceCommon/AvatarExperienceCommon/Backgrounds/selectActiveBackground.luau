local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local AvatarBackground = require(AvatarExperienceCommon.Constants).ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground
local NO_BACKGROUND_ASSET_ID = require(script.Parent.constants).NO_BACKGROUND_ASSET_ID

local function scanTryOnForBackground(t1: {[any]: any}?) -- line: 32
	-- upvalues: AvatarBackground (copy)
	if not t1 then
		return nil
	end

	for _, v11 in t1 do
		if v11.isUnequipped or v11.itemType ~= "Asset" or v11.itemSubType ~= AvatarBackground then
			continue
		end

		local num = tonumber(v11.itemId)

		if num then
			return num
		end
	end

	return nil
end
local function firstEquippedBackgroundId(t2: {[any]: any}?) -- line: 50
	-- upvalues: AvatarBackground (copy)
	if not t2 then
		return nil
	end

	local v14 = t2[AvatarBackground]

	if not v14 then
		return nil
	end

	for v15 in v14 do
		local num = tonumber(v15)

		if num then
			return num
		end
	end

	return nil
end
local function selectActiveBackground(p1) -- line: 67
	-- upvalues: AvatarBackground (copy), AvatarExperienceFlags (copy), scanTryOnForBackground (copy), NO_BACKGROUND_ASSET_ID (copy)
	if not AvatarBackground then
		return nil
	end

	local v18 = p1 and (p1.AvatarExperience or p1)

	if AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration then
		local v19 = v18 and (v18.AvatarScene and v18.AvatarScene.OutfitTryOn)
		local v20 = scanTryOnForBackground(v19 and v19.TryOnItems)

		if v20 then
			return v20
		end
	end

	local v21 = v18 and (v18.AvatarScene and v18.AvatarScene.ProfileConfiguration)

	if v21 and v21.BackgroundAssetId ~= nil then
		local BackgroundAssetId = v21.BackgroundAssetId

		if BackgroundAssetId ~= NO_BACKGROUND_ASSET_ID then
			return BackgroundAssetId
		end

		return nil
	end

	local v23 = v18 and (v18.AvatarEditor and v18.AvatarEditor.Character)
	local v24 = v23 and v23.EquippedAssets

	if not v24 then
		return nil
	end

	local v25 = v24[AvatarBackground]

	if not v25 then
		return nil
	end

	for v26 in v25 do
		local num = tonumber(v26)

		if num then
			return num
		end
	end

	return nil
end

return selectActiveBackground
