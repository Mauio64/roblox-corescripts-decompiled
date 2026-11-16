local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

require(parent.util.Types)

local function validateLegacyAccessoryMeshPartAssetFormatMatch(instance, instance2, p)
	local handle = instance:FindFirstChild("Handle")
	assert(handle and handle:IsA("MeshPart"))

	local handle2 = instance2:FindFirstChild("Handle")
	assert(handle2 and handle2:IsA("Part"))
	local specialMesh = handle2:FindFirstChildOfClass("SpecialMesh")
	assert(specialMesh)

	if handle.MeshId ~= specialMesh.MeshId then
		Analytics.reportFailure(
			Analytics.ErrorType.validateLegacyAccessoryMeshPartAssetFormatMatch_MeshIdMismatch,
			nil,
			p
		)

		return
			false,
			{ string.format(
					"Model meshId mismatch with rigid accessory SpecialMesh.MeshId for '%s'. You need to match the meshIds and try again.",
					instance.Name
				) }
	end

	local v = handle.TextureID

	if v == "" then
		local surfaceAppearance = handle:FindFirstChildOfClass("SurfaceAppearance")

		if surfaceAppearance then
			v = surfaceAppearance.ColorMap
		end
	end

	if v == specialMesh.TextureId then
		return true
	end

	Analytics.reportFailure(
		Analytics.ErrorType.validateLegacyAccessoryMeshPartAssetFormatMatch_TextureIdMismatch,
		nil,
		p
	)

	return
		false,
		{ string.format(
				"Model textureId mismatch with rigid accessory SpecialMesh.TextureId for '%s'. You need to match the textureIds and try again.",
				instance.Name
			) }
end

return validateLegacyAccessoryMeshPartAssetFormatMatch
