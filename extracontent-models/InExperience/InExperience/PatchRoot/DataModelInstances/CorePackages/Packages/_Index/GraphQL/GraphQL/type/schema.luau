local parent = script.Parent.Parent
local luaUtils = parent.luaUtils

local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set

local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish
require(luaUtils.null)

local jsutils = parent.jsutils
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local toObjMap = require(jsutils.toObjMap)
local toObjMap2 = toObjMap.toObjMap
local devAssert = require(jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local instanceOf = require(jsutils.instanceOf)
local isObjectLike = require(jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike

local introspection = require(script.Parent.introspection)
local __schema = introspection.__Schema

require(parent.language.ast)

require(parent.error.GraphQLError)

local directives = require(script.Parent.directives)

local isDirective = directives.isDirective
local specifiedDirectives = directives.specifiedDirectives

require(jsutils.ObjMap)

local definition = require(script.Parent.definition)

local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isInputObjectType = definition.isInputObjectType
local getNamedType = definition.getNamedType

local class = nil
local collectReferencedTypes

local function isSchema(p) -- 1 equivalent call inferred from this helper
	return instanceOf(p, class)
end

local function assertSchema(p)
	if not isSchema(p) then -- inferred equivalent call
		error(Error.new(("Expected %s to be a GraphQL schema."):format(inspect2(p))))
	end

	return p
end

class = {}
class.__index = class

function class.new(data)
	local object = setmetatable({}, class)

	object.__validationErrors = nil

	if data.assumeValid == true then
		object.__validationErrors = {}
	end

	devAssert2(isObjectLike2(data), "Must provide configuration object.")
	devAssert2(
		not data.types or Array.isArray(data.types),
		("\"types\" must be Array if provided but got: %s."):format(inspect2(data.types))
	)

	devAssert2(
		not data.directives or Array.isArray(data.directives),
		"\"directives\" must be Array if provided but got: " .. ("%s."):format(inspect2(data.directives))
	)

	object.description = data.description
	local extensions

	if data.extensions then
		extensions = toObjMap2(data.extensions)
	end

	object.extensions = extensions
	object.astNode = data.astNode
	object.extensionASTNodes = data.extensionASTNodes

	object._queryType = data.query
	object._mutationType = data.mutation
	object._subscriptionType = data.subscription

	object._directives = data.directives or specifiedDirectives

	local v = Set.new()

	for _, v2 in ipairs(data.types or {}) do
		v:add(v2)
	end

	if data.types ~= nil then
		for _, kind in ipairs(data.types) do
			v:delete(kind)
			collectReferencedTypes(kind, v)
		end
	end

	if isNotNillish(object._queryType) then
		collectReferencedTypes(object._queryType, v)
	end

	if isNotNillish(object._mutationType) then
		collectReferencedTypes(object._mutationType, v)
	end

	if isNotNillish(object._subscriptionType) then
		collectReferencedTypes(object._subscriptionType, v)
	end

	for _, directive in ipairs(object._directives) do
		if not isDirective(directive) then
			continue
		end

		for _, arg in ipairs(directive.args) do
			collectReferencedTypes(arg.type, v)
		end
	end

	collectReferencedTypes(__schema, v)

	object._typeMap = Map.new()
	object._subTypeMap = Map.new()

	object._implementationsMap = Map.new()

	for _, v2 in v do
		if isNillish2(v2) then
			continue
		end

		local v3

		if typeof(v2) == "table" then
			v3 = v2.name
		else
			v3 = tostring(v2)
		end

		devAssert2(v3 and v3 ~= "", "One of the provided types for building the Schema is missing a name.")

		if object._typeMap:has(v3) then
			error(Error.new(("Schema must contain uniquely named types but contains multiple types named \"%s\"."):format(v3)))
		end

		object._typeMap:set(v3, v2)

		if isInterfaceType(v2) then
			for _, v4 in ipairs(v2:getInterfaces()) do
				if not isInterfaceType(v4) then
					continue
				end

				local v5 = object._implementationsMap:get(v4.name)

				if v5 == nil then
					v5 = { objects = {}, interfaces = {} }

					object._implementationsMap:set(v4.name, v5)
				end

				table.insert(v5.interfaces, v2)
			end
		elseif isObjectType(v2) then
			for _, v4 in ipairs(v2:getInterfaces()) do
				if not isInterfaceType(v4) then
					continue
				end

				local v5 = object._implementationsMap:get(v4.name)

				if v5 == nil then
					v5 = { objects = {}, interfaces = {} }

					object._implementationsMap:set(v4.name, v5)
				end

				table.insert(v5.objects, v2)
			end
		end
	end

	return object
end

function class:getQueryType()
	return self._queryType
end

function class:getMutationType()
	return self._mutationType
end

function class:getSubscriptionType()
	return self._subscriptionType
end

function class:getTypeMap()
	return self._typeMap
end

function class:getType(p: string)
	return self:getTypeMap()[p]
end

function class:getPossibleTypes(object)
	if isUnionType(object) then
		return object:getTypes()
	end

	return self:getImplementations(object).objects
end

function class:getImplementations(p)
	return self._implementationsMap:get(p.name) or { objects = {}, interfaces = {} }
end

function class:isSubType(object, p): boolean
	local v = self._subTypeMap[object.name]

	if v ~= nil then
		return v[p.name] ~= nil
	end

	v = {}

	if isUnionType(object) then
		for _, v2 in ipairs(object:getTypes()) do
			v[v2.name] = true
		end
	else
		local implementations = self:getImplementations(object)

		for _, object2 in ipairs(implementations.objects) do
			v[object2.name] = true
		end

		for _, interface in ipairs(implementations.interfaces) do
			v[interface.name] = true
		end
	end

	self._subTypeMap:set(object.name, v)

	return v[p.name] ~= nil
end

function class:getDirectives()
	return self._directives
end

function class:getDirective(p)
	return Array.find(self:getDirectives(), function(p2): boolean
		return p2.name == p
	end)
end

function class:toConfig()
	return {
		description = self.description,
		query = self:getQueryType(),
		mutation = self:getMutationType(),
		subscription = self:getSubscriptionType(),
		types = self:getTypeMap():values(),
		directives = Array.slice(self:getDirectives()),
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
		assumeValid = self.__validationErrors ~= nil
	}
end

function class.__tostring(_): string
	return "GraphQLSchema"
end

collectReferencedTypes = function(p, object)
	local namedType = getNamedType(p)

	if object:has(namedType) then
		return object
	end

	object:add(namedType)

	if isUnionType(namedType) then
		for _, v in ipairs(namedType:getTypes()) do
			collectReferencedTypes(v, object)
		end

		return object
	elseif isObjectType(namedType) or isInterfaceType(namedType) then
		for _, v in ipairs(namedType:getInterfaces()) do
			collectReferencedTypes(v, object)
		end

		for _, v in ipairs(namedType:getFields():values()) do
			collectReferencedTypes(v.type, object)

			for _, arg in ipairs(v.args) do
				collectReferencedTypes(arg.type, object)
			end
		end

		return object
	elseif isInputObjectType(namedType) then
		for _, v in ipairs(namedType:getFields():values()) do
			collectReferencedTypes(v.type, object)
		end
	end

	return object
end

return { isSchema = isSchema, assertSchema = assertSchema, GraphQLSchema = class }
