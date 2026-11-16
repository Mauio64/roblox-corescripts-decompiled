local function getPartNamesInHierarchyOrder(p)
	if Enum.AssetType.LeftArm == p then
		return { "LeftUpperArm", "LeftLowerArm", "LeftHand" }
	end

	if Enum.AssetType.RightArm == p then
		return { "RightUpperArm", "RightLowerArm", "RightHand" }
	end

	if Enum.AssetType.LeftLeg == p then
		return { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" }
	end

	if Enum.AssetType.RightLeg == p then
		return { "RightUpperLeg", "RightLowerLeg", "RightFoot" }
	end

	if Enum.AssetType.DynamicHead == p then
		return { "Head" }
	end

	if Enum.AssetType.Torso == p then
		return { "LowerTorso", "UpperTorso" }
	end

	assert(false, "Invalid asset type")
	return {}
end

return getPartNamesInHierarchyOrder
