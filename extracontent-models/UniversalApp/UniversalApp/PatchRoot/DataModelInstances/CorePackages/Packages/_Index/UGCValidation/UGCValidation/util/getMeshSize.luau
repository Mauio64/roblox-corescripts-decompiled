local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local function getMeshSize(p1) -- line: 7
	-- upvalues: UGCValidationService (copy)
	local EditableMeshVerts = UGCValidationService:GetEditableMeshVerts(p1.editableMesh)
	local n1 = 1e999
	local n2 = -1e999
	local n3 = 1e999
	local n4 = -1e999
	local n5 = 1e999
	local n6 = -1e999

	for i = 1, #EditableMeshVerts do
		local v13 = EditableMeshVerts[i]

		n1 = math.min(n1, v13.X)
		n3 = math.min(n3, v13.Y)
		n5 = math.min(n5, v13.Z)
		n2 = math.max(n2, v13.X)
		n4 = math.max(n4, v13.Y)
		n6 = math.max(n6, v13.Z)
	end

	return (Vector3.new(n2 - n1, n4 - n3, n6 - n5))
end

return getMeshSize
