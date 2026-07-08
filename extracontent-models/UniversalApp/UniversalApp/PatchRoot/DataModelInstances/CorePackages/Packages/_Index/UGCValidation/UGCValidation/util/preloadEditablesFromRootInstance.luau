local UGCValidationService = game:GetService("UGCValidationService")
local t1 = {
	MeshId = true,
	CageMeshId = true,
	ReferenceMeshId = true
}
local t2 = {
	TextureId = true,
	MetalnessMap = true,
	NormalMap = true,
	RoughnessMap = true
}

local function preloadEditablesFromRootInstance(p1) -- line: 15
	-- upvalues: t1 (copy), UGCValidationService (copy), t2 (copy)
	local t3 = {}
	local t4 = {}
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	for _, v10 in descendants do
		if v10:IsA("BinaryStringValue") and t1[v10.Name] then
			t3[v10.Parent[v10.Name]] = UGCValidationService:CreateEditableMeshFromBinaryStringRobloxOnly(v10)
		elseif v10:IsA("BinaryStringValue") and t2[v10.Name] then
			t4[v10.Parent[v10.Name]] = UGCValidationService:CreateEditableImageFromBinaryStringRobloxOnly(v10)
		end
	end

	return t3, t4
end

return preloadEditablesFromRootInstance
