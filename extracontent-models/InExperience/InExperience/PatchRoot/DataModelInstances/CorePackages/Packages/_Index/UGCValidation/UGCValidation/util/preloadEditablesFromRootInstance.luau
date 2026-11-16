local UGCValidationService = game:GetService("UGCValidationService")
local v = { MeshId = true, CageMeshId = true, ReferenceMeshId = true }

local v2 = {
	TextureId = true,
	ColorMap = true,
	MetalnessMap = true,
	NormalMap = true,
	RoughnessMap = true,
	EmissiveMask = true
}

local function preloadEditablesFromRootInstance(folder)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)
	local result = {}
	local result2 = {}

	for _, binaryStringValue in descendants do
		if binaryStringValue:IsA("BinaryStringValue") and v[binaryStringValue.Name] then
			result[binaryStringValue.Parent[binaryStringValue.Name]] = UGCValidationService:CreateEditableMeshFromBinaryStringRobloxOnly(binaryStringValue)
		elseif binaryStringValue:IsA("BinaryStringValue") and v2[binaryStringValue.Name] then
			result2[binaryStringValue.Parent[binaryStringValue.Name]] = UGCValidationService:CreateEditableImageFromBinaryStringRobloxOnly(binaryStringValue)
		end
	end

	return result, result2
end

return preloadEditablesFromRootInstance
