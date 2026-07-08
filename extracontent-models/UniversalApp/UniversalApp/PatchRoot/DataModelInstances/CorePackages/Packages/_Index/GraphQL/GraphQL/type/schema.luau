local ParentParent = script.Parent.Parent
local luaUtils = ParentParent.luaUtils
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local isNillish = require(luaUtils.isNillish)
local isNillish2 = isNillish.isNillish
local isNotNillish = isNillish.isNotNillish

require(luaUtils.null)

local jsutils = ParentParent.jsutils
local inspect = require(jsutils.inspect).inspect
local toObjMap = require(jsutils.toObjMap).toObjMap
local devAssert = require(jsutils.devAssert).devAssert
local instanceOf = require(jsutils.instanceOf)
local isObjectLike = require(jsutils.isObjectLike).isObjectLike
local __Schema = require(script.Parent.introspection).__Schema

require(ParentParent.language.ast)
require(ParentParent.error.GraphQLError)

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
local t1 = nil
local collectReferencedTypes = nil

t1 = {}
t1.__index = t1

function t1.new(p1) -- line: 200
	-- upvalues: t1 (ref), devAssert (copy), isObjectLike (copy), Array (copy), inspect (copy), toObjMap (copy), specifiedDirectives (copy), Set (copy), collectReferencedTypes (ref), isNotNillish (copy), isDirective (copy), __Schema (copy), Map (copy), isNillish2 (copy), Error (copy), isInterfaceType (copy), isObjectType (copy)
	local self = setmetatable({}, t1)

	self.__validationErrors = nil

	if p1.assumeValid == true then
		self.__validationErrors = {}
	end

	devAssert(isObjectLike(p1), "Must provide configuration object.")
	devAssert(not p1.types or Array.isArray(p1.types), ("\"types\" must be Array if provided but got: %s."):format(inspect(p1.types)))
	devAssert(not p1.directives or Array.isArray(p1.directives), "\"directives\" must be Array if provided but got: " .. ("%s."):format(inspect(p1.directives)))
	self.description = p1.description
	self.extensions = if not p1.extensions then nil else toObjMap(p1.extensions)
	self.astNode = p1.astNode
	self.extensionASTNodes = p1.extensionASTNodes
	self._queryType = p1.query
	self._mutationType = p1.mutation
	self._subscriptionType = p1.subscription
	self._directives = p1.directives or specifiedDirectives

	local v34 = Set.new()

	for _, v in ipairs(p1.types or {}) do
		v34:add(v)
	end

	if p1.types ~= nil then
		for _, v in ipairs(p1.types) do
			v34:delete(v)
			collectReferencedTypes(v, v34)
		end
	end

	if isNotNillish(self._queryType) then
		collectReferencedTypes(self._queryType, v34)
	end

	if isNotNillish(self._mutationType) then
		collectReferencedTypes(self._mutationType, v34)
	end

	if isNotNillish(self._subscriptionType) then
		collectReferencedTypes(self._subscriptionType, v34)
	end

	for _, v in ipairs(self._directives) do
		if isDirective(v) then
			for _, v2 in ipairs(v.args) do
				collectReferencedTypes(v2.type, v34)
			end
		end
	end

	collectReferencedTypes(__Schema, v34)
	self._typeMap = Map.new()
	self._subTypeMap = Map.new()
	self._implementationsMap = Map.new()

	for _, v44 in v34 do
		if not isNillish2(v44) then
			local v45 = if typeof(v44) ~= "table" then tostring(v44) else v44.name

			devAssert(v45 and v45 ~= "", "One of the provided types for building the Schema is missing a name.")

			if self._typeMap:has(v45) then
				error(Error.new(("Schema must contain uniquely named types but contains multiple types named \"%s\"."):format(v45)))
			end

			self._typeMap:set(v45, v44)

			if isInterfaceType(v44) then
				for _, v in ipairs(v44:getInterfaces()) do
					if isInterfaceType(v) then
						local v48 = self._implementationsMap:get(v.name)

						if v48 == nil then
							v48 = {
								objects = {},
								interfaces = {}
							}
							self._implementationsMap:set(v.name, v48)
						end

						table.insert(v48.interfaces, v44)
					end
				end
			elseif isObjectType(v44) then
				for _, v in ipairs(v44:getInterfaces()) do
					if isInterfaceType(v) then
						local v51 = self._implementationsMap:get(v.name)

						if v51 == nil then
							v51 = {
								objects = {},
								interfaces = {}
							}
							self._implementationsMap:set(v.name, v51)
						end

						table.insert(v51.objects, v44)
					end
				end
			end
		end
	end

	return self
end
function t1.getQueryType(p2) -- line: 349
	return p2._queryType
end
function t1.getMutationType(p3) -- line: 353
	return p3._mutationType
end
function t1.getSubscriptionType(p4) -- line: 357
	return p4._subscriptionType
end
function t1.getTypeMap(p5) -- line: 361
	return p5._typeMap
end
function t1.getType(t2: {[any]: any}, s1: string) -- line: 365
	return t2:getTypeMap()[s1]
end
function t1.getPossibleTypes(p6, p7) -- line: 369
	-- upvalues: isUnionType (copy)
	if isUnionType(p7) then
		return p7:getTypes()
	end

	return p6:getImplementations(p7).objects
end
function t1.getImplementations(p8, p9) -- line: 378
	return p8._implementationsMap:get(p9.name) or {
		objects = {},
		interfaces = {}
	}
end
function t1.isSubType(p10, p11, p12) -- line: 388
	-- upvalues: isUnionType (copy)
	local v65 = p10._subTypeMap[p11.name]

	if v65 == nil then
		v65 = {}

		if isUnionType(p11) then
			for _, v in ipairs(p11:getTypes()) do
				v65[v.name] = true
			end
		else
			local v68 = p10:getImplementations(p11)

			for _, v in ipairs(v68.objects) do
				v65[v.name] = true
			end

			for _, v in ipairs(v68.interfaces) do
				v65[v.name] = true
			end
		end

		p10._subTypeMap:set(p11.name, v65)
	end

	return v65[p12.name] ~= nil
end
function t1.getDirectives(p13) -- line: 417
	return p13._directives
end
function t1.getDirective(p14, p15) -- line: 421
	-- upvalues: Array (copy)
	return Array.find(p14:getDirectives(), function(p16) -- line: 422
		-- upvalues: p15 (copy)
		return p16.name == p15
	end)
end
function t1.toConfig(p17) -- line: 427
	-- upvalues: Array (copy)
	return {
		description = p17.description,
		query = p17:getQueryType(),
		mutation = p17:getMutationType(),
		subscription = p17:getSubscriptionType(),
		types = p17:getTypeMap():values(),
		directives = Array.slice(p17:getDirectives()),
		extensions = p17.extensions,
		astNode = p17.astNode,
		extensionASTNodes = p17.extensionASTNodes or {},
		assumeValid = p17.__validationErrors ~= nil
	}
end
function t1.__tostring(_) -- line: 443
	return "GraphQLSchema"
end
function collectReferencedTypes(p19, p20) -- line: 485
	-- upvalues: getNamedType (copy), isUnionType (copy), collectReferencedTypes (ref), isObjectType (copy), isInterfaceType (copy), isInputObjectType (copy)
	local v80 = getNamedType(p19)

	if not p20:has(v80) then
		p20:add(v80)

		if isUnionType(v80) then
			for _, v in ipairs(v80:getTypes()) do
				collectReferencedTypes(v, p20)
			end

			return p20
		end

		if isObjectType(v80) or isInterfaceType(v80) then
			for _, v in ipairs(v80:getInterfaces()) do
				collectReferencedTypes(v, p20)
			end

			for _, v in ipairs(v80:getFields():values()) do
				collectReferencedTypes(v.type, p20)

				for _, v3 in ipairs(v.args) do
					collectReferencedTypes(v3.type, p20)
				end
			end

			return p20
		end

		if isInputObjectType(v80) then
			for _, v in ipairs(v80:getFields():values()) do
				collectReferencedTypes(v.type, p20)
			end
		end
	end

	return p20
end

return {
	isSchema = function(p21) -- line: 74
		-- upvalues: instanceOf (copy), t1 (ref)
		return instanceOf(p21, t1)
	end,
	assertSchema = function(p22) -- line: 78
		-- upvalues: instanceOf (copy), t1 (ref), Error (copy), inspect (copy)
		if not instanceOf(p22, t1) then
			error(Error.new(("Expected %s to be a GraphQL schema."):format(inspect(p22))))
		end

		return p22
	end,
	GraphQLSchema = t1
}
