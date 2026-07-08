local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array
local HttpService = game:GetService("HttpService")

require(script.Parent.ast)

local visit = require(script.Parent.visitor).visit
local printBlockString = require(script.Parent.blockString).printBlockString
local t4 = nil
local join = nil
local block = nil
local wrap = nil
local indent = nil
local hasMultilineItems = nil

local function print_(p1) -- line: 75
	-- upvalues: visit (copy), t4 (ref)
	return visit(p1, {
		leave = t4
	})
end
local function addDescription(p2) -- line: 83
	-- upvalues: join (ref)
	return function(_, p4) -- line: 85
		-- upvalues: join (ref), p2 (copy)
		return join({
			p4.description,
			p2(p4)
		}, "\n")
	end
end

t4 = {
	Name = function(_, p6) -- line: 92
		return p6.value
	end,
	Variable = function(_, p8) -- line: 96
		return "$" .. tostring(p8.name)
	end,
	Document = function(_, p10) -- line: 102
		-- upvalues: join (ref)
		return join(p10.definitions, "\n\n") .. "\n"
	end,
	OperationDefinition = function(_, p12) -- line: 106
		-- upvalues: wrap (ref), join (ref)
		local operation = p12.operation
		local name = p12.name
		local v27 = wrap("(", join(p12.variableDefinitions, ", "), ")")
		local v28 = join(p12.directives, " ")
		local selectionSet = p12.selectionSet

		if not name and (not v28 or v28 == "") and ((not v27 or v27 == "") and operation == "query") then
			return selectionSet
		end

		return join({
			operation,
			join({
				name,
				v27
			}),
			v28,
			selectionSet
		}, " ")
	end,
	VariableDefinition = function(_, p14) -- line: 131
		-- upvalues: wrap (ref), join (ref)
		local variable = p14.variable
		local type = p14.type
		local defaultValue = p14.defaultValue
		local directives = p14.directives

		return tostring(variable) .. ": " .. tostring(type) .. wrap(" = ", defaultValue) .. wrap(" ", join(directives, " "))
	end,
	SelectionSet = function(_, p16) -- line: 143
		-- upvalues: block (ref)
		return block(p16.selections)
	end,
	Field = function(_, p18) -- line: 147
		-- upvalues: wrap (ref), join (ref), indent (ref)
		local alias = p18.alias
		local name = p18.name
		local arguments = p18.arguments
		local directives = p18.directives
		local selectionSet = p18.selectionSet
		local v45 = wrap("", alias, ": ") .. tostring(name)
		local v46 = v45 .. wrap("(", join(arguments, ", "), ")")
		local v47 = utf8.len(v46)

		assert(v47 ~= nil, "invalid utf8 string")

		if v47 > 80 then
			v46 = v45 .. wrap("(\n", indent(join(arguments, "\n")), "\n)")
		end

		return join({
			v46,
			join(directives, " "),
			selectionSet
		}, " ")
	end,
	Argument = function(_, p20) -- line: 168
		local name = p20.name
		local value = p20.value

		return tostring(name) .. ": " .. tostring(value)
	end,
	FragmentSpread = function(_, p22) -- line: 176
		-- upvalues: wrap (ref), join (ref)
		local name = p22.name
		local directives = p22.directives

		return "..." .. tostring(name) .. wrap(" ", join(directives, " "))
	end,
	InlineFragment = function(_, p24) -- line: 182
		-- upvalues: join (ref), wrap (ref)
		local typeCondition = p24.typeCondition
		local directives = p24.directives
		local selectionSet = p24.selectionSet

		return join({
			"...",
			wrap("on ", typeCondition),
			join(directives, " "),
			selectionSet
		}, " ")
	end,
	FragmentDefinition = function(_, p26) -- line: 193
		-- upvalues: wrap (ref), join (ref)
		local name = p26.name
		local typeCondition = p26.typeCondition
		local variableDefinitions = p26.variableDefinitions
		local directives = p26.directives
		local selectionSet = p26.selectionSet

		return "fragment " .. tostring(name) .. wrap("(", join(variableDefinitions, ", "), ")") .. " " .. "on " .. tostring(typeCondition) .. " " .. wrap("", join(directives, " "), " ") .. tostring(selectionSet)
	end,
	IntValue = function(_, p28) -- line: 216
		return p28.value
	end,
	FloatValue = function(_, p30) -- line: 220
		return p30.value
	end,
	StringValue = function(_, p32, s1: string) -- line: 224
		-- upvalues: printBlockString (copy), HttpService (copy)
		local value = p32.value

		if p32.block then
			return (printBlockString(value, s1 ~= "description" and "  " or ""))
		end

		return (HttpService:JSONEncode(value))
	end,
	BooleanValue = function(_, p34) -- line: 231
		if p34.value then
			return "true"
		end

		return "false"
	end,
	NullValue = function(_, _) -- line: 239
		return "null"
	end,
	EnumValue = function(_, p38) -- line: 242
		return p38.value
	end,
	ListValue = function(_, t1: {[any]: any}) -- line: 246
		-- upvalues: join (ref)
		local values = t1.values

		return "[" .. join(values, ", ") .. "]"
	end,
	ObjectValue = function(_, t2: {[any]: any}) -- line: 250
		-- upvalues: join (ref)
		local fields = t2.fields

		return "{" .. join(fields, ", ") .. "}"
	end,
	ObjectField = function(_, t3: {[any]: any}) -- line: 254
		return t3.name .. ": " .. t3.value
	end,
	Directive = function(_, p43) -- line: 262
		-- upvalues: wrap (ref), join (ref)
		local name = p43.name
		local arguments = p43.arguments

		return "@" .. tostring(name) .. wrap("(", join(arguments, ", "), ")")
	end,
	NamedType = function(_, p45) -- line: 270
		return p45.name
	end,
	ListType = function(_, p47) -- line: 274
		return "[" .. tostring(p47.type) .. "]"
	end,
	NonNullType = function(_, p49) -- line: 278
		return tostring(p49.type) .. "!"
	end,
	SchemaDefinition = addDescription(function(p50) -- line: 286
		-- upvalues: join (ref), block (ref)
		local directives = p50.directives
		local operationTypes = p50.operationTypes

		return join({
			"schema",
			join(directives, " "),
			block(operationTypes)
		}, " ")
	end),
	OperationTypeDefinition = function(_, p52) -- line: 293
		local operation = p52.operation
		local type = p52.type

		return tostring(operation) .. ": " .. tostring(type)
	end,
	ScalarTypeDefinition = addDescription(function(p53) -- line: 299
		-- upvalues: join (ref)
		local name = p53.name
		local directives = p53.directives

		return join({
			"scalar",
			name,
			join(directives, " ")
		}, " ")
	end),
	ObjectTypeDefinition = addDescription(function(p54) -- line: 306
		-- upvalues: join (ref), wrap (ref), block (ref)
		local name = p54.name
		local interfaces = p54.interfaces
		local directives = p54.directives
		local fields = p54.fields

		return join({
			"type",
			name,
			wrap("implements ", join(interfaces, " & ")),
			join(directives, " "),
			block(fields)
		}, " ")
	end),
	FieldDefinition = addDescription(function(p55) -- line: 320
		-- upvalues: hasMultilineItems (ref), wrap (ref), indent (ref), join (ref)
		local name = p55.name
		local arguments = p55.arguments
		local type = p55.type
		local directives = p55.directives

		return tostring(name) .. ((if not hasMultilineItems(arguments) then wrap("(", join(arguments, ", "), ")") else wrap("(\n", indent(join(arguments, "\n")), "\n)"))) .. ": " .. tostring(type) .. wrap(" ", join(directives, " "))
	end),
	InputValueDefinition = addDescription(function(p56) -- line: 334
		-- upvalues: join (ref), wrap (ref)
		local name = p56.name
		local type = p56.type
		local defaultValue = p56.defaultValue
		local directives = p56.directives

		return join({
			tostring(name) .. ": " .. tostring(type),
			wrap("= ", defaultValue),
			join(directives, " ")
		}, " ")
	end),
	InterfaceTypeDefinition = addDescription(function(p57) -- line: 346
		-- upvalues: join (ref), wrap (ref), block (ref)
		local name = p57.name
		local interfaces = p57.interfaces
		local directives = p57.directives
		local fields = p57.fields

		return join({
			"interface",
			name,
			wrap("implements ", join(interfaces, " & ")),
			join(directives, " "),
			block(fields)
		}, " ")
	end),
	UnionTypeDefinition = addDescription(function(p58) -- line: 361
		-- upvalues: join (ref)
		local name = p58.name
		local directives = p58.directives
		local types = p58.types

		return join({
			"union",
			name,
			join(directives, " "),
			(not types or #types == 0) and "" or "= " .. join(types, " | ")
		}, " ")
	end),
	EnumTypeDefinition = addDescription(function(p59) -- line: 374
		-- upvalues: join (ref), block (ref)
		local name = p59.name
		local directives = p59.directives
		local values = p59.values

		return join({
			"enum",
			name,
			join(directives, " "),
			block(values)
		}, " ")
	end),
	EnumValueDefinition = addDescription(function(p60) -- line: 387
		-- upvalues: join (ref)
		local name = p60.name
		local directives = p60.directives

		return join({
			name,
			join(directives, " ")
		}, " ")
	end),
	InputObjectTypeDefinition = addDescription(function(p61) -- line: 397
		-- upvalues: join (ref), block (ref)
		local name = p61.name
		local directives = p61.directives
		local fields = p61.fields

		return join({
			"input",
			name,
			join(directives, " "),
			block(fields)
		}, " ")
	end),
	DirectiveDefinition = addDescription(function(p62) -- line: 410
		-- upvalues: hasMultilineItems (ref), wrap (ref), indent (ref), join (ref)
		local name = p62.name
		local arguments = p62.arguments
		local repeatable = p62.repeatable
		local locations = p62.locations

		return "directive @" .. tostring(name) .. ((if not hasMultilineItems(arguments) then wrap("(", join(arguments, ", "), ")") else wrap("(\n", indent(join(arguments, "\n")), "\n)"))) .. (not repeatable and "" or " repeatable") .. " on " .. join(locations, " | ")
	end),
	SchemaExtension = function(_, p64) -- line: 425
		-- upvalues: join (ref), block (ref)
		local directives = p64.directives
		local operationTypes = p64.operationTypes

		return join({
			"extend schema",
			join(directives, " "),
			block(operationTypes)
		}, " ")
	end,
	ScalarTypeExtension = function(_, p66) -- line: 436
		-- upvalues: join (ref)
		local name = p66.name
		local directives = p66.directives

		return join({
			"extend scalar",
			name,
			join(directives, " ")
		}, " ")
	end,
	ObjectTypeExtension = function(_, p68) -- line: 447
		-- upvalues: join (ref), wrap (ref), block (ref)
		local name = p68.name
		local interfaces = p68.interfaces
		local directives = p68.directives
		local fields = p68.fields

		return join({
			"extend type",
			name,
			wrap("implements ", join(interfaces, " & ")),
			join(directives, " "),
			block(fields)
		}, " ")
	end,
	InterfaceTypeExtension = function(_, p70) -- line: 462
		-- upvalues: join (ref), wrap (ref), block (ref)
		local name = p70.name
		local interfaces = p70.interfaces
		local directives = p70.directives
		local fields = p70.fields

		return join({
			"extend interface",
			name,
			wrap("implements ", join(interfaces, " & ")),
			join(directives, " "),
			block(fields)
		}, " ")
	end,
	UnionTypeExtension = function(_, p72) -- line: 477
		-- upvalues: join (ref)
		local name = p72.name
		local directives = p72.directives
		local types = p72.types

		return join({
			"extend union",
			name,
			join(directives, " "),
			(not types or #types == 0) and "" or "= " .. join(types, " | ")
		}, " ")
	end,
	EnumTypeExtension = function(_, p74) -- line: 490
		-- upvalues: join (ref), block (ref)
		local name = p74.name
		local directives = p74.directives
		local values = p74.values

		return join({
			"extend enum",
			name,
			join(directives, " "),
			block(values)
		}, " ")
	end,
	InputObjectTypeExtension = function(_, p76) -- line: 503
		-- upvalues: join (ref), block (ref)
		local name = p76.name
		local directives = p76.directives
		local fields = p76.fields

		return join({
			"extend input",
			name,
			join(directives, " "),
			block(fields)
		}, " ")
	end
}

function join(p77, s2: string?) -- line: 521
	-- upvalues: Array (copy)
	local v187 = s2 or ""

	if p77 then
		return Array.join(Array.filter(p77, function(p78) -- line: 525
			return tostring(p78) and p78 ~= ""
		end), v187)
	end

	return ""
end
function block(p79) -- line: 539
	-- upvalues: wrap (ref), indent (ref), join (ref)
	return wrap("{\n", indent(join(p79, "\n")), "\n}")
end
function wrap(s3: string, p80, s4: string?) -- line: 546
	local v192 = s4 or ""

	if p80 ~= nil and p80 ~= "" then
		return s3 .. tostring(p80) .. tostring(v192)
	end

	return ""
end
function indent(s5: string) -- line: 556
	-- upvalues: wrap (ref)
	local v194 = s5:gsub("\n", "\n  ")

	return wrap("  ", v194)
end

local function isMultiline(s6: string) -- line: 563
	return string.find(tostring(s6), "\n") ~= nil
end

function hasMultilineItems(p81) -- line: 567
	-- upvalues: Array (copy), isMultiline (ref)
	return p81 ~= nil and Array.some(p81, isMultiline)
end

return {
	print = print_
}
