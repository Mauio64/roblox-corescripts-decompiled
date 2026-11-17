local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local Comments = {}

require(script.Parent.types)

local GraphQL = require(parent.GraphQL)

local visit = GraphQL.visit

local TokenKind = GraphQL.TokenKind

require(parent.GraphQL)

local pushComment
local isFieldDefinitionNode
local getComment
local getLeadingCommentBlock
local dedentBlockStringValue
local getBlockStringIndentation
local isBlank
local leadingWhitespace

local String = LuauPolyfill.String

local v = {}
function Comments.resetComments()
	v = {}
end
function Comments.collectComment(data)
	local value

	if typeof(data.name) == "table" then
		value = data.name.value
	end

	if value == nil then
		return
	end

	pushComment(data, value)

	local kind = data.kind

	if kind == "EnumTypeDefinition" then
		if Boolean.toJSBoolean(data.values) then
			for _, value2 in data.values do
				pushComment(value2, value, value2.name.value)
			end
		end
	elseif
		(kind == "ObjectTypeDefinition" or kind == "InputObjectTypeDefinition" or kind == "InterfaceTypeDefinition")
		and Boolean.toJSBoolean(data.fields)
	then
		for _, field in data.fields do
			pushComment(field, value, field.name.value)

			local toJSBoolean = Boolean.toJSBoolean
			local v2 = isFieldDefinitionNode(field)

			if Boolean.toJSBoolean(v2) then
				v2 = field.arguments
			end

			if not toJSBoolean(v2) then
				continue
			end

			for _, argument in field.arguments do
				pushComment(argument, value, field.name.value, argument.name.value)
			end
		end
	end
end

pushComment = function(p, value: string, p2: string?, p3: string?)
	local v2 = getComment(p)

	if typeof(v2) ~= "string" or #v2 == 0 then
		return
	end

	local v3 = { value }

	if Boolean.toJSBoolean(p2) then
		table.insert(v3, p2)

		if Boolean.toJSBoolean(p3) then
			table.insert(v3, p3)
		end
	end

	local joined = Array.join(v3, ".")

	if not Boolean.toJSBoolean(v[tostring(joined)]) then
		v[tostring(joined)] = {}
	end

	table.insert(v[joined], v2)
end
Comments.pushComment = pushComment
local function printComment(value: string)
	return "\n# " .. value:gsub("\n", "\n# ")
end

Comments.printComment = printComment

local function join(p, p2: string?)
	if Boolean.toJSBoolean(p) then
		return (Array.join(Array.filter(p, function(p3)
			return Boolean.toJSBoolean(p3)
		end), Boolean.toJSBoolean(p2) and p2 or ""))
	end

	return ""
end

local function hasMultilineItems(p)
	local selected

	if typeof(p) == "table" then
		selected = Array.some(p, function(p2)
			return String.includes(p2, "\n")
		end)
	end

	return selected ~= nil and selected
end

local function addDescription(leave) -- 1 equivalent call inferred from this helper
	return function(p, p2, p3: string, p4, p5, list)
		local v2 = {}

		local reduced = Array.reduce(p5, function(p6, p7)
			if
				p7 ~= Object.None
				and Array.includes({ "fields", "arguments", "values" }, p7)
				and Boolean.toJSBoolean(p6.name)
			then
				table.insert(v2, p6.name.value)
			end

			if p6 == Object.None then
				return p7
			end

			return p6[p7]
		end, list[1] or Object.None)

		local join2 = Array.join
		local filter = Array.filter

		local concat = Array.concat
		local name

		if typeof(reduced) == "table" then
			name = reduced.name
		end

		local value

		if typeof(name) == "table" then
			local v3

			if typeof(reduced) == "table" then
				v3 = reduced.name
			end

			value = v3.value
		end

		local joined = join2(filter(concat({}, v2, { value }), Boolean.toJSBoolean), ".")

		local joined2 = {}

		if String.includes(p2.kind, "Definition") and Boolean.toJSBoolean(v[joined]) then
			joined2 = Array.concat(joined2, v[joined])
		end

		return join(
			Array.concat({}, Array.map(joined2, printComment), {
				p2.description or "",
				(leave(p, p2, p3, p4, p5, list))
			}),
			"\n"
		)
	end
end

local function indent(value: string?) -- 3 equivalent calls inferred from this helper
	if Boolean.toJSBoolean(value) then
		return ("  %s"):format((value:gsub("\n", "\n  ")))
	end

	return value
end

local function block(list) -- 11 equivalent calls inferred from this helper
	if list and #list ~= 0 then
		return (("{\n%s\n}"):format(indent(join(list, "\n"))))
	end

	return ""
end

local function wrap(p: string, p2, p3: string?) -- 11 equivalent calls inferred from this helper
	if Boolean.toJSBoolean(p2) then
		return p .. tostring(p2) .. (Boolean.toJSBoolean(p3) and p3 or "")
	end

	return ""
end

local function printBlockString(value: string, flag: boolean?)
	if flag == nil then
		flag = false
	end

	local v2 = value:gsub("\"", "\\\"\"\"")

	if (value:sub(1, 1) == " " or value:sub(1, 1) == "\t") and String.indexOf(value, "\n") == -1 then
		return ("\"\"\"%s\"\"\""):format((v2:gsub("\"$", "\"\n")))
	end

	if not Boolean.toJSBoolean(flag) and Boolean.toJSBoolean(v2) then
		v2 = ("  %s"):format((v2:gsub("\n", "\n  ")))
	end

	return ("\"\"\"\n%s\n\"\"\""):format(v2)
end

local v2 = {
	Name = {
		leave = function(_, p)
			return p.value
		end
	},
	Variable = {
		leave = function(_, p)
			return "$" .. tostring(p.name)
		end
	},
	Document = {
		leave = function(_, p)
			return join(p.definitions, "\n\n")
		end
	},
	OperationDefinition = {
		leave = function(_, data)
			local v2 = wrap("(", join(data.variableDefinitions, ", "), ")") -- inferred equivalent call
			return tostring(join({ data.operation, join({ data.name, v2 }), join(data.directives, " ") }, " ")) .. " " .. tostring(data.selectionSet)
		end
	},
	VariableDefinition = {
		leave = function(_, data)
			local variable = data.variable
			local kind = data.type
			local defaultValue = data.defaultValue
			local directives = data.directives
			local v2 = tostring(variable)

			local v3 = tostring(kind)
			local v4

			if Boolean.toJSBoolean(defaultValue) then
				local v5 = tostring(defaultValue)
				Boolean.toJSBoolean(nil)
				v4 = " = " .. v5 .. ""
			else
				v4 = ""
			end

			local v5 = tostring(v4)
			local v6 = join(directives, " ")
			local v7

			if Boolean.toJSBoolean(v6) then
				local v8 = tostring(v6)
				Boolean.toJSBoolean(nil)
				v7 = " " .. v8 .. ""
			else
				v7 = ""
			end

			return v2 .. ": " .. v3 .. v5 .. tostring(v7)
		end
	},
	SelectionSet = {
		leave = function(_, p)
			return block(p.selections) -- inferred equivalent call
		end
	},
	Field = {
		leave = function(_, data)
			local alias = data.alias
			local name = data.name
			local arguments = data.arguments
			local directives = data.directives
			local selectionSet = data.selectionSet

			local v2 = wrap("", alias, ": ") .. name -- inferred equivalent call
			local v3 = v2 .. wrap("(", join(arguments, ", "), ")") -- inferred equivalent call

			if v3.length > 80 then
				v3 = v2 .. wrap("(\n", indent(join(arguments, "\n")), "\n)") -- inferred equivalent call
			end

			return join({ v3, join(directives, " "), selectionSet }, " ")
		end
	},
	Argument = {
		leave = function(_, p)
			local name = p.name
			local value = p.value
			return tostring(name) .. ": " .. tostring(value)
		end
	},
	FragmentSpread = {
		leave = function(_, p)
			local name = p.name
			local directives = p.directives
			local v2 = tostring(name)
			local v3 = join(directives, " ")
			local v4

			if Boolean.toJSBoolean(v3) then
				local v5 = tostring(v3)
				Boolean.toJSBoolean(nil)
				v4 = " " .. v5 .. ""
			else
				v4 = ""
			end

			return "..." .. v2 .. tostring(v4)
		end
	},
	InlineFragment = {
		leave = function(_, data)
			local typeCondition = data.typeCondition
			local directives = data.directives
			local selectionSet = data.selectionSet
			local v2

			if Boolean.toJSBoolean(typeCondition) then
				local v3 = tostring(typeCondition)
				Boolean.toJSBoolean(nil)
				v2 = "on " .. v3 .. ""
			else
				v2 = ""
			end

			return join({ "...", v2, join(directives, " "), selectionSet }, " ")
		end
	},
	FragmentDefinition = {
		leave = function(_, data)
			local name = data.name
			local typeCondition = data.typeCondition
			local variableDefinitions = data.variableDefinitions
			local directives = data.directives
			local selectionSet = data.selectionSet

			return ("fragment %s%s "):format(tostring(name), wrap("(", join(variableDefinitions, ", "), ")")) .. ("on %s %s"):format( -- inferred equivalent call
				tostring(typeCondition),
				(tostring(wrap("", join(directives, " "), " "))) -- inferred equivalent call
			) .. tostring(selectionSet)
		end
	},
	IntValue = {
		leave = function(_, p)
			return p.value
		end
	},
	FloatValue = {
		leave = function(_, p)
			return p.value
		end
	},
	StringValue = {
		leave = function(_, p)
			local value = p.value
			local block2 = p.block

			if Boolean.toJSBoolean(block2) then
				return printBlockString(value)
			end

			return "'" .. value:gsub("'", "\\'") .. "'"
		end
	},
	BooleanValue = {
		leave = function(_, p): string
			local value = p.value

			if Boolean.toJSBoolean(value) then
				return "true"
			end

			return "false"
		end
	},
	NullValue = {
		leave = function(): string
			return "null"
		end
	},
	EnumValue = {
		leave = function(_, p)
			return p.value
		end
	},
	ListValue = {
		leave = function(_, p)
			local values = p.values
			return "[" .. tostring(join(values, ", ")) .. "]"
		end
	},
	ObjectValue = {
		leave = function(_, p)
			local fields = p.fields
			return "{" .. tostring(join(fields, ", ")) .. "}"
		end
	},
	ObjectField = {
		leave = function(_, p)
			local name = p.name
			local value = p.value
			return tostring(name) .. ": " .. tostring(value)
		end
	},
	Directive = {
		leave = function(_, p)
			local name = p.name
			local arguments = p.arguments
			return "@" .. tostring(name) .. tostring(wrap("(", join(arguments, ", "), ")")) -- inferred equivalent call
		end
	},
	NamedType = {
		leave = function(_, p)
			return p.name
		end
	},
	ListType = {
		leave = function(_, p)
			return "[" .. tostring(p.type) .. "]"
		end
	},
	NonNullType = {
		leave = function(_, p)
			return tostring(p.type) .. "!"
		end
	},
	SchemaDefinition = {
		leave = function(_, p)
			local directives = p.directives
			local operationTypes = p.operationTypes
			return join({ "schema", join(directives, " "), block(operationTypes) }, " ") -- inferred equivalent call
		end
	},
	OperationTypeDefinition = {
		leave = function(_, p)
			local operation = p.operation
			local kind = p.type
			return tostring(operation) .. ": " .. tostring(kind)
		end
	},
	ScalarTypeDefinition = {
		leave = function(_, p)
			return join({ "scalar", p.name, join(p.directives, " ") }, " ")
		end
	},
	ObjectTypeDefinition = {
		leave = function(_, data)
			local name = data.name
			local interfaces = data.interfaces
			local directives = data.directives
			local fields = data.fields

			local v2 = join(interfaces, " & ")
			local v3

			if Boolean.toJSBoolean(v2) then
				local v4 = tostring(v2)
				Boolean.toJSBoolean(nil)
				v3 = "implements " .. v4 .. ""
			else
				v3 = ""
			end

			return join({ "type", name, v3, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	},
	FieldDefinition = {
		leave = function(_, data)
			local name = data.name
			local arguments = data.arguments
			local kind = data.type
			local directives = data.directives

			local v2 = tostring(name)
			local v3

			if typeof(arguments) == "table" then
				v3 = Array.some(arguments, function(p)
					return String.includes(p, "\n")
				end)
			end

			if v3 == nil then
				v3 = false
			end

			local v4

			if v3 then
				v4 = wrap("(\n", indent(join(arguments, "\n")), "\n)") -- inferred equivalent call
			else
				v4 = wrap("(", join(arguments, ", "), ")") -- inferred equivalent call
			end

			local v5 = tostring(kind)
			local v6 = join(directives, " ")
			local v7

			if Boolean.toJSBoolean(v6) then
				local v8 = tostring(v6)
				Boolean.toJSBoolean(nil)
				v7 = " " .. v8 .. ""
			else
				v7 = ""
			end

			return v2 .. v4 .. ": " .. v5 .. v7
		end
	},
	InputValueDefinition = {
		leave = function(_, data)
			local name = data.name
			local kind = data.type
			local defaultValue = data.defaultValue
			local directives = data.directives

			local v2 = tostring(name) .. ": " .. tostring(kind)
			local v3

			if Boolean.toJSBoolean(defaultValue) then
				local v4 = tostring(defaultValue)
				Boolean.toJSBoolean(nil)
				v3 = "= " .. v4 .. ""
			else
				v3 = ""
			end

			return join({ v2, v3, join(directives, " ") }, " ")
		end
	},
	InterfaceTypeDefinition = {
		leave = function(_, data)
			local name = data.name
			local interfaces = data.interfaces
			local directives = data.directives
			local fields = data.fields

			local v2 = join(interfaces, " & ")
			local v3

			if Boolean.toJSBoolean(v2) then
				local v4 = tostring(v2)
				Boolean.toJSBoolean(nil)
				v3 = "implements " .. v4 .. ""
			else
				v3 = ""
			end

			return join({ "interface", name, v3, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	},
	UnionTypeDefinition = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local types = data.types
			local v2 = join(directives, " ")
			local v3 = join(types, " | ")
			local v4

			if Boolean.toJSBoolean(v3) then
				local v5 = tostring(v3)
				Boolean.toJSBoolean(nil)
				v4 = "= " .. v5 .. ""
			else
				v4 = ""
			end

			return join({ "union", name, v2, v4 }, " ")
		end
	},
	EnumTypeDefinition = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local values = data.values
			return join({ "enum", name, join(directives, " "), block(values) }, " ") -- inferred equivalent call
		end
	},
	EnumValueDefinition = {
		leave = function(_, p)
			return join({ p.name, join(p.directives, " ") }, " ")
		end
	},
	InputObjectTypeDefinition = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local fields = data.fields
			return join({ "input", name, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	},
	DirectiveDefinition = {
		leave = function(_, data)
			local name = data.name
			local arguments = data.arguments
			local repeatable = data.repeatable
			local locations = data.locations

			local v2 = tostring(name)

			local toJSBoolean = Boolean.toJSBoolean
			local v3

			if typeof(arguments) == "table" then
				v3 = Array.some(arguments, function(p)
					return String.includes(p, "\n")
				end)
			end

			if v3 == nil then
				v3 = false
			end

			local v4

			if toJSBoolean(v3) then
				v4 = wrap("(\n", indent(join(arguments, "\n")), "\n)") -- inferred equivalent call
			else
				v4 = wrap("(", join(arguments, ", "), ")") -- inferred equivalent call
			end

			return "directive @" .. v2 .. tostring(v4) .. (Boolean.toJSBoolean(repeatable) and " repeatable" or "") .. " on " .. tostring(join(locations, " | "))
		end
	},
	SchemaExtension = {
		leave = function(_, p)
			local directives = p.directives
			local operationTypes = p.operationTypes
			return join({ "extend schema", join(directives, " "), block(operationTypes) }, " ") -- inferred equivalent call
		end
	},
	ScalarTypeExtension = {
		leave = function(_, p)
			return join({ "extend scalar", p.name, join(p.directives, " ") }, " ")
		end
	},
	ObjectTypeExtension = {
		leave = function(_, data)
			local name = data.name
			local interfaces = data.interfaces
			local directives = data.directives
			local fields = data.fields

			local v2 = join(interfaces, " & ")
			local v3

			if Boolean.toJSBoolean(v2) then
				local v4 = tostring(v2)
				Boolean.toJSBoolean(nil)
				v3 = "implements " .. v4 .. ""
			else
				v3 = ""
			end

			return join({ "extend type", name, v3, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	},
	InterfaceTypeExtension = {
		leave = function(_, data)
			local name = data.name
			local interfaces = data.interfaces
			local directives = data.directives
			local fields = data.fields

			local v2 = join(interfaces, " & ")
			local v3

			if Boolean.toJSBoolean(v2) then
				local v4 = tostring(v2)
				Boolean.toJSBoolean(nil)
				v3 = "implements " .. v4 .. ""
			else
				v3 = ""
			end

			return join({ "extend interface", name, v3, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	},
	UnionTypeExtension = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local types = data.types
			local v2 = join(directives, " ")
			local v3 = join(types, " | ")
			local v4

			if Boolean.toJSBoolean(v3) then
				local v5 = tostring(v3)
				Boolean.toJSBoolean(nil)
				v4 = "= " .. v5 .. ""
			else
				v4 = ""
			end

			return join({ "extend union", name, v2, v4 }, " ")
		end
	},
	EnumTypeExtension = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local values = data.values
			return join({ "extend enum", name, join(directives, " "), block(values) }, " ") -- inferred equivalent call
		end
	},
	InputObjectTypeExtension = {
		leave = function(_, data)
			local name = data.name
			local directives = data.directives
			local fields = data.fields
			return join({ "extend input", name, join(directives, " "), block(fields) }, " ") -- inferred equivalent call
		end
	}
}

local reduced = Array.reduce(Object.keys(v2), function(p, p2)
	return (Object.assign({}, p, {
		[p2] = { leave = addDescription(v2[p2].leave) } -- inferred equivalent call
	}))
end, {})

function Comments.printWithComments(p)
	return (visit(p, reduced))
end

isFieldDefinitionNode = function(field): boolean
	return field.kind == "FieldDefinition"
end

function Comments.getDescription(p, p2)
	if p.description ~= nil then
		return p.description.value
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v3

	if typeof(p2) == "table" then
		v3 = p2.commentDescriptions
	end

	if toJSBoolean(v3) then
		return getComment(p)
	end

	return nil
end

getComment = function(p)
	local v3 = getLeadingCommentBlock(p)

	if v3 == nil then
		return nil
	end

	return dedentBlockStringValue(("\n%s"):format((tostring(v3))))
end

Comments.getComment = getComment

getLeadingCommentBlock = function(p)
	local loc = p.loc

	if not Boolean.toJSBoolean(loc) then
		return
	end

	local prev = loc.startToken.prev
	local v3 = {}

	while
		prev ~= nil
		and prev.kind == TokenKind.COMMENT
		and prev.next ~= nil
		and prev.prev ~= nil
		and prev.line + 1 == prev.next.line
		and prev.line ~= prev.prev.line
	do
		table.insert(v3, (tostring(prev.value)))
		prev = prev.prev
	end

	if #v3 > 0 then
		return (Array.join(Array.reverse(v3), "\n"))
	end

	return nil
end

Comments.getLeadingCommentBlock = getLeadingCommentBlock

dedentBlockStringValue = function(p: string)
	local parts = String.split(p, { "\r\n", "\n", "\r" })

	local v3 = getBlockStringIndentation(parts)

	if v3 ~= 0 then
		local v4 = 2

		while v4 <= #parts do
			parts[v4] = String.slice(parts[v4], v3 + 1)

			v4 += 1
		end
	end

	while #parts > 0 and isBlank(parts[1]) do
		table.remove(parts, 1)
	end

	while #parts > 0 and isBlank(parts[#parts]) do
		table.remove(parts)
	end

	return Array.join(parts, "\n")
end

Comments.dedentBlockStringValue = dedentBlockStringValue

getBlockStringIndentation = function(parts)
	local v3 = 2
	local v4 = nil

	while v3 <= #parts do
		local item = parts[v3]

		local v5 = leadingWhitespace(item)

		if v5 ~= #item and (v4 == nil or v5 < v4) then
			if v5 == 0 then
				v4 = v5
				break
			end

			v4 = v5
		end

		v3 += 1
	end

	return if v4 == nil then 0 else v4
end

Comments.getBlockStringIndentation = getBlockStringIndentation

leadingWhitespace = function(value: string)
	local count = 0

	while count < #value and (value:sub(count + 1, count + 1) == " " or value:sub(count + 1, count + 1) == "\t") do
		count += 1
	end

	return count
end

isBlank = function(list: string): boolean
	return leadingWhitespace(list) == #list
end

return Comments
