local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local Constants = require(ParentParent.Constants)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local CreateExpectedSchema = require(ParentParent.util.CreateExpectedSchema)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidationExtendSchemaToIgnoreDescendants = require(ParentParent.flags.getFFlagUGCValidationExtendSchemaToIgnoreDescendants)
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

local function checkName(p1, s1: string) -- line: 25
	if type(p1) == "table" then
		return table.find(p1, s1) ~= nil
	end

	return p1 == s1
end
local function getReadableName(p2) -- line: 32
	if type(p2) == "table" then
		return table.concat(p2, " or ")
	end

	if type(p2) == "string" then
		return p2
	end

	return "*"
end
local function validateInstancesFromSchema(p3, p4, t2: {[any]: any}, p5) -- line: 41
	-- upvalues: getFFlagUGCValidationExtendSchemaToIgnoreDescendants (copy), validateInstancesFromSchema (copy), ErrorSourceStrings (copy)
	t2[p3] = true

	if getFFlagUGCValidationExtendSchemaToIgnoreDescendants() and p4._ignoreDescendants then
		assert(not p4._children, "if _ignoreDescendants is true, there should be no descendants in the schema as they would be ignored anyway")

		for _, descendant in p3:GetDescendants() do
			t2[descendant] = true
		end

		return
	end

	local g29 = nil
	local g30 = nil

	for _, v25 in p4._children or {} do
		local v26 = false

		for _, child in p3:GetChildren() do
			if t2[child] ~= nil or child.ClassName ~= v25.ClassName then
				continue
			end

			repeat
				if g29 or v25.Name == nil then
					g29 = false
					validateInstancesFromSchema(child, v25, t2, p5)
					v26 = true
					g30 = true

					break
				end

				local Name = v25.Name
				local childName = child.Name

				if if type(Name) ~= "table" then Name == childName else table.find(Name, childName) ~= nil then
					g29 = true
				end
			until not g29

			if g30 then
				g30 = false

				break
			end
		end

		if not v26 and not v25._optional then
			local AssetSchemaMissingItem = ErrorSourceStrings.Keys.AssetSchemaMissingItem
			local t3 = {
				ParentPath = p3:GetFullName(),
				ExpectedClass = v25.ClassName
			}
			local Name = v25.Name

			t3.ExpectedName = if type(Name) ~= "table" then type(Name) ~= "string" and "*" or Name else table.concat(Name, " or ")
			p5:fail(AssetSchemaMissingItem, t3, p3)
		end
	end
end
local function validateNoInstancesOutsideSchema(p6, t4: {[any]: any}, p7) -- line: 86
	-- upvalues: ErrorSourceStrings (copy)
	local t5 = {}

	for _, descendant in pairs(p6:GetDescendants()) do
		if t4[descendant] == nil then
			table.insert(t5, descendant:GetFullName())
		end
	end

	if #t5 > 0 then
		p7:fail(ErrorSourceStrings.Keys.AssetSchemaUnexpectedItems, {
			UnexpectedDescendantPaths = table.concat(t5, ", ")
		}, p6)
	end
end

function t1.run(p8, p9) -- line: 107
	-- upvalues: ErrorSourceStrings (copy), getFFlagUGCValidationAnimationPackSupport (copy), getFFlagUGCValidationAnimationPackDisableModelStructure (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy), CreateExpectedSchema (copy), validateInstancesFromSchema (copy), validateNoInstancesOutsideSchema (copy)
	local rootInstance = p9.rootInstance
	local uploadCategory = p9.uploadCategory
	local uploadEnum = p9.uploadEnum

	if rootInstance == nil then
		p8:fail(ErrorSourceStrings.Keys.SelectionCountNotOne)

		return
	end

	local v47

	if uploadEnum.bundleType then
		if getFFlagUGCValidationAnimationPackSupport() and uploadEnum.bundleType == Enum.BundleType.Animations then
			v47 = if getFFlagUGCValidationAnimationPackDisableModelStructure() or not getFFlagUGCValidationAnimationPackFolderStructure() then CreateExpectedSchema.generateAnimationPackBundleSchema(nil) else CreateExpectedSchema.generateAnimationPackBundleSchema(rootInstance)
		else
			local entrypointInput = p9.entrypointInput

			v47 = CreateExpectedSchema.generateBundleSchema(entrypointInput)
		end
	else
		v47 = CreateExpectedSchema.generateAssetSchema(uploadCategory, uploadEnum.assetType, rootInstance)
	end

	local t6 = {}

	if v47.ClassName ~= rootInstance.ClassName then
		p8:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootClass, {
			RootClass = rootInstance.ClassName,
			ExpectedClass = v47.ClassName
		})

		return
	end

	if v47.Name ~= nil then
		local Name = v47.Name
		local rootInstanceName = rootInstance.Name

		if not if type(Name) ~= "table" then Name == rootInstanceName else table.find(Name, rootInstanceName) ~= nil then
			p8:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootName, {
				RootName = rootInstance.Name,
				ExpectedName = v47.Name
			})

			return
		end
	end

	validateInstancesFromSchema(rootInstance, v47, t6, p8)
	validateNoInstancesOutsideSchema(rootInstance, t6, p8)
end

return t1
