local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function buildAcceptedMaterialList() -- line: 24
	-- upvalues: Constants (copy)
	local t2 = {}

	for k in pairs(Constants.MATERIAL_WHITELIST) do
		table.insert(t2, k.Name)
	end

	return table.concat(t2, ", ")
end

function t1.run(p1, p2) -- line: 32
	-- upvalues: Constants (copy), buildAcceptedMaterialList (copy), ErrorSourceStrings (copy)
	local rootInstance = p2.rootInstance
	local descendants = rootInstance:GetDescendants()

	table.insert(descendants, rootInstance)

	local v14 = nil

	for _, v16 in descendants do
		if v16:IsA("BasePart") and not Constants.MATERIAL_WHITELIST[v16.Material] then
			v14 = v14 or buildAcceptedMaterialList()
			p1:fail(ErrorSourceStrings.Keys.MaterialNotAllowed, {
				InstanceNameList = v16:GetFullName(),
				AllowedMaterials = v14
			})
		end
	end
end

return t1
