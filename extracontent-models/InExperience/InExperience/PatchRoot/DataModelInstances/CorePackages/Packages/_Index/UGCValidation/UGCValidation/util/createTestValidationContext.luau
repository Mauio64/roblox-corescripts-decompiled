local parent = script.Parent.Parent

local UGCValidationService = game:GetService("UGCValidationService")

require(parent.util.Types)

return function(assetTypeEnum, items)
	local editableMeshes = {}
	local editableImages = {}
	local v = {
		isServer = true,
		assetTypeEnum = assetTypeEnum,
		validateMeshPartAccessories = false
	}

	for _, folder in items do
		for _, binaryStringValue in folder:GetDescendants() do
			if not binaryStringValue:IsA("BinaryStringValue") then
				continue
			end

			if
				binaryStringValue.Name == "MeshId"
				or binaryStringValue.Name == "CageMeshId"
				or binaryStringValue.Name == "ReferenceMeshId"
			then
				if not editableMeshes[binaryStringValue.Parent] then
					editableMeshes[binaryStringValue.Parent] = {}
				end

				editableMeshes[binaryStringValue.Parent][binaryStringValue.Name] = {
					created = true,
					instance = UGCValidationService:CreateEditableMeshFromBinaryStringRobloxOnly(binaryStringValue)
				}
			else
				if not editableImages[binaryStringValue.Parent] then
					editableImages[binaryStringValue.Parent] = {}
				end

				editableImages[binaryStringValue.Parent][binaryStringValue.Name] = {
					created = true,
					instance = UGCValidationService:CreateEditableImageFromBinaryStringRobloxOnly(binaryStringValue)
				}
			end
		end
	end

	v.editableMeshes = editableMeshes
	v.editableImages = editableImages

	return v
end
