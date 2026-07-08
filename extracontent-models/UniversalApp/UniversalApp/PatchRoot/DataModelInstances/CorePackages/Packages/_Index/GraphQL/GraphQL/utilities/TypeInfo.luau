local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local luaUtils = ParentParent.luaUtils
local null = require(luaUtils.null)
local language = ParentParent.language
local type = ParentParent.type
local visitor = require(language.visitor)
local ast = require(language.ast)
local Kind = require(language.kinds).Kind
local isNode = ast.isNode
local getVisitFn = visitor.getVisitFn

require(type.schema)
require(type.directives)

local definition = require(type.definition)
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
local introspection = require(type.introspection)
local SchemaMetaFieldDef = introspection.SchemaMetaFieldDef
local TypeMetaFieldDef = introspection.TypeMetaFieldDef
local TypeNameMetaFieldDef = introspection.TypeNameMetaFieldDef
local typeFromAST = require(ParentParent.utilities.typeFromAST).typeFromAST

local function unwrapNull(p1) -- line: 79
	-- upvalues: null (copy)
	if p1 == null then
		return nil
	end

	return p1
end

local t1 = {}
local t2 = {
	__index = t1
}
local getFieldDef = nil

function t1.new(p2, p3: ((...any) -> ...any)?, p4) -- line: 132
	-- upvalues: t2 (copy), getFieldDef (ref), isInputType (copy), isCompositeType (copy), isOutputType (copy)
	local self = setmetatable({}, t2)

	self._schema = p2
	self._typeStack = {}
	self._parentTypeStack = {}
	self._inputTypeStack = {}
	self._fieldDefStack = {}
	self._defaultValueStack = {}
	self._directive = nil
	self._argument = nil
	self._enumValue = nil
	self._getFieldDef = p3 or getFieldDef

	if p4 then
		if isInputType(p4) then
			table.insert(self._inputTypeStack, p4)
		end

		if isCompositeType(p4) then
			table.insert(self._parentTypeStack, p4)
		end

		if isOutputType(p4) then
			table.insert(self._typeStack, p4)
		end
	end

	return self
end
function t1.getType(p5) -- line: 169
	-- upvalues: null (copy)
	if #p5._typeStack > 0 then
		local v39 = p5._typeStack[#p5._typeStack]

		if v39 == null then
			return nil
		end

		return v39
	end

	return nil
end
function t1.getParentType(p6) -- line: 176
	-- upvalues: null (copy)
	if #p6._parentTypeStack > 0 then
		local v41 = p6._parentTypeStack[#p6._parentTypeStack]

		if v41 == null then
			return nil
		end

		return v41
	end

	return nil
end
function t1.getInputType(p7) -- line: 183
	-- upvalues: null (copy)
	if #p7._inputTypeStack > 0 then
		local v43 = p7._inputTypeStack[#p7._inputTypeStack]

		if v43 == null then
			return nil
		end

		return v43
	end

	return nil
end
function t1.getParentInputType(p8) -- line: 190
	-- upvalues: null (copy)
	if #p8._inputTypeStack > 1 then
		local v45 = p8._inputTypeStack[#p8._inputTypeStack - 1]

		if v45 == null then
			return nil
		end

		return v45
	end

	return nil
end
function t1.getFieldDef(p9) -- line: 197
	-- upvalues: null (copy)
	if #p9._fieldDefStack > 0 then
		local v47 = p9._fieldDefStack[#p9._fieldDefStack]

		if v47 == null then
			return nil
		end

		return v47
	end

	return nil
end
function t1.getDefaultValue(p10) -- line: 204
	-- upvalues: null (copy)
	if #p10._defaultValueStack > 0 then
		local v49 = p10._defaultValueStack[#p10._defaultValueStack]

		if v49 == null then
			return nil
		end

		return v49
	end

	return nil
end
function t1.getDirective(p11) -- line: 211
	return p11._directive
end
function t1.getArgument(p12) -- line: 215
	return p12._argument
end
function t1.getEnumValue(p13) -- line: 219
	return p13._enumValue
end
function t1.enter(p14, p15) -- line: 223
	-- upvalues: Kind (copy), getNamedType (copy), isCompositeType (copy), null (copy), isOutputType (copy), isObjectType (copy), typeFromAST (copy), isInputType (copy), Array (copy), getNullableType (copy), isListType (copy), isInputObjectType (copy), isEnumType (copy)
	local _schema = p14._schema
	local kind = p15.kind

	if kind == Kind.SELECTION_SET then
		local v57 = getNamedType(p14:getType())

		table.insert(p14._parentTypeStack, if not isCompositeType(v57) then null else v57)

		return
	end

	if kind == Kind.FIELD then
		local v58 = p14:getParentType()
		local v59 = nil
		local type2 = nil

		if v58 then
			v59 = p14._getFieldDef(_schema, v58, p15)

			if v59 then
				type2 = v59.type
			end
		end

		table.insert(p14._fieldDefStack, v59 or null)
		table.insert(p14._typeStack, if not isOutputType(type2) then null else type2)

		return
	end

	if kind == Kind.DIRECTIVE then
		p14._directive = _schema:getDirective(p15.name.value)

		return
	end

	if kind == Kind.OPERATION_DEFINITION then
		local v61 = nil
		local operation = p15.operation

		if operation == "query" then
			v61 = _schema:getQueryType()
		elseif operation == "mutation" then
			v61 = _schema:getMutationType()
		elseif operation == "subscription" then
			v61 = _schema:getSubscriptionType()
		end

		table.insert(p14._typeStack, if not isObjectType(v61) then null else v61)

		return
	end

	if kind == Kind.INLINE_FRAGMENT or kind == Kind.FRAGMENT_DEFINITION then
		local typeCondition = p15.typeCondition
		local v64 = if not typeCondition then getNamedType(p14:getType()) else typeFromAST(_schema, typeCondition)

		table.insert(p14._typeStack, if not isOutputType(v64) then null else v64)

		return
	end

	if kind == Kind.VARIABLE_DEFINITION then
		local v65 = typeFromAST(_schema, p15.type)

		table.insert(p14._inputTypeStack, if not isInputType(v65) then null else v65)

		return
	end

	if kind == Kind.ARGUMENT then
		local v66 = nil
		local type3 = nil
		local v68 = p14:getDirective() or p14:getFieldDef()

		if v68 then
			v66 = Array.find(v68.args, function(p16) -- line: 297
				-- upvalues: p15 (copy)
				return p16.name == p15.name.value
			end)

			if v66 then
				type3 = v66.type
			end
		end

		p14._argument = v66
		table.insert(p14._defaultValueStack, if not v66 then null else v66.defaultValue)
		table.insert(p14._inputTypeStack, if not isInputType(type3) then null else type3)

		return
	end

	if kind == Kind.LIST then
		local v69 = getNullableType(p14:getInputType())
		local v70 = if not isListType(v69) then v69 else v69.ofType

		table.insert(p14._defaultValueStack, null)
		table.insert(p14._inputTypeStack, if not isInputType(v70) then null else v70)

		return
	end

	if kind == Kind.OBJECT_FIELD then
		local v71 = getNamedType(p14:getInputType())
		local type4 = nil
		local v73 = nil

		if isInputObjectType(v71) then
			v73 = v71:getFields():get(p15.name.value)

			if v73 then
				type4 = v73.type
			end
		end

		table.insert(p14._defaultValueStack, if not v73 then null else v73.defaultValue)
		table.insert(p14._inputTypeStack, if not isInputType(type4) then null else type4)

		return
	end

	if kind == Kind.ENUM then
		local v74 = getNamedType(p14:getInputType())
		local v75 = nil

		if isEnumType(v74) then
			v75 = v74:getValue(p15.value)
		end

		p14._enumValue = v75

		return
	end
end
function t1.leave(p17, p18) -- line: 343
	-- upvalues: Kind (copy)
	local kind = p18.kind

	if kind == Kind.SELECTION_SET then
		table.remove(p17._parentTypeStack)

		return
	end

	if kind == Kind.FIELD then
		table.remove(p17._fieldDefStack)
		table.remove(p17._typeStack)

		return
	end

	if kind == Kind.DIRECTIVE then
		p17._directive = nil

		return
	end

	if kind == Kind.OPERATION_DEFINITION or kind == Kind.INLINE_FRAGMENT or kind == Kind.FRAGMENT_DEFINITION then
		table.remove(p17._typeStack)

		return
	end

	if kind == Kind.VARIABLE_DEFINITION then
		table.remove(p17._inputTypeStack)

		return
	end

	if kind == Kind.ARGUMENT then
		p17._argument = nil
		table.remove(p17._defaultValueStack)
		table.remove(p17._inputTypeStack)

		return
	end

	if kind == Kind.LIST or kind == Kind.OBJECT_FIELD then
		table.remove(p17._defaultValueStack)
		table.remove(p17._inputTypeStack)

		return
	end

	if kind == Kind.ENUM then
		p17._enumValue = nil
	end
end
function getFieldDef(p19, p20, p21) -- line: 377
	-- upvalues: SchemaMetaFieldDef (copy), TypeMetaFieldDef (copy), TypeNameMetaFieldDef (copy), isCompositeType (copy), isObjectType (copy), isInterfaceType (copy)
	local value = p21.name.value

	if value == SchemaMetaFieldDef.name and p20 == p19:getQueryType() then
		return SchemaMetaFieldDef
	end

	if value == TypeMetaFieldDef.name and p20 == p19:getQueryType() then
		return TypeMetaFieldDef
	end

	if value == TypeNameMetaFieldDef.name and isCompositeType(p20) then
		return TypeNameMetaFieldDef
	end

	if isObjectType(p20) or isInterfaceType(p20) then
		return p20:getFields():get(value)
	end

	return nil
end

return {
	TypeInfo = t1,
	visitWithTypeInfo = function(t3: {[any]: any}, p22) -- line: 404
		-- upvalues: getVisitFn (copy), isNode (copy)
		return {
			enter = function(_, p24, ...) -- line: 409
				-- upvalues: t3 (copy), getVisitFn (copy), p22 (copy), isNode (copy)
				t3:enter(p24)

				local v88 = getVisitFn(p22, p24.kind, false)

				if v88 then
					local v89 = v88(p22, p24, ...)

					if v89 ~= nil then
						t3:leave(p24)

						if isNode(v89) then
							t3:enter(v89)
						end
					end

					return v89
				end

				return nil
			end,
			leave = function(_, p26, ...) -- line: 428
				-- upvalues: getVisitFn (copy), p22 (copy), t3 (copy)
				local v92 = getVisitFn(p22, p26.kind, true)
				local v93 = nil

				if v92 then
					v93 = v92(p22, p26, ...)
				end

				t3:leave(p26)

				return v93
			end
		}
	end
}
