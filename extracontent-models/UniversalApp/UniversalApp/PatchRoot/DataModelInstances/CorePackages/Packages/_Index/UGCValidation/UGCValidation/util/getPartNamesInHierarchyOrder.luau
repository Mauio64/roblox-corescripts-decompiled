local function getPartNamesInHierarchyOrder(p1) -- line: 5
	if p1 == Enum.AssetType.LeftArm then
		return {
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand"
		}
	end

	if p1 == Enum.AssetType.RightArm then
		return {
			"RightUpperArm",
			"RightLowerArm",
			"RightHand"
		}
	end

	if p1 == Enum.AssetType.LeftLeg then
		return {
			"LeftUpperLeg",
			"LeftLowerLeg",
			"LeftFoot"
		}
	end

	if p1 == Enum.AssetType.RightLeg then
		return {
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot"
		}
	end

	if p1 == Enum.AssetType.DynamicHead then
		return { "Head" }
	end

	if p1 == Enum.AssetType.Torso then
		return {
			"LowerTorso",
			"UpperTorso"
		}
	end

	assert(false, "Invalid asset type")

	return {}
end

return getPartNamesInHierarchyOrder
