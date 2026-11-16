local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

require(parent.util.Types)

local function validateLayeredClothingAccessoryMeshPartAssetFormatMatch(instance, instance2, p)
	local handle = instance:FindFirstChild("Handle")
	assert(handle and handle:IsA("MeshPart"))

	local handle2 = instance2:FindFirstChild("Handle")
	assert(handle2 and handle2:IsA("MeshPart"))

	if handle.MeshId ~= handle2.MeshId then
		Analytics.reportFailure(
			Analytics.ErrorType.validateLayeredClothingAccessoryMeshPartAssetFormatMatch_MeshIdMismatch,
			nil,
			p
		)

		return
			false,
			{ string.format(
					"Model meshId mismatch between MeshPart.MeshId and SpecialMesh.MeshId for %s. You need to match the meshIds and try again.",
					instance.Name
				) }
	end

	if handle.TextureID == handle2.TextureID then
		return true
	end

	Analytics.reportFailure(
		Analytics.ErrorType.validateLayeredClothingAccessoryMeshPartAssetFormatMatch_TextureIdMismatch,
		nil,
		p
	)

	return
		false,
		{ string.format(
				"Model textureId mismatch between MeshPart.TextureID and SpecialMesh.TextureId for %s. You need to match the textureIds and try again.",
				instance.Name
			) }
end

return validateLayeredClothingAccessoryMeshPartAssetFormatMatch
