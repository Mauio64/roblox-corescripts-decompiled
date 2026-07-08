local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFIntUGCValidateMaxHSRDataLen = require(ParentParent.flags.getFIntUGCValidateMaxHSRDataLen)
local t1 = {
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.hsrAssets
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function walkInstanceTree(p1, p2, t2: {[any]: any}) -- line: 25
	-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
	local descendants = p2:GetDescendants()

	table.insert(descendants, p2)

	for _, v16 in descendants do
		local v17, v18 = UGCValidationService:ValidatePropertiesSensible(v16, t2[v16.ClassName])

		if not v17 then
			p1:fail(ErrorSourceStrings.Keys.PropertiesNotSensible, {
				ClassName = v16.ClassName,
				InstancePath = v16:GetFullName(),
				ProblematicProperties = table.concat(v18, ", ")
			})
		end
	end
end

function t1.run(p3, p4) -- line: 49
	-- upvalues: getEngineFeatureEngineUGCValidatePropertiesSensible (copy), getFIntUGCValidateMaxHSRDataLen (copy), walkInstanceTree (copy)
	if not getEngineFeatureEngineUGCValidatePropertiesSensible() then
		return
	end

	local t3 = {
		HiddenSurfaceRemovalAsset = {
			HSRData = getFIntUGCValidateMaxHSRDataLen()
		}
	}

	walkInstanceTree(p3, p4.rootInstance, t3)

	for _, v23 in p4.hsrAssets do
		for _, v25 in v23 do
			walkInstanceTree(p3, v25, t3)
		end
	end
end

return t1
