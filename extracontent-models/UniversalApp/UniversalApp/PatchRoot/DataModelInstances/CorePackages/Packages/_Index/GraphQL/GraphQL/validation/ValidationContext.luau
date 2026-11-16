local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local Map = LuauPolyfill.Map

local jsutils = parent.jsutils
require(jsutils.ObjMap)

local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local visitor = require(language.visitor)
local visit = visitor.visit

require(language.ast)

require(parent.error.GraphQLError)

local TypeInfo = require(parent.utilities.TypeInfo)
local typeInfo = TypeInfo.TypeInfo
local visitWithTypeInfo = TypeInfo.visitWithTypeInfo

require(parent.type.schema)

require(parent.type.directives)

require(parent.type.definition)

local astValidationContext = {}
local v = { __index = astValidationContext }

function astValidationContext.new(ast, onError)
	return (setmetatable({
		_ast = ast,
		_fragments = nil,
		_fragmentSpreads = {},
		_recursivelyReferencedFragments = {},
		_onError = onError
	}, v))
end

function astValidationContext:reportError(p)
	self._onError(p)
end

function astValidationContext:getDocument()
	return self._ast
end

function astValidationContext:getFragment(p: string)
	local definitions

	if self._fragments then
		definitions = self._fragments
	else
		definitions = {}

		for _, definition in ipairs(self:getDocument().definitions) do
			if definition.kind == kind.FRAGMENT_DEFINITION then
				definitions[definition.name.value] = definition
			end
		end

		self._fragments = definitions
	end

	return definitions[p]
end

function astValidationContext:getFragmentSpreads(p)
	local selections = self._fragmentSpreads[p] or {}

	if self._fragmentSpreads[p] then
		return selections
	end

	local selectionSets = { p }

	while #selectionSets ~= 0 do
		local v2 = table.remove(selectionSets)

		for _, selection in ipairs(v2.selections) do
			if selection.kind == kind.FRAGMENT_SPREAD then
				table.insert(selections, selection)
			elseif selection.selectionSet then
				table.insert(selectionSets, selection.selectionSet)
			end
		end
	end

	self._fragmentSpreads[p] = selections

	return selections
end

function astValidationContext:getRecursivelyReferencedFragments(p)
	local fragments = self._recursivelyReferencedFragments[p] or {}

	if self._recursivelyReferencedFragments[p] then
		return fragments
	end

	local selectionSets = { p.selectionSet }
	local set = {}

	while #selectionSets ~= 0 do
		local v2 = table.remove(selectionSets)

		for _, v3 in ipairs(self:getFragmentSpreads(v2)) do
			local value = v3.name.value

			if set[value] == true then
				continue
			end

			set[value] = true
			local fragment = self:getFragment(value)

			if not fragment then
				continue
			end

			table.insert(fragments, fragment)
			table.insert(selectionSets, fragment.selectionSet)
		end
	end

	self._recursivelyReferencedFragments[p] = fragments

	return fragments
end

local object = setmetatable({}, { __index = astValidationContext })

local v2 = { __index = object }

function object.new(p, schema, callback)
	local v3 = astValidationContext.new(p, callback)
	v3._schema = schema
	return (setmetatable(v3, v2))
end

function object:getSchema()
	return self._schema
end

local object2 = setmetatable({}, { __index = astValidationContext })
local v3 = { __index = object2 }

function object2.new(schema, p, typeInfo2, callback)
	local v4 = astValidationContext.new(p, callback)
	v4._schema = schema
	v4._typeInfo = typeInfo2
	v4._variableUsages = Map.new()

	v4._recursiveVariableUsages = Map.new()
	return (setmetatable(v4, v3))
end

function object2:getSchema()
	return self._schema
end

function object2:getVariableUsages(p)
	local variableUsages = self._variableUsages[p]

	if variableUsages then
		return variableUsages
	end

	variableUsages = {}
	local v4 = typeInfo.new(self._schema)
	visit(p, visitWithTypeInfo(v4, {
		VariableDefinition = function(): boolean
			return false
		end,
		Variable = function(_, node)
			table.insert(variableUsages, {
				node = node,
				type = v4:getInputType(),
				defaultValue = v4:getDefaultValue()
			})
		end
	}))

	self._variableUsages[p] = variableUsages

	return variableUsages
end

function object2:getRecursiveVariableUsages(p)
	local recursiveVariableUsages = self._recursiveVariableUsages[p]

	if recursiveVariableUsages then
		return recursiveVariableUsages
	end

	recursiveVariableUsages = self:getVariableUsages(p)

	for _, v4 in ipairs(self:getRecursivelyReferencedFragments(p)) do
		recursiveVariableUsages = Array.concat(recursiveVariableUsages, self:getVariableUsages(v4))
	end

	self._recursiveVariableUsages[p] = recursiveVariableUsages

	return recursiveVariableUsages
end

function object2:getType()
	return self._typeInfo:getType()
end

function object2:getParentType()
	return self._typeInfo:getParentType()
end

function object2:getInputType()
	return self._typeInfo:getInputType()
end

function object2:getParentInputType()
	return self._typeInfo:getParentInputType()
end

function object2:getFieldDef()
	return self._typeInfo:getFieldDef()
end

function object2:getDirective()
	return self._typeInfo:getDirective()
end

function object2:getArgument()
	return self._typeInfo:getArgument()
end

function object2:getEnumValue()
	return self._typeInfo:getEnumValue()
end

return {
	ASTValidationContext = astValidationContext,
	SDLValidationContext = object,
	ValidationContext = object2
}
