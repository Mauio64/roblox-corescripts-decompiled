local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local isNillish = require(parent.luaUtils.isNillish)
local isNotNillish = isNillish.isNotNillish

local inspect = require(script.Parent.Parent.jsutils.inspect)
local inspect2 = inspect.inspect
local GraphQLError = require(script.Parent.Parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local err = require(script.Parent.Parent.error)
local locatedError = err.locatedError

require(parent.language.ast)

local assertValidName = require(parent.utilities.assertValidName)
local isValidNameError = assertValidName.isValidNameError
local typeComparators = require(script.Parent.Parent.utilities.typeComparators)
local isEqualType = typeComparators.isEqualType
local isTypeSubTypeOf = typeComparators.isTypeSubTypeOf
local schema = require(script.Parent.schema)
local assertSchema = schema.assertSchema

local definition = require(script.Parent.definition)

local introspection = require(script.Parent.introspection)
local isIntrospectionType = introspection.isIntrospectionType
local directives = require(script.Parent.directives)
local isDirective = directives.isDirective
local graphQLDeprecatedDirective = directives.GraphQLDeprecatedDirective
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

local class = nil
local validateRootTypes
local validateDirectives
local getOperationTypeNode
local getAllSubNodes
local getAllNodes
local getAllImplementsInterfaceNodes
local getDeprecatedDirectiveNode
local getUnionMemberTypeNodes
local validateEnumValues
local validateName
local validateFields
local validateTypeImplementsAncestors
local validateTypes
local validateTypeImplementsInterface
local validateInterfaces

local function fn(p)
	assertSchema(p)

	if p.__validationErrors ~= nil then
		return p.__validationErrors
	end

	local v = class.new(p)
	validateRootTypes(v)
	validateDirectives(v)
	validateTypes(v)

	local errors = v:getErrors()

	p.__validationErrors = errors

	return errors
end

class = {}
class.__index = class

function class.new(schema2)
	local self = setmetatable({}, class)

	self._errors = {}
	self.schema = schema2

	return self
end

function class:reportError(p: string, p2)
	if Array.isArray(p2) then
		p2 = Array.filter(p2, Boolean.toJSBoolean)
	end

	self:addError(graphQLError.new(p, p2))
end

function class:addError(p)
	table.insert(self._errors, p)
end

function class:getErrors()
	return self._errors
end

validateRootTypes = function(object)
	local schema2 = object.schema
	local queryType = schema2:getQueryType()

	if isNotNillish(queryType) then
		if not isObjectType(queryType) then
			local v = getOperationTypeNode(schema2, "query")
			object:reportError(
				("Query root type must be Object type, it cannot be %s."):format(inspect2(queryType)),
				v or queryType.astNode
			)
		end
	else
		object:reportError("Query root type must be provided.", schema2.astNode)
	end

	local mutationType = schema2:getMutationType()

	if isNotNillish(mutationType) and not isObjectType(mutationType) then
		local v = getOperationTypeNode(schema2, "mutation")
		object:reportError(
			"Mutation root type must be Object type if provided, it cannot be " .. ("%s."):format(inspect2(mutationType)),
			v or mutationType.astNode
		)
	end

	local subscriptionType = schema2:getSubscriptionType()

	if isNotNillish(subscriptionType) and not isObjectType(subscriptionType) then
		local v = getOperationTypeNode(schema2, "subscription")
		object:reportError(
			"Subscription root type must be Object type if provided, it cannot be " .. ("%s."):format(inspect2(subscriptionType)),
			v or subscriptionType.astNode
		)
	end
end
getOperationTypeNode = function(schema2, p)
	local v = getAllSubNodes(schema2, function(p2)
		return p2.operationTypes
	end)

	for _, v2 in ipairs(v) do
		if v2.operation == p then
			return v2.type
		end
	end

	return nil
end

validateDirectives = function(object)
	for _, v in ipairs(object.schema:getDirectives()) do
		if isDirective(v) then
			validateName(object, v)

			for _, arg in ipairs(v.args) do
				validateName(object, arg)

				if not isInputType(arg.type) then
					object:reportError(
						("The type of @%s(%s:) must be Input Type "):format(v.name, arg.name) .. ("but got: %s."):format(inspect2(arg.type)),
						arg.astNode
					)
				end

				if not (isRequiredArgument(arg) and isNotNillish(arg.deprecationReason)) then
					continue
				end

				local formatted = ("Required argument @%s(%s:) cannot be deprecated."):format(v.name, arg.name)

				local v2 = getDeprecatedDirectiveNode(arg.astNode)
				local v3

				if arg.astNode ~= nil then
					v3 = arg.astNode.type
				end

				object:reportError(formatted, { v2, v3 })
			end
		else
			local formatted = ("Expected directive but got: %s."):format(inspect2(v))
			local v2

			if v then
				v2 = v.astNode
			end

			object:reportError(formatted, v2)
		end
	end
end
validateName = function(object, p)
	local astNode = nil
	local v

	if typeof(p) == "table" then
		v = p.name
		astNode = p.astNode
	else
		v = tostring(p)
	end

	local validNameError = isValidNameError(v)

	if validNameError then
		object:addError(locatedError(validNameError, astNode))
	end
end

validateTypes = function(object)
	local inputObjectCircularRefsValidator = createInputObjectCircularRefsValidator(object)
	local typeMap = object.schema:getTypeMap()

	for _, v in ipairs(typeMap:values()) do
		local astNode

		if typeof(v) == "table" then
			astNode = v.astNode
		end

		if isNamedType(v) then
			if not isIntrospectionType(v) then
				validateName(object, v)
			end

			if isObjectType(v) then
				validateFields(object, v)

				validateInterfaces(object, v)
			elseif isInterfaceType(v) then
				validateFields(object, v)

				validateInterfaces(object, v)
			elseif isUnionType(v) then
				validateUnionMembers(object, v)
			elseif isEnumType(v) then
				validateEnumValues(object, v)
			elseif isInputObjectType(v) then
				validateInputFields(object, v)

				inputObjectCircularRefsValidator(v)
			end
		else
			object:reportError(("Expected GraphQL named type but got: %s."):format(inspect2(v)), astNode)
		end
	end
end

validateFields = function(object, object2)
	local values = object2:getFields():values()

	if #values == 0 then
		object:reportError(("Type %s must define one or more fields."):format(object2.name), getAllNodes(object2))
	end

	for _, value in ipairs(values) do
		validateName(object, value)

		if not isOutputType(value.type) then
			local v = ("The type of %s.%s must be Output Type "):format(object2.name, value.name) .. ("but got: %s."):format(inspect2(value.type))
			local v2

			if value.astNode ~= nil then
				v2 = value.astNode.type
			end

			object:reportError(v, v2)
		end

		for _, arg in ipairs(value.args) do
			local name = arg.name

			validateName(object, arg)

			if not isInputType(arg.type) then
				local v = ("The type of %s.%s(%s:) must be Input "):format(object2.name, value.name, name) .. ("Type but got: %s."):format(inspect2(arg.type))
				local v2

				if arg.astNode ~= nil then
					v2 = arg.astNode.type
				end

				object:reportError(v, v2)
			end

			if not (isRequiredArgument(arg) and isNotNillish(arg.deprecationReason)) then
				continue
			end

			local formatted = ("Required argument %s.%s(%s:) cannot be deprecated."):format(
				object2.name,
				value.name,
				name
			)

			local v = getDeprecatedDirectiveNode(arg.astNode)
			local v2

			if arg.astNode ~= nil then
				v2 = arg.astNode.type
			end

			object:reportError(formatted, { v, v2 })
		end
	end
end
validateInterfaces = function(object, object2)
	local set = {}

	for _, v in ipairs(object2:getInterfaces()) do
		if isInterfaceType(v) then
			if object2 == v then
				object:reportError(
					("Type %s cannot implement itself because it would create a circular reference."):format(object2.name),
					getAllImplementsInterfaceNodes(object2, v)
				)
			else
				local v2

				if (typeof)(nil) == "table" then
					v2 = tostring(v.name)
				else
					v2 = tostring(v)
				end

				if set[v2] then
					object:reportError(
						("Type %s can only implement %s once."):format(object2.name, v.name),
						getAllImplementsInterfaceNodes(object2, v)
					)
				else
					set[v2] = true

					validateTypeImplementsAncestors(object, object2, v)
					validateTypeImplementsInterface(object, object2, v)
				end
			end
		else
			object:reportError(
				("Type %s must only implement Interface types, "):format(inspect2(object2)) .. ("it cannot implement %s."):format(inspect2(v)),
				getAllImplementsInterfaceNodes(object2, v)
			)
		end
	end
end
validateTypeImplementsInterface = function(object, object2, object3)
	local fields = object2:getFields()

	for _, v in ipairs(object3:getFields():values()) do
		local name = v.name

		local v2 = fields:get(name)

		if v2 then
			if not isTypeSubTypeOf(object.schema, v2.type, v.type) then
				local v3 = ("Interface field %s.%s expects type "):format(object3.name, name) .. ("%s but %s.%s "):format(
					inspect2(v.type),
					object2.name,
					name
				) .. ("is type %s."):format(inspect2(v2.type))
				local kind

				if v.astNode ~= nil then
					kind = v.astNode.type
				end

				local v4

				if v2.astNode ~= nil then
					v4 = v2.astNode.type
				end

				object:reportError(v3, { kind, v4 })
			end

			for _, arg in ipairs(v.args) do
				local name2 = arg.name
				local v3 = Array.find(v2.args, function(p): boolean
					return p.name == name2
				end)

				if v3 then
					if not isEqualType(arg.type, v3.type) then
						local v4 = ("Interface field argument %s.%s(%s:) "):format(object3.name, name, name2) .. ("expects type %s but "):format(inspect2(arg.type)) .. ("%s.%s(%s:) is type "):format(object2.name, name, name2) .. ("%s."):format(inspect2(v3.type))
						local kind

						if arg.astNode ~= nil then
							kind = arg.astNode.type
						end

						local v5

						if v3.astNode ~= nil then
							v5 = v3.astNode.type
						end

						object:reportError(v4, { kind, v5 })
					end
				else
					object:reportError(
						("Interface field argument %s.%s(%s:) expected but %s.%s does not provide it."):format(
							object3.name,
							name,
							name2,
							object2.name,
							name
						),
						{ arg.astNode, v2.astNode }
					)
				end
			end

			for _, arg in ipairs(v2.args) do
				local name2 = arg.name

				if Array.find(v.args, function(p): boolean
					return p.name == name2
				end) then
					continue
				end

				if not isRequiredArgument(arg) then
					continue
				end

				object:reportError(
					("Object field %s.%s includes required argument %s that is missing from the Interface field %s.%s."):format(
						object2.name,
						name,
						name2,
						object3.name,
						name
					),
					{ arg.astNode, v.astNode }
				)
			end
		else
			object:reportError(
				("Interface field %s.%s expected but %s does not provide it."):format(object3.name, name, object2.name),
				Array.concat({ v.astNode }, getAllNodes(object2))
			)
		end
	end
end

validateTypeImplementsAncestors = function(object, object2, object3)
	local interfaces = object2:getInterfaces()

	for _, v in ipairs(object3:getInterfaces()) do
		if Array.indexOf(interfaces, v) ~= -1 then
			continue
		end

		local v2

		if v == object2 then
			v2 = ("Type %s cannot implement %s because it would create a circular reference."):format(
				object2.name,
				object3.name
			)
		else
			v2 = ("Type %s must implement %s because it is implemented by %s."):format(
				object2.name,
				v.name,
				object3.name
			)
		end

		object:reportError(
			v2,
			Array.concat(getAllImplementsInterfaceNodes(object3, v), getAllImplementsInterfaceNodes(object2, object3))
		)
	end
end

function validateUnionMembers(object, object2)
	local types = object2:getTypes()

	if #types == 0 then
		object:reportError(
			("Union type %s must define one or more member types."):format(object2.name),
			getAllNodes(object2)
		)
	end

	local nameSet = {}

	for _, kind in ipairs(types) do
		if nameSet[tostring(kind.name)] then
			object:reportError(
				("Union type %s can only include type %s once."):format(object2.name, kind.name),
				getUnionMemberTypeNodes(object2, kind.name)
			)
		else
			nameSet[tostring(kind.name)] = true

			if not isObjectType(kind) then
				object:reportError(
					("Union type %s can only include Object types, "):format(object2.name) .. ("it cannot include %s."):format(inspect2(kind)),
					getUnionMemberTypeNodes(object2, (tostring(kind)))
				)
			end
		end
	end
end
validateEnumValues = function(object, object2)
	local values = object2:getValues()

	if #values == 0 then
		object:reportError(("Enum type %s must define one or more values."):format(object2.name), getAllNodes(object2))
	end

	for _, value in ipairs(values) do
		local name = value.name

		validateName(object, value)

		if name == "true" or name == "false" or name == "null" then
			object:reportError(("Enum type %s cannot include value: %s."):format(object2.name, name), value.astNode)
		end
	end
end

function validateInputFields(object, object2)
	local values = object2:getFields():values()

	if #values == 0 then
		object:reportError(
			("Input Object type %s must define one or more fields."):format(object2.name),
			getAllNodes(object2)
		)
	end

	for _, value in ipairs(values) do
		validateName(object, value)

		if not isInputType(value.type) then
			local v = ("The type of %s.%s must be Input Type "):format(object2.name, value.name) .. ("but got: %s."):format(inspect2(value.type))
			local v2

			if value.astNode ~= nil then
				v2 = value.astNode.type
			end

			object:reportError(v, v2)
		end

		if not (isRequiredInputField(value) and isNotNillish(value.deprecationReason)) then
			continue
		end

		local formatted = ("Required input field %s.%s cannot be deprecated."):format(object2.name, value.name)

		local v = getDeprecatedDirectiveNode(value.astNode)
		local v2

		if value.astNode ~= nil then
			v2 = value.astNode.type
		end

		object:reportError(formatted, { v, v2 })
	end
end

function createInputObjectCircularRefsValidator(object)
	local nameSet = {}

	local v = {}

	local v2 = {}
	local function detectCycleRecursive(ofType)
		if nameSet[tostring(ofType.name)] then
			return
		end

		nameSet[tostring(ofType.name)] = true

		v2[tostring(ofType.name)] = #v + 1

		local values = ofType:getFields():values()

		for _, value in ipairs(values) do
			if not (isNonNullType(value.type) and isInputObjectType(value.type.ofType)) then
				continue
			end

			local ofType2 = value.type.ofType

			local v3 = v2[tostring(ofType2.name)]

			table.insert(v, value)

			if v3 == nil then
				detectCycleRecursive(ofType2)
			else
				local slice = Array.slice(v, v3)
				local joined = Array.join(Array.map(slice, function(p)
					return p.name
				end), ".")

				object:reportError(
					("Cannot reference Input Object \"%s\" within itself through a series of non-null fields: \"%s\"."):format(
						ofType2.name,
						joined
					),
					Array.map(slice, function(p)
						return p.astNode
					end)
				)
			end

			table.remove(v)
		end

		v2[tostring(ofType.name)] = nil
	end

	return detectCycleRecursive
end

getAllNodes = function(p)
	local astNode = p.astNode
	local extensionASTNodes = p.extensionASTNodes

	if astNode then
		if extensionASTNodes then
			return (Array.concat({ astNode }, extensionASTNodes))
		end

		return { astNode }
	end

	return extensionASTNodes or {}
end

getAllSubNodes = function(p, fn2)
	local joined = {}

	for _, v in ipairs(getAllNodes(p)) do
		local v2 = fn2(v)
		joined = Array.concat(joined, v2 or {})
	end

	return joined
end

getAllImplementsInterfaceNodes = function(object, p)
	return Array.filter(getAllSubNodes(object, function(p2)
		return p2.interfaces
	end), function(p2): boolean
		return p2.name.value == p.name
	end)
end

getUnionMemberTypeNodes = function(object, p: string)
	return Array.filter(getAllSubNodes(object, function(p2)
		return p2.types
	end), function(p2): boolean
		return p2.name.value == p
	end)
end

getDeprecatedDirectiveNode = function(astNode)
	if astNode == nil or astNode.directives == nil then
		return
	end

	return Array.find(astNode.directives, function(p): boolean
		return p.name.value == graphQLDeprecatedDirective.name
	end)
end

return {
	validateSchema = fn,
	assertValidSchema = function(p)
		local v = fn(p)

		if #v ~= 0 then
			error(Error.new(Array.join(Array.map(v, function(p2)
				return p2.message
			end), "\n\n")))
		end
	end
}
