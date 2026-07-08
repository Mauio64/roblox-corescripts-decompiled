local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local t1 = {
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.hsrAssets
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function hasOnlyAllowedAttribute(t2: {[any]: any}, b1: boolean) -- line: 21
	-- upvalues: Constants (copy)
	for v12, v13 in t2 do
		if b1 and v12 == Constants.AlternateMeshIdAttributeName then
			continue
		end

		if v12 ~= Constants.GUIDAttributeName then
			return false
		end

		if typeof(v13) ~= "string" then
			return false
		end

		if string.len(v13) > Constants.GUIDAttributeMaxLength then
			return false
		end
	end

	return true
end
local function reportInstanceWithDisallowedAttributes(p1, p2) -- line: 42
	-- upvalues: ErrorSourceStrings (copy)
	p1:fail(ErrorSourceStrings.Keys.NoAttributes, {
		RootInstanceName = p2.Name,
		InstanceNameList = p2:GetFullName()
	})
end
local function walkInstanceTree(p3, p4, b2: boolean) -- line: 50
	-- upvalues: hasOnlyAllowedAttribute (copy), ErrorSourceStrings (copy), Constants (copy)
	if not hasOnlyAllowedAttribute(p4:GetAttributes(), b2) then
		p3:fail(ErrorSourceStrings.Keys.NoAttributes, {
			RootInstanceName = p4.Name,
			InstanceNameList = p4:GetFullName()
		})
	end

	for _, descendant in p4:GetDescendants() do
		if (not b2 or not descendant:GetAttribute(Constants.AlternateMeshIdAttributeName)) and next(descendant:GetAttributes()) ~= nil then
			p3:fail(ErrorSourceStrings.Keys.NoAttributes, {
				RootInstanceName = descendant.Name,
				InstanceNameList = descendant:GetFullName()
			})
		end
	end
end

function t1.run(p5, p6) -- line: 69
	-- upvalues: ValidationEnums (copy), walkInstanceTree (copy)
	local v23 = p6.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC

	walkInstanceTree(p5, p6.rootInstance, v23)

	for _, v25 in p6.hsrAssets do
		for _, v27 in v25 do
			walkInstanceTree(p5, v27, v23)
		end
	end
end

return t1
