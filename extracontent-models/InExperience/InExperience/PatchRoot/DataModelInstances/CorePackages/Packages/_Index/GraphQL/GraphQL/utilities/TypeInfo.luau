local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local luaUtils = parent.luaUtils
local null = require(luaUtils.null)

local language = parent.language
local kind = parent.type

local visitor = require(language.visitor)
local ast = require(language.ast)

local kinds = require(language.kinds)
local kind2 = kinds.Kind
local isNode = ast.isNode
local getVisitFn = visitor.getVisitFn

require(kind.schema)

require(kind.directives)

local definition = require(kind.definition)

local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isCompositeType = definition.isCompositeType
local isInputType = definition.isInputType
local isOutputType = definition.isOutputType
local getNullableType = definition.getNullableType
local getNamedType = definition.getNamedType
local introspection = require(kind.introspection)
local schemaMetaFieldDef = introspection.SchemaMetaFieldDef
local typeMetaFieldDef = introspection.TypeMetaFieldDef
local typeNameMetaFieldDef = introspection.TypeNameMetaFieldDef

local typeFromAST = require(parent.utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST

local function unwrapNull(p) -- 6 equivalent calls inferred from this helper
	return if p ~= null then p else nil
end

local typeInfo = {}
local v = { __index = typeInfo }

local getFieldDef

function typeInfo.new(schema, callback, p)
	local self = setmetatable({}, v)
	self._schema = schema
	self._typeStack = {}
	self._parentTypeStack = {}
	self._inputTypeStack = {}
	self._fieldDefStack = {}
	self._defaultValueStack = {}
	self._directive = nil
	self._argument = nil
	self._enumValue = nil
	self._getFieldDef = callback or getFieldDef

	if not p then
		return self
	end

	if isInputType(p) then
		table.insert(self._inputTypeStack, p)
	end

	if isCompositeType(p) then
		table.insert(self._parentTypeStack, p)
	end

	if isOutputType(p) then
		table.insert(self._typeStack, p)
	end

	return self
end

function typeInfo:getType()
	if not (#self._typeStack > 0) then
		return nil
	end

	return unwrapNull(self._typeStack[#self._typeStack]) -- inferred equivalent call
end

function typeInfo:getParentType()
	if not (#self._parentTypeStack > 0) then
		return nil
	end

	return unwrapNull(self._parentTypeStack[#self._parentTypeStack]) -- inferred equivalent call
end

function typeInfo:getInputType()
	if not (#self._inputTypeStack > 0) then
		return nil
	end

	return unwrapNull(self._inputTypeStack[#self._inputTypeStack]) -- inferred equivalent call
end

function typeInfo:getParentInputType()
	if not (#self._inputTypeStack > 1) then
		return nil
	end

	return unwrapNull(self._inputTypeStack[#self._inputTypeStack - 1]) -- inferred equivalent call
end

function typeInfo:getFieldDef()
	if not (#self._fieldDefStack > 0) then
		return nil
	end

	return unwrapNull(self._fieldDefStack[#self._fieldDefStack]) -- inferred equivalent call
end

function typeInfo:getDefaultValue()
	if not (#self._defaultValueStack > 0) then
		return nil
	end

	return unwrapNull(self._defaultValueStack[#self._defaultValueStack]) -- inferred equivalent call
end

function typeInfo:getDirective()
	return self._directive
end

function typeInfo:getArgument()
	return self._argument
end

function typeInfo:getEnumValue()
	return self._enumValue
end

function typeInfo:enter(data)
	local schema = self._schema

	local kind3 = data.kind

	if kind3 == kind2.SELECTION_SET then
		local v2 = getNamedType(self:getType())
		local parentTypeStack = self._parentTypeStack

		if not isCompositeType(v2) then
			v2 = null
		end

		table.insert(parentTypeStack, v2)
	elseif kind3 == kind2.FIELD then
		local parentType = self:getParentType()

		local v2 = nil
		local v3

		if parentType then
			v3 = self._getFieldDef(schema, parentType, data)

			if v3 then
				v2 = v3.type
			end
		end

		table.insert(self._fieldDefStack, v3 or null)

		local typeStack = self._typeStack

		if not isOutputType(v2) then
			v2 = null
		end

		table.insert(typeStack, v2)
	elseif kind3 == kind2.DIRECTIVE then
		self._directive = schema:getDirective(data.name.value)
	elseif kind3 == kind2.OPERATION_DEFINITION then
		local v2 = nil
		local operation = data.operation

		if operation == "query" then
			v2 = schema:getQueryType()
		elseif operation == "mutation" then
			v2 = schema:getMutationType()
		elseif operation == "subscription" then
			v2 = schema:getSubscriptionType()
		end

		local typeStack = self._typeStack

		if not isObjectType(v2) then
			v2 = null
		end

		table.insert(typeStack, v2)
	elseif kind3 == kind2.INLINE_FRAGMENT or kind3 == kind2.FRAGMENT_DEFINITION then
		local typeCondition = data.typeCondition
		local v2

		if typeCondition then
			v2 = typeFromAST2(schema, typeCondition)
		else
			v2 = getNamedType(self:getType())
		end

		local typeStack = self._typeStack

		if not isOutputType(v2) then
			v2 = null
		end

		table.insert(typeStack, v2)
	elseif kind3 == kind2.VARIABLE_DEFINITION then
		local v2 = typeFromAST2(schema, data.type)

		local inputTypeStack = self._inputTypeStack

		if not isInputType(v2) then
			v2 = null
		end

		table.insert(inputTypeStack, v2)
	elseif kind3 == kind2.ARGUMENT then
		local v2 = nil
		local v3 = self:getDirective() or self:getFieldDef()
		local argument

		if v3 then
			argument = Array.find(v3.args, function(p): boolean
				return p.name == data.name.value
			end)

			if argument then
				v2 = argument.type
			end
		end

		self._argument = argument
		local defaultValueStack = self._defaultValueStack
		local v4

		if argument then
			v4 = argument.defaultValue
		else
			v4 = null
		end

		table.insert(defaultValueStack, v4)
		local inputTypeStack = self._inputTypeStack

		if not isInputType(v2) then
			v2 = null
		end

		table.insert(inputTypeStack, v2)
	elseif kind3 == kind2.LIST then
		local v2 = getNullableType(self:getInputType())

		if isListType(v2) then
			v2 = v2.ofType
		end

		table.insert(self._defaultValueStack, null)
		local inputTypeStack = self._inputTypeStack

		if not isInputType(v2) then
			v2 = null
		end

		table.insert(inputTypeStack, v2)
	elseif kind3 == kind2.OBJECT_FIELD then
		local namedType = getNamedType(self:getInputType())
		local v2 = nil
		local v3

		if isInputObjectType(namedType) then
			v3 = namedType:getFields():get(data.name.value)

			if v3 then
				v2 = v3.type
			end
		end

		local defaultValueStack = self._defaultValueStack
		local v4

		if v3 then
			v4 = v3.defaultValue
		else
			v4 = null
		end

		table.insert(defaultValueStack, v4)

		local inputTypeStack = self._inputTypeStack

		if not isInputType(v2) then
			v2 = null
		end

		table.insert(inputTypeStack, v2)
	else
		if kind3 ~= kind2.ENUM then
			return
		end

		local namedType = getNamedType(self:getInputType())
		local enumValue

		if isEnumType(namedType) then
			enumValue = namedType:getValue(data.value)
		end

		self._enumValue = enumValue
	end
end

function typeInfo:leave(p)
	local kind3 = p.kind

	if kind3 == kind2.SELECTION_SET then
		table.remove(self._parentTypeStack)
	elseif kind3 == kind2.FIELD then
		table.remove(self._fieldDefStack)
		table.remove(self._typeStack)
	elseif kind3 == kind2.DIRECTIVE then
		self._directive = nil
	elseif
		kind3 == kind2.OPERATION_DEFINITION
		or kind3 == kind2.INLINE_FRAGMENT
		or kind3 == kind2.FRAGMENT_DEFINITION
	then
		table.remove(self._typeStack)
	elseif kind3 == kind2.VARIABLE_DEFINITION then
		table.remove(self._inputTypeStack)
	elseif kind3 == kind2.ARGUMENT then
		self._argument = nil
		table.remove(self._defaultValueStack)
		table.remove(self._inputTypeStack)
	elseif kind3 == kind2.LIST or kind3 == kind2.OBJECT_FIELD then
		table.remove(self._defaultValueStack)
		table.remove(self._inputTypeStack)
	elseif kind3 == kind2.ENUM then
		self._enumValue = nil
	end
end

getFieldDef = function(object, object2, p)
	local value = p.name.value

	if value == schemaMetaFieldDef.name and object:getQueryType() == object2 then
		return schemaMetaFieldDef
	end

	if value == typeMetaFieldDef.name and object:getQueryType() == object2 then
		return typeMetaFieldDef
	end

	if value == typeNameMetaFieldDef.name and isCompositeType(object2) then
		return typeNameMetaFieldDef
	end

	if isObjectType(object2) or isInterfaceType(object2) then
		return object2:getFields():get(value)
	end

	return nil
end

return {
	TypeInfo = typeInfo,
	visitWithTypeInfo = function(object, p)
		return {
			enter = function(self, p2, ...)
				object:enter(p2)
				local visitFn = getVisitFn(p, p2.kind, false)

				if not visitFn then
					return nil
				end

				local v2 = visitFn(p, p2, ...)

				if v2 ~= nil then
					object:leave(p2)

					if isNode(v2) then
						object:enter(v2)
					end
				end

				return v2
			end,
			leave = function(self, p2, ...)
				local visitFn = getVisitFn(p, p2.kind, true)
				local v2

				if visitFn then
					v2 = visitFn(p, p2, ...)
				end

				object:leave(p2)
				return v2
			end
		}
	end
}
