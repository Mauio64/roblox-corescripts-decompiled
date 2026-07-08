local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)

local function getContent(p1, s1: string) -- line: 12
	-- upvalues: Constants (copy)
	if s1 == Constants.MESH_CONTENT_TYPE.RENDER_MESH then
		assert(p1:IsA("MeshPart"), "Only MESH_TYPE.RENDER_MESH is only supported for MeshPart")

		return p1.MeshId
	end

	if s1 == Constants.MESH_CONTENT_TYPE.OUTER_CAGE then
		assert(p1:IsA("BaseWrap"), "Only MESH_TYPE.OUTER_CAGE is only supported for BaseWrap")

		return p1.CageMeshId
	end

	if s1 == Constants.MESH_CONTENT_TYPE.INNER_CAGE then
		assert(p1:IsA("WrapLayer"), "Only MESH_TYPE.INNER_CAGE is only supported for WrapLayer")

		return p1.ReferenceMeshId
	end

	error("No valid mesh content type was provided")
end
local function getMeshInfo(p2, s2: string, p3) -- line: 27
	-- upvalues: getContent (copy), Constants (copy), getEditableMeshFromContext (copy)
	local v11 = getContent(p2, s2)
	local FullName = p2:GetFullName()
	local v13 = Constants.MESH_CONTENT_TYPE_TO_FIELD_NAME[s2]
	local v14, v15 = getEditableMeshFromContext(p2, v13, p3)

	if not v14 then
		return false, { string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", FullName) }
	end

	return true, nil, {
		fullName = FullName,
		fieldName = v13,
		contentId = v11,
		context = p2.ClassName,
		editableMesh = v15
	}
end

return getMeshInfo
