local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function validateLayeredClothingAccessoryMeshPartAssetFormatMatch(p1, p2, p3) -- line: 7
	-- upvalues: Analytics (copy)
	local Handle = p1:FindFirstChild("Handle")

	assert(Handle and Handle:IsA("MeshPart"))

	local Handle2 = p2:FindFirstChild("Handle")

	assert(Handle2 and Handle2:IsA("MeshPart"))

	if Handle.MeshId ~= Handle2.MeshId then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessoryMeshPartAssetFormatMatch_MeshIdMismatch, nil, p3)

		return false, { string.format("Model meshId mismatch between MeshPart.MeshId and SpecialMesh.MeshId for %s. You need to match the meshIds and try again.", p1.Name) }
	end

	if Handle.TextureID ~= Handle2.TextureID then
		Analytics.reportFailure(Analytics.ErrorType.validateLayeredClothingAccessoryMeshPartAssetFormatMatch_TextureIdMismatch, nil, p3)

		return false, { string.format("Model textureId mismatch between MeshPart.TextureID and SpecialMesh.TextureId for %s. You need to match the textureIds and try again.", p1.Name) }
	end

	return true
end

return validateLayeredClothingAccessoryMeshPartAssetFormatMatch
