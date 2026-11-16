local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)
local GraphQLSchema = GraphQL.GraphQLSchema

local isNamedType = GraphQL.isNamedType
local isDirective = GraphQL.isDirective

local getObjectTypeFromTypeMap = require(script.Parent.getObjectTypeFromTypeMap)
local getObjectTypeFromTypeMap2 = getObjectTypeFromTypeMap.getObjectTypeFromTypeMap
local rewire = require(script.Parent.rewire)
local rewireTypes = rewire.rewireTypes

local Map = LuauPolyfill.Map
return {
	addTypes = function(object, items)
		local config = object:toConfig()

		local v = Map.new()

		for _, kind in config.types do
			v:set(kind.name, kind)
		end

		local v2 = {}

		for _, directive in config.directives do
			v2[tostring(directive.name)] = directive
		end

		for _, item in items do
			if Boolean.toJSBoolean(isNamedType(item)) then
				v:set(item.name, item)
			elseif Boolean.toJSBoolean(isDirective(item)) then
				v2[item.name] = item
			end
		end

		local v3 = rewireTypes(v, (Object.values(v2)))
		local typeMap = v3.typeMap
		local directives = v3.directives

		return GraphQLSchema.new(Object.assign({}, config, {
			query = getObjectTypeFromTypeMap2(typeMap, object:getQueryType()),
			mutation = getObjectTypeFromTypeMap2(typeMap, object:getMutationType()),
			subscription = getObjectTypeFromTypeMap2(typeMap, object:getSubscriptionType()),
			types = typeMap:values(),
			directives = directives
		}))
	end
}
