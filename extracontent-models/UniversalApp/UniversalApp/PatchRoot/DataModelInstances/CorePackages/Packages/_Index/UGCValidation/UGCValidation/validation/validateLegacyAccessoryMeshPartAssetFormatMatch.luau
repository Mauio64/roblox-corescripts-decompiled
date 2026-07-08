local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function validateLegacyAccessoryMeshPartAssetFormatMatch(p1, p2, p3) -- line: 7
	-- upvalues: Analytics (copy)
	local Handle = p1:FindFirstChild("Handle")

	assert(Handle and Handle:IsA("MeshPart"))

	local Handle2 = p2:FindFirstChild("Handle")

	assert(Handle2 and Handle2:IsA("Part"))

	local SpecialMesh = Handle2:FindFirstChildOfClass("SpecialMesh")

	assert(SpecialMesh)

	if Handle.MeshId ~= SpecialMesh.MeshId then
		Analytics.reportFailure(Analytics.ErrorType.validateLegacyAccessoryMeshPartAssetFormatMatch_MeshIdMismatch, nil, p3)

		return false, { string.format("Model meshId mismatch with rigid accessory SpecialMesh.MeshId for '%s'. You need to match the meshIds and try again.", p1.Name) }
	end

	local TextureID = Handle.TextureID

	if TextureID == "" then
		local SurfaceAppearance = Handle:FindFirstChildOfClass("SurfaceAppearance")

		if SurfaceAppearance then
			TextureID = SurfaceAppearance.ColorMap
		end
	end

	if TextureID ~= SpecialMesh.TextureId then
		Analytics.reportFailure(Analytics.ErrorType.validateLegacyAccessoryMeshPartAssetFormatMatch_TextureIdMismatch, nil, p3)

		return false, { string.format("Model textureId mismatch with rigid accessory SpecialMesh.TextureId for '%s'. You need to match the textureIds and try again.", p1.Name) }
	end

	return true
end

return validateLegacyAccessoryMeshPartAssetFormatMatch
