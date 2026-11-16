local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local MaterialsAllowed = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {}
}

local function buildAcceptedMaterialList()
	local names = {}

	for k in pairs(Constants.MATERIAL_WHITELIST) do
		table.insert(names, k.Name)
	end

	return table.concat(names, ", ")
end

function MaterialsAllowed.run(object, p)
	local rootInstance = p.rootInstance

	local descendants = rootInstance:GetDescendants()
	table.insert(descendants, rootInstance)
	local allowedMaterials = nil

	for _, part in descendants do
		if not part:IsA("BasePart") or Constants.MATERIAL_WHITELIST[part.Material] then
			continue
		end

		allowedMaterials = allowedMaterials or buildAcceptedMaterialList()
		object:fail(ErrorSourceStrings.Keys.MaterialNotAllowed, {
			InstanceNameList = part:GetFullName(),
			AllowedMaterials = allowedMaterials
		})
	end
end

return MaterialsAllowed
