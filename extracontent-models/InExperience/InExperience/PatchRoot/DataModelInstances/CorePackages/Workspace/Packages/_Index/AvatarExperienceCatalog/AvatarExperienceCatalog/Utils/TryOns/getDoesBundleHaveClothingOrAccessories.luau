local set = {
	[tostring(Enum.AssetType.Torso.Value)] = true,
	[tostring(Enum.AssetType.RightArm.Value)] = true,
	[tostring(Enum.AssetType.LeftArm.Value)] = true,
	[tostring(Enum.AssetType.LeftLeg.Value)] = true,
	[tostring(Enum.AssetType.RightLeg.Value)] = true,
	[tostring(Enum.AssetType.Head.Value)] = true,
	[tostring(Enum.AssetType.MoodAnimation.Value)] = true,
	[tostring(Enum.AssetType.DynamicHead.Value)] = true
}

local function getDoesBundleHaveClothingOrAccessories(data): boolean
	if
		not data
		or data.itemType ~= Enum.AvatarItemType.Bundle.Name
		or data.bundleType and tostring(data.bundleType) ~= tostring(Enum.BundleType.BodyParts.Value)
	then
		return false
	end

	for _, item in data.items do
		if
			item.type == Enum.AvatarItemType.Asset.Name
			and item.type == Enum.AvatarItemType.Asset.Name
			and item.assetType
			and not set[item.assetType]
		then
			return true
		end
	end

	return false
end

return getDoesBundleHaveClothingOrAccessories
