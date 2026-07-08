local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLSchema = GraphQL.GraphQLSchema
local isNamedType = GraphQL.isNamedType
local isDirective = GraphQL.isDirective
local getObjectTypeFromTypeMap = require(script.Parent.getObjectTypeFromTypeMap).getObjectTypeFromTypeMap
local rewireTypes = require(script.Parent.rewire).rewireTypes
local Map = LuauPolyfill.Map

function t1.addTypes(p1, p2) -- line: 61
	-- upvalues: Map (copy), Boolean (copy), isNamedType (copy), isDirective (copy), rewireTypes (copy), Object (copy), GraphQLSchema (copy), getObjectTypeFromTypeMap (copy)
	local v15 = p1:toConfig()
	local v16 = Map.new()

	for _, v18 in v15.types do
		v16:set(v18.name, v18)
	end

	local t2 = {}

	for _, v21 in v15.directives do
		t2[tostring(v21.name)] = v21
	end

	for _, v23 in p2 do
		if Boolean.toJSBoolean(isNamedType(v23)) then
			v16:set(v23.name, v23)
		elseif Boolean.toJSBoolean(isDirective(v23)) then
			t2[v23.name] = v23
		end
	end

	local v24 = rewireTypes(v16, (Object.values(t2)))
	local typeMap = v24.typeMap
	local directives = v24.directives

	return GraphQLSchema.new(Object.assign({}, v15, {
		query = getObjectTypeFromTypeMap(typeMap, p1:getQueryType()),
		mutation = getObjectTypeFromTypeMap(typeMap, p1:getMutationType()),
		subscription = getObjectTypeFromTypeMap(typeMap, p1:getSubscriptionType()),
		types = typeMap:values(),
		directives = directives
	}))
end

return t1
