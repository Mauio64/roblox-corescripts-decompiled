local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local createIndividualBodyPartSchema = require(ParentParent.util.createIndividualBodyPartSchema)

local function createDynamicHeadMeshPartSchema(p1) -- line: 7
	-- upvalues: createIndividualBodyPartSchema (copy)
	local v5 = createIndividualBodyPartSchema(Enum.AssetType.DynamicHead, "Head", p1)

	table.insert(v5._children, {
		ClassName = "FaceControls",
		Name = { "FaceControls" }
	})

	return v5
end

return createDynamicHeadMeshPartSchema
