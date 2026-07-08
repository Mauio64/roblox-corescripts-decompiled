local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local isNotNillish = require(ParentParent.luaUtils.isNillish).isNotNillish
local inspect = require(script.Parent.Parent.jsutils.inspect).inspect
local GraphQLError = require(script.Parent.Parent.error.GraphQLError).GraphQLError
local locatedError = require(script.Parent.Parent.error).locatedError

require(ParentParent.language.ast)

local isValidNameError = require(ParentParent.utilities.assertValidName).isValidNameError
local typeComparators = require(script.Parent.Parent.utilities.typeComparators)
local isEqualType = typeComparators.isEqualType
local isTypeSubTypeOf = typeComparators.isTypeSubTypeOf
local assertSchema = require(script.Parent.schema).assertSchema
local definition = require(script.Parent.definition)
local isIntrospectionType = require(script.Parent.introspection).isIntrospectionType
local directives = require(script.Parent.directives)
local isDirective = directives.isDirective
local GraphQLDeprecatedDirective = directives.GraphQLDeprecatedDirective
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isNamedType = definition.isNamedType
local isNonNullType = definition.isNonNullType
local isInputType = definition.isInputType
local isOutputType = definition.isOutputType
local isRequiredArgument = definition.isRequiredArgument
local isRequiredInputField = definition.isRequiredInputField
local t1 = nil
local validateRootTypes = nil
local validateDirectives = nil
local getOperationTypeNode = nil
local getAllSubNodes = nil
local getAllNodes = nil
local getAllImplementsInterfaceNodes = nil
local getDeprecatedDirectiveNode = nil
local getUnionMemberTypeNodes = nil
local validateEnumValues = nil
local validateName = nil
local validateFields = nil
local validateTypeImplementsAncestors = nil
local validateTypes = nil
local validateTypeImplementsInterface = nil
local validateInterfaces = nil

local function v48(p1) -- line: 78
	-- upvalues: assertSchema (copy), t1 (ref), validateRootTypes (ref), validateDirectives (ref), validateTypes (ref)
	assertSchema(p1)

	if p1.__validationErrors ~= nil then
		return p1.__validationErrors
	end

	local v50 = t1.new(p1)

	validateRootTypes(v50)
	validateDirectives(v50)
	validateTypes(v50)

	local v51 = v50:getErrors()

	p1.__validationErrors = v51

	return v51
end

t1 = {}
t1.__index = t1

function t1.new(p2) -- line: 132
	-- upvalues: t1 (ref)
	local self = setmetatable({}, t1)

	self._errors = {}
	self.schema = p2

	return self
end
function t1.reportError(t2: {[any]: any}, s1: string, p3) -- line: 141
	-- upvalues: Array (copy), Boolean (copy), GraphQLError (copy)
	local v59 = if not Array.isArray(p3) then p3 else Array.filter(p3, Boolean.toJSBoolean)

	t2:addError(GraphQLError.new(s1, v59))
end
function t1.addError(p4, p5) -- line: 150
	table.insert(p4._errors, p5)
end
function t1.getErrors(p6) -- line: 154
	return p6._errors
end
function validateRootTypes(t3: {[any]: any}) -- line: 158
	-- upvalues: isNotNillish (copy), isObjectType (copy), getOperationTypeNode (ref), inspect (copy)
	local schema = t3.schema
	local v65 = schema:getQueryType()

	if not isNotNillish(v65) then
		t3:reportError("Query root type must be provided.", schema.astNode)
	elseif not isObjectType(v65) then
		local v66 = getOperationTypeNode(schema, "query")

		t3:reportError(("Query root type must be Object type, it cannot be %s."):format(inspect(v65)), v66 or v65.astNode)
	end

	local v67 = schema:getMutationType()

	if isNotNillish(v67) and not isObjectType(v67) then
		local v68 = getOperationTypeNode(schema, "mutation")

		t3:reportError("Mutation root type must be Object type if provided, it cannot be " .. ("%s."):format(inspect(v67)), v68 or v67.astNode)
	end

	local v69 = schema:getSubscriptionType()

	if isNotNillish(v69) and not isObjectType(v69) then
		local v70 = getOperationTypeNode(schema, "subscription")

		t3:reportError("Subscription root type must be Object type if provided, it cannot be " .. ("%s."):format(inspect(v69)), v70 or v69.astNode)
	end
end
function getOperationTypeNode(p7, p8) -- line: 197
	-- upvalues: getAllSubNodes (ref)
	local v73 = getAllSubNodes(p7, function(p9) -- line: 198
		return p9.operationTypes
	end)

	for _, v in ipairs(v73) do
		if p8 == v.operation then
			return v.type
		end
	end

	return nil
end
function validateDirectives(t4: {[any]: any}) -- line: 211
	-- upvalues: isDirective (copy), inspect (copy), validateName (ref), isInputType (copy), isRequiredArgument (copy), isNotNillish (copy), getDeprecatedDirectiveNode (ref)
	for _, v in ipairs(t4.schema:getDirectives()) do
		if not isDirective(v) then
			t4:reportError(("Expected directive but got: %s."):format(inspect(v)), if not v then nil else v.astNode)
		else
			validateName(t4, v)

			for _, v2 in ipairs(v.args) do
				validateName(t4, v2)

				if not isInputType(v2.type) then
					t4:reportError(("The type of @%s(%s:) must be Input Type "):format(v.name, v2.name) .. ("but got: %s."):format(inspect(v2.type)), v2.astNode)
				end

				if isRequiredArgument(v2) and isNotNillish(v2.deprecationReason) then
					t4:reportError(("Required argument @%s(%s:) cannot be deprecated."):format(v.name, v2.name), {
						getDeprecatedDirectiveNode(v2.astNode),
						if v2.astNode == nil then nil else v2.astNode.type
					})
				end
			end
		end
	end
end
function validateName(t5: {[any]: any}, t6: {[any]: any}) -- line: 255
	-- upvalues: isValidNameError (copy), locatedError (copy)
	local astNode = nil
	local name

	if typeof(t6) == "table" then
		name = t6.name
		astNode = t6.astNode
	else
		name = tostring(t6)
	end

	local v85 = isValidNameError(name)

	if v85 then
		t5:addError(locatedError(v85, astNode))
	end
end
function validateTypes(t7: {[any]: any}) -- line: 276
	-- upvalues: isNamedType (copy), inspect (copy), isIntrospectionType (copy), validateName (ref), isObjectType (copy), validateFields (ref), validateInterfaces (ref), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), validateEnumValues (ref), isInputObjectType (copy)
	local v87 = createInputObjectCircularRefsValidator(t7)
	local v88 = t7.schema:getTypeMap()

	for _, v in ipairs(v88:values()) do
		local astNode = nil

		if typeof(v) == "table" then
			astNode = v.astNode
		end

		if not isNamedType(v) then
			t7:reportError(("Expected GraphQL named type but got: %s."):format(inspect(v)), astNode)
		else
			if not isIntrospectionType(v) then
				validateName(t7, v)
			end

			if isObjectType(v) then
				validateFields(t7, v)
				validateInterfaces(t7, v)
			elseif isInterfaceType(v) then
				validateFields(t7, v)
				validateInterfaces(t7, v)
			elseif isUnionType(v) then
				validateUnionMembers(t7, v)
			elseif isEnumType(v) then
				validateEnumValues(t7, v)
			elseif isInputObjectType(v) then
				validateInputFields(t7, v)
				v87(v)
			end
		end
	end
end
function validateFields(t8: {[any]: any}, p10) -- line: 329
	-- upvalues: getAllNodes (ref), validateName (ref), isOutputType (copy), inspect (copy), isInputType (copy), isRequiredArgument (copy), isNotNillish (copy), getDeprecatedDirectiveNode (ref)
	local v94 = p10:getFields():values()

	if #v94 == 0 then
		t8:reportError(("Type %s must define one or more fields."):format(p10.name), getAllNodes(p10))
	end

	for _, v in ipairs(v94) do
		validateName(t8, v)

		if not isOutputType(v.type) then
			t8:reportError(("The type of %s.%s must be Output Type "):format(p10.name, v.name) .. ("but got: %s."):format(inspect(v.type)), if v.astNode == nil then nil else v.astNode.type)
		end

		for _, v3 in ipairs(v.args) do
			local name = v3.name

			validateName(t8, v3)

			if not isInputType(v3.type) then
				t8:reportError(("The type of %s.%s(%s:) must be Input "):format(p10.name, v.name, name) .. ("Type but got: %s."):format(inspect(v3.type)), if v3.astNode == nil then nil else v3.astNode.type)
			end

			if isRequiredArgument(v3) and isNotNillish(v3.deprecationReason) then
				t8:reportError(("Required argument %s.%s(%s:) cannot be deprecated."):format(p10.name, v.name, name), {
					getDeprecatedDirectiveNode(v3.astNode),
					if v3.astNode == nil then nil else v3.astNode.type
				})
			end
		end
	end
end
function validateInterfaces(t9: {[any]: any}, p11) -- line: 394
	-- upvalues: isInterfaceType (copy), inspect (copy), getAllImplementsInterfaceNodes (ref), validateTypeImplementsAncestors (ref), validateTypeImplementsInterface (ref)
	local t10 = {}

	for _, v in ipairs(p11:getInterfaces()) do
		if not isInterfaceType(v) then
			t9:reportError(("Type %s must only implement Interface types, "):format(inspect(p11)) .. ("it cannot implement %s."):format(inspect(v)), getAllImplementsInterfaceNodes(p11, v))
		elseif p11 == v then
			t9:reportError(("Type %s cannot implement itself because it would create a circular reference."):format(p11.name), getAllImplementsInterfaceNodes(p11, v))
		else
			local v105 = if typeof(nil) ~= "table" then tostring(v) else tostring(v.name)

			if t10[v105] then
				t9:reportError(("Type %s can only implement %s once."):format(p11.name, v.name), getAllImplementsInterfaceNodes(p11, v))
			else
				t10[v105] = true
				validateTypeImplementsAncestors(t9, p11, v)
				validateTypeImplementsInterface(t9, p11, v)
			end
		end
	end
end
function validateTypeImplementsInterface(t11: {[any]: any}, p12, p13) -- line: 444
	-- upvalues: Array (copy), getAllNodes (ref), isTypeSubTypeOf (copy), inspect (copy), isEqualType (copy), isRequiredArgument (copy)
	local v109 = p12:getFields()

	for _, v in ipairs(p13:getFields():values()) do
		local name = v.name
		local v113 = v109:get(name)

		if not v113 then
			t11:reportError(("Interface field %s.%s expected but %s does not provide it."):format(p13.name, name, p12.name), Array.concat({ v.astNode }, getAllNodes(p12)))
		else
			if not isTypeSubTypeOf(t11.schema, v113.type, v.type) then
				t11:reportError(("Interface field %s.%s expects type "):format(p13.name, name) .. ("%s but %s.%s "):format(inspect(v.type), p12.name, name) .. ("is type %s."):format(inspect(v113.type)), {
					if v.astNode == nil then nil else v.astNode.type,
					if v113.astNode == nil then nil else v113.astNode.type
				})
			end

			for _, v4 in ipairs(v.args) do
				local name2 = v4.name
				local v117 = Array.find(v113.args, function(p14) -- line: 492
					-- upvalues: name2 (copy)
					return p14.name == name2
				end)

				if not v117 then
					t11:reportError(("Interface field argument %s.%s(%s:) expected but %s.%s does not provide it."):format(p13.name, name, name2, p12.name, name), {
						v4.astNode,
						v113.astNode
					})
				elseif not isEqualType(v4.type, v117.type) then
					t11:reportError(("Interface field argument %s.%s(%s:) "):format(p13.name, name, name2) .. ("expects type %s but "):format(inspect(v4.type)) .. ("%s.%s(%s:) is type "):format(p12.name, name, name2) .. ("%s."):format(inspect(v117.type)), {
						if v4.astNode == nil then nil else v4.astNode.type,
						if v117.astNode == nil then nil else v117.astNode.type
					})
				end
			end

			for _, v5 in ipairs(v113.args) do
				local name3 = v5.name

				if not Array.find(v.args, function(p15) -- line: 538
					-- upvalues: name3 (copy)
					return p15.name == name3
				end) and isRequiredArgument(v5) then
					t11:reportError(("Object field %s.%s includes required argument %s that is missing from the Interface field %s.%s."):format(p12.name, name, name3, p13.name, name), {
						v5.astNode,
						v.astNode
					})
				end
			end
		end
	end
end
function validateTypeImplementsAncestors(t12: {[any]: any}, p16, p17) -- line: 557
	-- upvalues: Array (copy), getAllImplementsInterfaceNodes (ref)
	local v124 = p16:getInterfaces()

	for _, v in ipairs(p17:getInterfaces()) do
		if Array.indexOf(v124, v) == -1 then
			t12:reportError(if v ~= p16 then ("Type %s must implement %s because it is implemented by %s."):format(p16.name, v.name, p17.name) else ("Type %s cannot implement %s because it would create a circular reference."):format(p16.name, p17.name), Array.concat(getAllImplementsInterfaceNodes(p17, v), getAllImplementsInterfaceNodes(p16, p17)))
		end
	end
end
function validateUnionMembers(t13: {[any]: any}, p18) -- line: 587
	-- upvalues: getAllNodes (ref), getUnionMemberTypeNodes (ref), isObjectType (copy), inspect (copy)
	local v129 = p18:getTypes()

	if #v129 == 0 then
		t13:reportError(("Union type %s must define one or more member types."):format(p18.name), getAllNodes(p18))
	end

	local t14 = {}

	for _, v in ipairs(v129) do
		if t14[tostring(v.name)] then
			t13:reportError(("Union type %s can only include type %s once."):format(p18.name, v.name), getUnionMemberTypeNodes(p18, v.name))
		else
			t14[tostring(v.name)] = true

			if not isObjectType(v) then
				t13:reportError(("Union type %s can only include Object types, "):format(p18.name) .. ("it cannot include %s."):format(inspect(v)), getUnionMemberTypeNodes(p18, (tostring(v))))
			end
		end
	end
end
function validateEnumValues(t15: {[any]: any}, p19) -- line: 621
	-- upvalues: getAllNodes (ref), validateName (ref)
	local v135 = p19:getValues()

	if #v135 == 0 then
		t15:reportError(("Enum type %s must define one or more values."):format(p19.name), getAllNodes(p19))
	end

	for _, v in ipairs(v135) do
		local name = v.name

		validateName(t15, v)

		if name == "true" or name == "false" or name == "null" then
			t15:reportError(("Enum type %s cannot include value: %s."):format(p19.name, name), v.astNode)
		end
	end
end
function validateInputFields(t16: {[any]: any}, p20) -- line: 646
	-- upvalues: getAllNodes (ref), validateName (ref), isInputType (copy), inspect (copy), isRequiredInputField (copy), isNotNillish (copy), getDeprecatedDirectiveNode (ref)
	local v141 = p20:getFields():values()

	if #v141 == 0 then
		t16:reportError(("Input Object type %s must define one or more fields."):format(p20.name), getAllNodes(p20))
	end

	for _, v in ipairs(v141) do
		validateName(t16, v)

		if not isInputType(v.type) then
			t16:reportError(("The type of %s.%s must be Input Type "):format(p20.name, v.name) .. ("but got: %s."):format(inspect(v.type)), if v.astNode == nil then nil else v.astNode.type)
		end

		if isRequiredInputField(v) and isNotNillish(v.deprecationReason) then
			t16:reportError(("Required input field %s.%s cannot be deprecated."):format(p20.name, v.name), {
				getDeprecatedDirectiveNode(v.astNode),
				if v.astNode == nil then nil else v.astNode.type
			})
		end
	end
end
function createInputObjectCircularRefsValidator(t17: {[any]: any}) -- line: 688
	-- upvalues: isNonNullType (copy), isInputObjectType (copy), Array (copy)
	local t18 = {}
	local t19 = {}
	local t20 = {}

	local function detectCycleRecursive(p21) -- line: 705
		-- upvalues: t18 (copy), t20 (copy), t19 (copy), isNonNullType (copy), isInputObjectType (copy), detectCycleRecursive (copy), Array (copy), t17 (copy)
		if t18[tostring(p21.name)] then
			return
		end

		t18[tostring(p21.name)] = true
		t20[tostring(p21.name)] = #t19 + 1

		local v168 = p21:getFields():values()

		for _, v in ipairs(v168) do
			if isNonNullType(v.type) and isInputObjectType(v.type.ofType) then
				local ofType = v.type.ofType
				local v172 = t20[tostring(ofType.name)]

				table.insert(t19, v)

				if v172 == nil then
					detectCycleRecursive(ofType)
				else
					local v173 = Array.slice(t19, v172)
					local v174 = Array.join(Array.map(v173, function(p22) -- line: 733
						return p22.name
					end), ".")

					t17:reportError(("Cannot reference Input Object \"%s\" within itself through a series of non-null fields: \"%s\"."):format(ofType.name, v174), Array.map(v173, function(p23) -- line: 743
						return p23.astNode
					end))
				end

				table.remove(t19)
			end
		end

		t20[tostring(p21.name)] = nil
	end

	return detectCycleRecursive
end
function getAllNodes(t21: {[any]: any}) -- line: 767
	-- upvalues: Array (copy)
	local astNode = t21.astNode
	local extensionASTNodes = t21.extensionASTNodes

	if astNode then
		if extensionASTNodes then
			return (Array.concat({ astNode }, extensionASTNodes))
		end

		return { astNode }
	end

	if extensionASTNodes then
		return extensionASTNodes
	end

	return {}
end
function getAllSubNodes(t22: {[any]: any}, p24: ((...any) -> ...any)) -- line: 777
	-- upvalues: getAllNodes (ref), Array (copy)
	local t23 = {}

	for _, v in ipairs(getAllNodes(t22)) do
		local v157 = p24(v)

		t23 = Array.concat(t23, v157 or {})
	end

	return t23
end
function getAllImplementsInterfaceNodes(p25, p26) -- line: 793
	-- upvalues: Array (copy), getAllSubNodes (ref)
	return Array.filter(getAllSubNodes(p25, function(p27) -- line: 798
		return p27.interfaces
	end), function(p28) -- line: 801
		-- upvalues: p26 (copy)
		return p28.name.value == p26.name
	end)
end
function getUnionMemberTypeNodes(p29, s2: string) -- line: 807
	-- upvalues: Array (copy), getAllSubNodes (ref)
	return Array.filter(getAllSubNodes(p29, function(p30) -- line: 809
		return p30.types
	end), function(p31) -- line: 812
		-- upvalues: s2 (copy)
		return p31.name.value == s2
	end)
end
function getDeprecatedDirectiveNode(t24: {[any]: any}?) -- line: 818
	-- upvalues: Array (copy), GraphQLDeprecatedDirective (copy)
	if t24 ~= nil and t24.directives ~= nil then
		return Array.find(t24.directives, function(p32) -- line: 823
			-- upvalues: GraphQLDeprecatedDirective (copy)
			return p32.name.value == GraphQLDeprecatedDirective.name
		end)
	end
end

return {
	validateSchema = v48,
	assertValidSchema = function(p33) -- line: 106
		-- upvalues: v48 (copy), Error (copy), Array (copy)
		local v53 = v48(p33)

		if #v53 ~= 0 then
			error(Error.new(Array.join(Array.map(v53, function(p34) -- line: 111
				return p34.message
			end), "\n\n")))
		end
	end
}
