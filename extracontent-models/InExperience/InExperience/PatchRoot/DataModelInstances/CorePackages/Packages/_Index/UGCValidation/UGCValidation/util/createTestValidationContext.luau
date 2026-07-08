local ParentParent = script.Parent.Parent
local UGCValidationService = game:GetService("UGCValidationService")

require(ParentParent.util.Types)

return function(p1, t1: {[any]: any}) -- line: 7
	-- upvalues: UGCValidationService (copy)
	local t2 = {
		isServer = true,
		validateMeshPartAccessories = false,
		assetTypeEnum = p1
	}
	local t3 = {}
	local t4 = {}

	for _, v9 in t1 do
		for _, descendant in v9:GetDescendants() do
			if descendant:IsA("BinaryStringValue") then
				if descendant.Name == "MeshId" or descendant.Name == "CageMeshId" or descendant.Name == "ReferenceMeshId" then
					if not t3[descendant.Parent] then
						t3[descendant.Parent] = {}
					end

					t3[descendant.Parent][descendant.Name] = {
						created = true,
						instance = UGCValidationService:CreateEditableMeshFromBinaryStringRobloxOnly(descendant)
					}
				else
					if not t4[descendant.Parent] then
						t4[descendant.Parent] = {}
					end

					t4[descendant.Parent][descendant.Name] = {
						created = true,
						instance = UGCValidationService:CreateEditableImageFromBinaryStringRobloxOnly(descendant)
					}
				end
			end
		end
	end

	t2.editableMeshes = t3
	t2.editableImages = t4

	return t2
end
