local parent = script.Parent.Parent
local LuauPolyfill = require(parent.Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect

require(parent.language.ast)

local ast = require(script.Parent.ast)
local isNode = ast.isNode

local queryDocumentKeys = {
	Name = {},
	Document = { "definitions" },
	OperationDefinition = { "name", "variableDefinitions", "directives", "selectionSet" },
	VariableDefinition = { "variable", "type", "defaultValue", "directives" },
	Variable = { "name" },
	SelectionSet = { "selections" },
	Field = { "alias", "name", "arguments", "directives", "selectionSet" },
	Argument = { "name", "value" },
	FragmentSpread = { "name", "directives" },
	InlineFragment = { "typeCondition", "directives", "selectionSet" },
	FragmentDefinition = {
		"name",
		"variableDefinitions",
		"typeCondition",
		"directives",
		"selectionSet"
	},
	IntValue = {},
	FloatValue = {},
	StringValue = {},
	BooleanValue = {},
	NullValue = {},
	EnumValue = {},
	ListValue = { "values" },
	ObjectValue = { "fields" },
	ObjectField = { "name", "value" },
	Directive = { "name", "arguments" },
	NamedType = { "name" },
	ListType = { "type" },
	NonNullType = { "type" },
	SchemaDefinition = { "description", "directives", "operationTypes" },
	OperationTypeDefinition = { "type" },
	ScalarTypeDefinition = { "description", "name", "directives" },
	ObjectTypeDefinition = { "description", "name", "interfaces", "directives", "fields" },
	FieldDefinition = { "description", "name", "arguments", "type", "directives" },
	InputValueDefinition = { "description", "name", "type", "defaultValue", "directives" },
	InterfaceTypeDefinition = { "description", "name", "interfaces", "directives", "fields" },
	UnionTypeDefinition = { "description", "name", "directives", "types" },
	EnumTypeDefinition = { "description", "name", "directives", "values" },
	EnumValueDefinition = { "description", "name", "directives" },
	InputObjectTypeDefinition = { "description", "name", "directives", "fields" },
	DirectiveDefinition = { "description", "name", "arguments", "locations" },
	SchemaExtension = { "directives", "operationTypes" },
	ScalarTypeExtension = { "name", "directives" },
	ObjectTypeExtension = { "name", "interfaces", "directives", "fields" },
	InterfaceTypeExtension = { "name", "interfaces", "directives", "fields" },
	UnionTypeExtension = { "name", "directives", "types" },
	EnumTypeExtension = { "name", "directives", "values" },
	InputObjectTypeExtension = { "name", "directives", "fields" }
}

local frozen = Object.freeze({})

local null = require(parent.luaUtils.null)

local getVisitFn

local function visit(_, _, _)
	-- [TOVEK] This code could not be rebuilt at all
	-- Lines 249 to 409, proto: p0
	error("unreversable function")
end

local function visitInParallel(list)
	local v = {}

	return {
		enter = function(_, p, ...)
			for i = 1, #list do
				if v[i] ~= nil then
					continue
				end

				local v2 = getVisitFn(list[i], p.kind, false)

				if not v2 then
					continue
				end

				local v3 = v2(list[i], p, ...)

				if v3 == false then
					v[i] = p
				elseif v3 == frozen then
					v[i] = frozen
				elseif v3 ~= nil then
					return v3
				end
			end
		end,
		leave = function(_, ...)
			local v2 = ...

			for i = 1, #list do
				if v[i] == nil then
					local v3 = getVisitFn(list[i], v2.kind, true)

					if v3 then
						local v4 = v3(list[i], ...)

						if v4 == frozen then
							v[i] = frozen
						elseif v4 ~= nil and v4 ~= false then
							return v4
						end
					end
				elseif v[i] == v2 then
					v[i] = nil
				end
			end
		end
	}
end

getVisitFn = function(p, kind: string, flag: boolean)
	local v = p[kind]

	if v then
		if not flag and type(v) == "function" then
			return v
		end

		local v2

		if typeof(v) ~= "function" then
			v2 = if flag then v.leave else v.enter
		end

		if type(v2) == "function" then
			return v2
		end
	else
		local selected = if flag then p.leave else p.enter

		if selected then
			if type(selected) == "function" then
				return selected
			end

			local v2 = selected[kind]

			if type(v2) == "function" then
				return v2
			end
		end
	end
end

return {
	BREAK = frozen,
	REMOVE = null,
	visit = visit,
	visitInParallel = visitInParallel,
	getVisitFn = getVisitFn,
	QueryDocumentKeys = queryDocumentKeys
}
