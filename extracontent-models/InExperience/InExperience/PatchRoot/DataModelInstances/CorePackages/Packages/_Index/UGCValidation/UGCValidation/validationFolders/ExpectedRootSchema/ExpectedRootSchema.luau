local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local Constants = require(parent.Constants)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local CreateExpectedSchema = require(parent.util.CreateExpectedSchema)
local validateInstanceTreeAgainstSchema = require(parent.util.validateInstanceTreeAgainstSchema)

local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getEngineFeatureEngineUGCValidateInstanceTreesEquivalent = require(parent.flags.getEngineFeatureEngineUGCValidateInstanceTreesEquivalent)
local shouldValidateR15LegacyDuplicate = require(parent.util.shouldValidateR15LegacyDuplicate)
return {
	["categories"] = Constants.AllUploadCategories,
	requiredData = {
		ValidationEnums.SharedDataMember.entrypointInput,
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadCategory,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	run = function(object, data)
		local rootInstance = data.rootInstance
		local uploadCategory = data.uploadCategory
		local uploadEnum = data.uploadEnum

		if rootInstance == nil then
			object:fail(ErrorSourceStrings.Keys.SelectionCountNotOne)
			return
		end

		local v

		if uploadEnum.bundleType then
			if uploadEnum.bundleType == Enum.BundleType.Animations then
				v = CreateExpectedSchema.generateAnimationPackBundleSchema()
			else
				local entrypointInput = data.entrypointInput
				v = CreateExpectedSchema.generateBundleSchema(entrypointInput)
			end
		else
			v = CreateExpectedSchema.generateAssetSchema(uploadCategory, uploadEnum.assetType, rootInstance)
		end

		validateInstanceTreeAgainstSchema(rootInstance, v, object)

		if getEngineFeatureEngineUGCValidateInstanceTreesEquivalent() and shouldValidateR15LegacyDuplicate(data) then
			if data.r15LegacyDuplicateRoot == nil then
				object:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)
				return
			end

			object:setReportingRoot(data.r15LegacyDuplicateRoot)
			validateInstanceTreeAgainstSchema(data.r15LegacyDuplicateRoot, v, object)
			object:setReportingRoot(rootInstance)
		end
	end
}
