local parent = script.Parent.Parent

local Constants = require(parent.Constants)

require(parent.util.Types)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local function getContent(instance, p: string)
	if p == Constants.MESH_CONTENT_TYPE.RENDER_MESH then
		assert(instance:IsA("MeshPart"), "Only MESH_TYPE.RENDER_MESH is only supported for MeshPart")
		return instance.MeshId
	end

	if p == Constants.MESH_CONTENT_TYPE.OUTER_CAGE then
		assert(instance:IsA("BaseWrap"), "Only MESH_TYPE.OUTER_CAGE is only supported for BaseWrap")
		return instance.CageMeshId
	end

	if p == Constants.MESH_CONTENT_TYPE.INNER_CAGE then
		assert(instance:IsA("WrapLayer"), "Only MESH_TYPE.INNER_CAGE is only supported for WrapLayer")
		return instance.ReferenceMeshId
	end

	error("No valid mesh content type was provided")
end

local function getMeshInfo(instance, p: string, p2)
	local content = getContent(instance, p)
	local fullName = instance:GetFullName()
	local fieldName = Constants.MESH_CONTENT_TYPE_TO_FIELD_NAME[p]
	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(instance, fieldName, p2)

	if editableMeshFromContext then
		return true, nil, {
			fullName = fullName,
			fieldName = fieldName,
			contentId = content,
			context = instance.ClassName,
			editableMesh = editableMesh
		}
	end

	return false, { string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", fullName) }
end

return getMeshInfo
