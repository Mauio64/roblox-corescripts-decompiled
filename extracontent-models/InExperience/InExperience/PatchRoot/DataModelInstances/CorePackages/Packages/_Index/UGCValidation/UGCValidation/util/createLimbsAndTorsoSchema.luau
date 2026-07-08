local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local createIndividualBodyPartSchema = require(ParentParent.util.createIndividualBodyPartSchema)

local function createLimbsAndTorsoSchema(p1, s1: string, p2) -- line: 8
	-- upvalues: Constants (copy), createIndividualBodyPartSchema (copy)
	local v8 = Constants.ASSET_TYPE_INFO[p1]
	local t1 = {
		ClassName = "Folder",
		Name = { s1 },
		_children = {}
	}

	for k in pairs(v8.subParts) do
		local v11 = createIndividualBodyPartSchema(p1, k, p2)

		table.insert(t1._children, v11)
	end

	return t1
end

return createLimbsAndTorsoSchema
