local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local CreateExpectedSchema = require(ParentParent.util.CreateExpectedSchema)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidationExtendSchemaToIgnoreDescendants = require(ParentParent.flags.getFFlagUGCValidationExtendSchemaToIgnoreDescendants)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidationAnimationPackFolderStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackFolderStructure)
local getFFlagUGCValidationAnimationPackDisableModelStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackDisableModelStructure)
local t1 = {
	categories = Constants.AllUploadCategories,
	requiredData = {
		ValidationEnums.SharedDataMember.entrypointInput,
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadCategory,
		ValidationEnums.SharedDataMember.uploadEnum
	}
}

local function checkName(p1, s1: string) -- line: 27
	if type(p1) == "table" then
		return table.find(p1, s1) ~= nil
	end

	return p1 == s1
end
local function getReadableName(p2) -- line: 34
	if type(p2) == "table" then
		return table.concat(p2, " or ")
	end

	if type(p2) == "string" then
		return p2
	end

	return "*"
end
local function validateInstancesFromSchema(p3, p4, t2: {[any]: any}, p5) -- line: 43
	-- upvalues: getFFlagUGCValidationExtendSchemaToIgnoreDescendants (copy), validateInstancesFromSchema (copy), ErrorSourceStrings (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	t2[p3] = true

	if getFFlagUGCValidationExtendSchemaToIgnoreDescendants() and p4._ignoreDescendants then
		assert(not p4._children, "if _ignoreDescendants is true, there should be no descendants in the schema as they would be ignored anyway")

		for _, descendant in p3:GetDescendants() do
			t2[descendant] = true
		end

		return
	end

	local g30 = nil
	local g31 = nil

	for _, v26 in p4._children or {} do
		local v27 = false

		for _, child in p3:GetChildren() do
			if t2[child] ~= nil or child.ClassName ~= v26.ClassName then
				continue
			end

			repeat
				if g30 or v26.Name == nil then
					g30 = false
					validateInstancesFromSchema(child, v26, t2, p5)
					v27 = true
					g31 = true

					break
				end

				local Name = v26.Name
				local childName = child.Name

				if if type(Name) ~= "table" then Name == childName else table.find(Name, childName) ~= nil then
					g30 = true
				end
			until not g30

			if g31 then
				g31 = false

				break
			end
		end

		if not v27 and not v26._optional then
			local AssetSchemaMissingItem = ErrorSourceStrings.Keys.AssetSchemaMissingItem
			local t3 = {
				ParentPath = p3:GetFullName(),
				ExpectedClass = v26.ClassName
			}
			local Name = v26.Name

			t3.ExpectedName = if type(Name) ~= "table" then type(Name) ~= "string" and "*" or Name else table.concat(Name, " or ")
			p5:fail(AssetSchemaMissingItem, t3, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else p3)
		end
	end
end
local function validateNoInstancesOutsideSchema(p6, t4: {[any]: any}, p7) -- line: 88
	-- upvalues: ErrorSourceStrings (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	local t5 = {}

	for _, descendant in pairs(p6:GetDescendants()) do
		if t4[descendant] == nil then
			table.insert(t5, descendant:GetFullName())
		end
	end

	if #t5 > 0 then
		p7:fail(ErrorSourceStrings.Keys.AssetSchemaUnexpectedItems, {
			UnexpectedDescendantPaths = table.concat(t5, ", ")
		}, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else p6)
	end
end

function t1.run(p8, p9) -- line: 109
	-- upvalues: ErrorSourceStrings (copy), getFFlagUGCValidationAnimationPackSupport (copy), getFFlagUGCValidationAnimationPackDisableModelStructure (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy), CreateExpectedSchema (copy), validateInstancesFromSchema (copy), validateNoInstancesOutsideSchema (copy)
	local rootInstance = p9.rootInstance
	local uploadCategory = p9.uploadCategory
	local uploadEnum = p9.uploadEnum

	if rootInstance == nil then
		p8:fail(ErrorSourceStrings.Keys.SelectionCountNotOne)

		return
	end

	local v48

	if uploadEnum.bundleType then
		if getFFlagUGCValidationAnimationPackSupport() and uploadEnum.bundleType == Enum.BundleType.Animations then
			v48 = if getFFlagUGCValidationAnimationPackDisableModelStructure() or not getFFlagUGCValidationAnimationPackFolderStructure() then CreateExpectedSchema.generateAnimationPackBundleSchema(nil) else CreateExpectedSchema.generateAnimationPackBundleSchema(rootInstance)
		else
			local entrypointInput = p9.entrypointInput

			v48 = CreateExpectedSchema.generateBundleSchema(entrypointInput)
		end
	else
		v48 = CreateExpectedSchema.generateAssetSchema(uploadCategory, uploadEnum.assetType, rootInstance)
	end

	local t6 = {}

	if v48.ClassName ~= rootInstance.ClassName then
		p8:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootClass, {
			RootClass = rootInstance.ClassName,
			ExpectedClass = v48.ClassName
		})

		return
	end

	if v48.Name ~= nil then
		local Name = v48.Name
		local rootInstanceName = rootInstance.Name

		if not if type(Name) ~= "table" then Name == rootInstanceName else table.find(Name, rootInstanceName) ~= nil then
			p8:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootName, {
				RootName = rootInstance.Name,
				ExpectedName = v48.Name
			})

			return
		end
	end

	validateInstancesFromSchema(rootInstance, v48, t6, p8)
	validateNoInstancesOutsideSchema(rootInstance, t6, p8)
end

return t1
