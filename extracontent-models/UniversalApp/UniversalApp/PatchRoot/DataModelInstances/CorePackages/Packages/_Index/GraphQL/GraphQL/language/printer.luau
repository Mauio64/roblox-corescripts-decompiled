local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local HttpService = game:GetService("HttpService")

require(script.Parent.ast)

local visitor = require(script.Parent.visitor)
local visit = visitor.visit
local blockString = require(script.Parent.blockString)
local printBlockString = blockString.printBlockString

local leave = nil

local join
local block
local wrap
local indent

local hasMultilineItems

local function print_(p)
	return visit(p, { leave = leave })
end

local function addDescription(fn)
	return function(_, p)
		return join({ p.description, fn(p) }, "\n")
	end
end

leave = {
	Name = function(_, p)
		return p.value
	end,
	Variable = function(_, p)
		return "$" .. tostring(p.name)
	end,
	Document = function(_, p)
		return join(p.definitions, "\n\n") .. "\n"
	end,
	OperationDefinition = function(_, data)
		local operation = data.operation
		local name = data.name
		local v = wrap("(", join(data.variableDefinitions, ", "), ")")
		local v2 = join(data.directives, " ")
		local selectionSet = data.selectionSet

		if name or v2 and v2 ~= "" or v and v ~= "" or operation ~= "query" then
			return join({
				operation,
				join({ name, v }),
				v2,
				selectionSet
			}, " ")
		end

		return selectionSet
	end,
	VariableDefinition = function(_, data)
		local variable = data.variable
		local kind = data.type
		local defaultValue = data.defaultValue
		local directives = data.directives
		return tostring(variable) .. ": " .. tostring(kind) .. wrap(" = ", defaultValue) .. wrap(" ", join(directives, " "))
	end,
	SelectionSet = function(_, p)
		return block(p.selections)
	end,
	Field = function(_, data)
		local alias = data.alias
		local name = data.name
		local arguments = data.arguments
		local directives = data.directives
		local selectionSet = data.selectionSet
		local v = wrap("", alias, ": ") .. tostring(name)
		local v2 = v .. wrap("(", join(arguments, ", "), ")")

		local v3 = utf8.len(v2)
		assert(v3 ~= nil, "invalid utf8 string")

		if v3 > 80 then
			v2 = v .. wrap("(\n", indent(join(arguments, "\n")), "\n)")
		end

		return join({ v2, join(directives, " "), selectionSet }, " ")
	end,
	Argument = function(_, p)
		local name = p.name
		local value = p.value
		return tostring(name) .. ": " .. tostring(value)
	end,
	FragmentSpread = function(_, p)
		local name = p.name
		local directives = p.directives
		return "..." .. tostring(name) .. wrap(" ", join(directives, " "))
	end,
	InlineFragment = function(_, data)
		local typeCondition = data.typeCondition
		local directives = data.directives
		local selectionSet = data.selectionSet

		return join({ "...", wrap("on ", typeCondition), join(directives, " "), selectionSet }, " ")
	end,
	FragmentDefinition = function(_, data)
		local name = data.name
		local typeCondition = data.typeCondition
		local variableDefinitions = data.variableDefinitions
		local directives = data.directives
		local selectionSet = data.selectionSet

		return "fragment " .. tostring(name) .. wrap("(", join(variableDefinitions, ", "), ")") .. " " .. "on " .. tostring(typeCondition) .. " " .. wrap("", join(directives, " "), " ") .. tostring(selectionSet)
	end,
	IntValue = function(_, p)
		return p.value
	end,
	FloatValue = function(_, p)
		return p.value
	end,
	StringValue = function(_, p, p2: string)
		local value = p.value

		if p.block then
			return (printBlockString(value, p2 == "description" and "" or "  "))
		end

		return (HttpService:JSONEncode(value))
	end,
	BooleanValue = function(_, p): string
		return if p.value then "true" else "false"
	end,
	NullValue = function(_, _): string
		return "null"
	end,
	EnumValue = function(_, p)
		return p.value
	end,
	ListValue = function(_, p)
		local values = p.values
		return "[" .. join(values, ", ") .. "]"
	end,
	ObjectValue = function(_, p)
		local fields = p.fields
		return "{" .. join(fields, ", ") .. "}"
	end,
	ObjectField = function(_, p)
		return p.name .. ": " .. p.value
	end,
	Directive = function(_, p)
		local name = p.name
		local arguments = p.arguments
		return "@" .. tostring(name) .. wrap("(", join(arguments, ", "), ")")
	end,
	NamedType = function(_, p)
		return p.name
	end,
	ListType = function(_, p)
		return "[" .. tostring(p.type) .. "]"
	end,
	NonNullType = function(_, p)
		return tostring(p.type) .. "!"
	end,
	SchemaDefinition = addDescription(function(p)
		local directives = p.directives
		local operationTypes = p.operationTypes

		return join({ "schema", join(directives, " "), block(operationTypes) }, " ")
	end),
	OperationTypeDefinition = function(_, p)
		local operation = p.operation
		local kind = p.type
		return tostring(operation) .. ": " .. tostring(kind)
	end,
	ScalarTypeDefinition = addDescription(function(p)
		local name = p.name
		local directives = p.directives

		return join({ "scalar", name, join(directives, " ") }, " ")
	end),
	ObjectTypeDefinition = addDescription(function(data)
		local name = data.name
		local interfaces = data.interfaces
		local directives = data.directives
		local fields = data.fields
		return join(
			{
				"type",
				name,
				wrap("implements ", join(interfaces, " & ")),
				join(directives, " "),
				block(fields)
			},
			" "
		)
	end),
	FieldDefinition = addDescription(function(data)
		local name = data.name
		local arguments = data.arguments
		local kind = data.type
		local directives = data.directives
		local v = tostring(name)
		local v2

		if hasMultilineItems(arguments) then
			v2 = wrap("(\n", indent(join(arguments, "\n")), "\n)")
		else
			v2 = wrap("(", join(arguments, ", "), ")")
		end

		return v .. v2 .. ": " .. tostring(kind) .. wrap(" ", join(directives, " "))
	end),
	InputValueDefinition = addDescription(function(data)
		local name = data.name
		local kind = data.type
		local defaultValue = data.defaultValue
		local directives = data.directives
		return join({ tostring(name) .. ": " .. tostring(kind), wrap("= ", defaultValue), join(directives, " ") }, " ")
	end),
	InterfaceTypeDefinition = addDescription(function(data)
		local name = data.name
		local interfaces = data.interfaces
		local directives = data.directives
		local fields = data.fields

		return join(
			{
				"interface",
				name,
				wrap("implements ", join(interfaces, " & ")),
				join(directives, " "),
				block(fields)
			},
			" "
		)
	end),
	UnionTypeDefinition = addDescription(function(data)
		local name = data.name
		local directives = data.directives
		local types = data.types

		return join({
			"union",
			name,
			join(directives, " "),
			(not types or #types == 0) and "" or "= " .. join(types, " | ")
		}, " ")
	end),
	EnumTypeDefinition = addDescription(function(data)
		local name = data.name
		local directives = data.directives
		local values = data.values

		return join({ "enum", name, join(directives, " "), block(values) }, " ")
	end),
	EnumValueDefinition = addDescription(function(p)
		local name = p.name
		local directives = p.directives

		return join({ name, join(directives, " ") }, " ")
	end),
	InputObjectTypeDefinition = addDescription(function(data)
		local name = data.name
		local directives = data.directives
		local fields = data.fields

		return join({ "input", name, join(directives, " "), block(fields) }, " ")
	end),
	DirectiveDefinition = addDescription(function(data)
		local name = data.name
		local arguments = data.arguments
		local repeatable = data.repeatable
		local locations = data.locations

		local v = tostring(name)
		local v2

		if hasMultilineItems(arguments) then
			v2 = wrap("(\n", indent(join(arguments, "\n")), "\n)")
		else
			v2 = wrap("(", join(arguments, ", "), ")")
		end

		return "directive @" .. v .. v2 .. (repeatable and " repeatable" or "") .. " on " .. join(locations, " | ")
	end),
	SchemaExtension = function(_, p)
		local directives = p.directives
		local operationTypes = p.operationTypes

		return join({ "extend schema", join(directives, " "), block(operationTypes) }, " ")
	end,
	ScalarTypeExtension = function(_, p)
		local name = p.name
		local directives = p.directives

		return join({ "extend scalar", name, join(directives, " ") }, " ")
	end,
	ObjectTypeExtension = function(_, data)
		local name = data.name
		local interfaces = data.interfaces
		local directives = data.directives
		local fields = data.fields

		return join(
			{
				"extend type",
				name,
				wrap("implements ", join(interfaces, " & ")),
				join(directives, " "),
				block(fields)
			},
			" "
		)
	end,
	InterfaceTypeExtension = function(_, data)
		local name = data.name
		local interfaces = data.interfaces
		local directives = data.directives
		local fields = data.fields

		return join(
			{
				"extend interface",
				name,
				wrap("implements ", join(interfaces, " & ")),
				join(directives, " "),
				block(fields)
			},
			" "
		)
	end,
	UnionTypeExtension = function(_, data)
		local name = data.name
		local directives = data.directives
		local types = data.types

		return join({
			"extend union",
			name,
			join(directives, " "),
			(not types or #types == 0) and "" or "= " .. join(types, " | ")
		}, " ")
	end,
	EnumTypeExtension = function(_, data)
		local name = data.name
		local directives = data.directives
		local values = data.values

		return join({ "extend enum", name, join(directives, " "), block(values) }, " ")
	end,
	InputObjectTypeExtension = function(_, data)
		local name = data.name
		local directives = data.directives
		local fields = data.fields

		return join({ "extend input", name, join(directives, " "), block(fields) }, " ")
	end
}

join = function(p, value: string?)
	local v = value or ""

	if p then
		return Array.join(Array.filter(p, function(p2)
			return tostring(p2) and p2 ~= ""
		end), v)
	end

	return ""
end

block = function(p)
	return wrap("{\n", indent(join(p, "\n")), "\n}")
end

wrap = function(p: string, p2, value: string?)
	if p2 == nil or p2 == "" then
		return ""
	end

	return p .. tostring(p2) .. tostring(value or "")
end

indent = function(value: string)
	local v = value:gsub("\n", "\n  ")
	return wrap("  ", v)
end

local function isMultiline(p: string): boolean
	return string.find(tostring(p), "\n") ~= nil
end

hasMultilineItems = function(arguments)
	return arguments ~= nil and Array.some(arguments, isMultiline)
end

return { print = print_ }
