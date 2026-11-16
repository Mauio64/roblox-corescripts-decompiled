local parent = script.Parent.Parent

require(parent.util.Types)

local createIndividualBodyPartSchema = require(parent.util.createIndividualBodyPartSchema)

local function createDynamicHeadMeshPartSchema(p)
	local individualBodyPartSchema = createIndividualBodyPartSchema(Enum.AssetType.DynamicHead, "Head", p)

	table.insert(individualBodyPartSchema._children, {
		Name = { "FaceControls" },
		ClassName = "FaceControls"
	})

	return individualBodyPartSchema
end

return createDynamicHeadMeshPartSchema
