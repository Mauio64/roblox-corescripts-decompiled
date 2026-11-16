local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getEngineFeatureEngineUGCValidateInstanceTreesEquivalent = require(parent.flags.getEngineFeatureEngineUGCValidateInstanceTreesEquivalent)

local ArchivableRequired = {
	["categories"] = Constants.AllUploadCategories,
	requiredData = { ValidationEnums.SharedDataMember.entrypointInput },
	fflag = getEngineFeatureEngineUGCValidateInstanceTreesEquivalent
}

local function collectAllInstances(entrypointInput)
	local allInstances = {}

	for _, item in entrypointInput do
		local v = {}

		if typeof(item) == "Instance" then
			table.insert(v, item)
		elseif typeof(item) == "table" and item.allSelectedInstances ~= nil then
			v = item.allSelectedInstances
		end

		for _, folder in v do
			table.insert(allInstances, folder)

			for _, descendant in folder:GetDescendants() do
				table.insert(allInstances, descendant)
			end
		end
	end

	return allInstances
end

function ArchivableRequired.run(object, p)
	for _, v in collectAllInstances(p.entrypointInput) do
		if v.Archivable == false then
			object:fail(ErrorSourceStrings.Keys.PropertyValueInvalid, {
				PropertyName = "Archivable",
				InstancePath = v:GetFullName(),
				ComparisonMethod = Constants.COMPARISON_METHODS.EXACT_EQ,
				ExpectedValue = "true"
			})
		end
	end
end

return ArchivableRequired
