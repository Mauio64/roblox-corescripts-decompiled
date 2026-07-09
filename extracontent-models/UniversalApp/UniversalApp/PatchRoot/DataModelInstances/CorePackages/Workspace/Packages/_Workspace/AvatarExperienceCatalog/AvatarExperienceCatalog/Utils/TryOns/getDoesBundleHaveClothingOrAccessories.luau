local t1 = {
	[tostring(Enum.AssetType.Torso.Value)] = true,
	[tostring(Enum.AssetType.RightArm.Value)] = true,
	[tostring(Enum.AssetType.LeftArm.Value)] = true,
	[tostring(Enum.AssetType.LeftLeg.Value)] = true,
	[tostring(Enum.AssetType.RightLeg.Value)] = true,
	[tostring(Enum.AssetType.Head.Value)] = true,
	[tostring(Enum.AssetType.MoodAnimation.Value)] = true,
	[tostring(Enum.AssetType.DynamicHead.Value)] = true
}

local function getDoesBundleHaveClothingOrAccessories(t2: {[any]: any}?) -- line: 21
	-- upvalues: t1 (copy)
	if t2 then
		if t2.itemType ~= Enum.AvatarItemType.Bundle.Name then
			return false
		end

		if t2.bundleType and tostring(t2.bundleType) ~= tostring(Enum.BundleType.BodyParts.Value) then
			return false
		end

		for _, v5 in t2.items do
			if v5.type == Enum.AvatarItemType.Asset.Name and v5.type == Enum.AvatarItemType.Asset.Name and v5.assetType and not t1[v5.assetType] then
				return true
			end
		end
	end

	return false
end

return getDoesBundleHaveClothingOrAccessories
