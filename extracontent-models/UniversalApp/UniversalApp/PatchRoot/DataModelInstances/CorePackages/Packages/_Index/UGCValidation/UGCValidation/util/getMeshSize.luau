local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)

local function getMeshSize(p)
	local editableMeshVerts = UGCValidationService:GetEditableMeshVerts(p.editableMesh)
	local minX = 1e999
	local minY = 1e999
	local minZ = 1e999
	local maxX = -1e999
	local maxY = -1e999
	local maxZ = -1e999

	for i = 1, #editableMeshVerts do
		local editableMeshVert = editableMeshVerts[i]
		minX = math.min(minX, editableMeshVert.X)
		minY = math.min(minY, editableMeshVert.Y)
		minZ = math.min(minZ, editableMeshVert.Z)
		maxX = math.max(maxX, editableMeshVert.X)
		maxY = math.max(maxY, editableMeshVert.Y)
		maxZ = math.max(maxZ, editableMeshVert.Z)
	end

	return (Vector3.new(maxX - minX, maxY - minY, maxZ - minZ))
end

return getMeshSize
