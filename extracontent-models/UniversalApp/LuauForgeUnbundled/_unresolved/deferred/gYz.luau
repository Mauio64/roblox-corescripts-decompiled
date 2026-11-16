local tryOnLooksOutfit = require("@luauforge/bundled/dHL").Actions.TryOnLooksOutfit
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXTryOnWithoutEquippedBody = AvatarExperienceFlags.FFlagAXTryOnWithoutEquippedBody

local fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments = AvatarExperienceFlags.FFlagAXPhotoboothMomentsTryOnAccessoryAdjustments

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fvh")

local function toTryOnAssets(items)
	local tryOnAssets = {}

	for k, item in items do
		for k2, v5 in item do
			local v6 = {
				itemType = "Asset",
				itemSubType = k,
				itemId = k2,
				order = v5.order,
				tryOnItemOrder = #tryOnAssets + 1,
				headShape = 0,
				staticFacialAnimation = 0,
				position = 0,
				rotation = 0,
				scale = 0
			}
			local v7 = if fFlagAXTryOnWithoutEquippedBody then v5.headShape else nil
			v6.headShape = v7
			local v8 = if fFlagAXTryOnWithoutEquippedBody then v5.staticFacialAnimation else nil
			v6.staticFacialAnimation = v8
			local v9 = if fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments then v5.position else nil
			v6.position = v9
			local v10 = if fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments then v5.rotation else nil
			v6.rotation = v10
			local v11 = if fFlagAXPhotoboothMomentsTryOnAccessoryAdjustments then v5.scale else nil
			v6.scale = v11
			table.insert(tryOnAssets, v6)
		end
	end

	return tryOnAssets
end

return function(p2)
	return function(object): boolean
		local outfitInfo = object:getState().AvatarExperience.AvatarEditor.OutfitInfos[p2]

		if outfitInfo and outfitInfo.assets then
			object:dispatch(tryOnLooksOutfit({
				assetItemIdTypeAndSubtype = toTryOnAssets(module3.removeEmoteAnimationAsset(outfitInfo.assets)),
				outfitId = p2,
				lookType = module2.LookType.Avatar,
				bodyColor3s = outfitInfo.bodyColor3s,
				scale = outfitInfo.scales,
				avatarType = outfitInfo.avatarType,
				shouldTryOnWithoutEquippedBody = fFlagAXTryOnWithoutEquippedBody and true or nil
			}))

			return true
		end

		return false
	end
end
