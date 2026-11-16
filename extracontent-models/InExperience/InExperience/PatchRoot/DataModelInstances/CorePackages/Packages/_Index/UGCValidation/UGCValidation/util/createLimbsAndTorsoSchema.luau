local parent = script.Parent.Parent

local Constants = require(parent.Constants)

require(parent.util.Types)
local createIndividualBodyPartSchema = require(parent.util.createIndividualBodyPartSchema)

local function createLimbsAndTorsoSchema(p, p2: string, p3)
	local v = Constants.ASSET_TYPE_INFO[p]

	local limbsAndTorsoSchema = {
		ClassName = "Folder",
		Name = { p2 },
		_children = {}
	}

	for k in pairs(v.subParts) do
		local individualBodyPartSchema = createIndividualBodyPartSchema(p, k, p3)
		table.insert(limbsAndTorsoSchema._children, individualBodyPartSchema)
	end

	return limbsAndTorsoSchema
end

return createLimbsAndTorsoSchema
