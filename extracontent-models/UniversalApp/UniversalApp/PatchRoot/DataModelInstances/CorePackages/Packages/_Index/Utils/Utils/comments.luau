local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}

require(script.Parent.types)

local GraphQL = require(ParentParent.GraphQL)
local visit = GraphQL.visit
local TokenKind = GraphQL.TokenKind

require(ParentParent.GraphQL)

local pushComment = nil
local isFieldDefinitionNode = nil
local getComment = nil
local getLeadingCommentBlock = nil
local dedentBlockStringValue = nil
local getBlockStringIndentation = nil
local isBlank = nil
local leadingWhitespace = nil
local String = LuauPolyfill.String
local t2 = {}

function t1.resetComments() -- line: 62
	-- upvalues: t2 (ref)
	t2 = {}
end
function t1.collectComment(p1) -- line: 66
	-- upvalues: pushComment (ref), Boolean (copy), isFieldDefinitionNode (ref)
	local v31 = if typeof(p1.name) ~= "table" then nil else p1.name.value

	if v31 == nil then
		return
	end

	pushComment(p1, v31)

	local kind = p1.kind

	if kind == "EnumTypeDefinition" then
		if Boolean.toJSBoolean(p1.values) then
			for _, v34 in p1.values do
				pushComment(v34, v31, v34.name.value)
			end

			return
		end
	elseif (kind == "ObjectTypeDefinition" or kind == "InputObjectTypeDefinition" or kind == "InterfaceTypeDefinition") and Boolean.toJSBoolean(p1.fields) then
		for _, v36 in p1.fields do
			pushComment(v36, v31, v36.name.value)

			local toJSBoolean = Boolean.toJSBoolean
			local v38 = isFieldDefinitionNode(v36)

			if toJSBoolean(if not Boolean.toJSBoolean(v38) then v38 else v36.arguments) then
				for _, v40 in v36.arguments do
					pushComment(v40, v31, v36.name.value, v40.name.value)
				end
			end
		end
	end
end
function pushComment(p2, s1: string, s2: string?, s3: string?) -- line: 123
	-- upvalues: getComment (ref), Boolean (copy), Array (copy), t2 (ref)
	local v45 = getComment(p2)

	if typeof(v45) ~= "string" or #v45 == 0 then
		return
	end

	local t3 = { s1 }

	if Boolean.toJSBoolean(s2) then
		table.insert(t3, s2)

		if Boolean.toJSBoolean(s3) then
			table.insert(t3, s3)
		end
	end

	local v47 = Array.join(t3, ".")

	if not Boolean.toJSBoolean(t2[tostring(v47)]) then
		t2[tostring(v47)] = {}
	end

	table.insert(t2[v47], v45)
end

t1.pushComment = pushComment

local function printComment(s4: string) -- line: 155
	return "\n# " .. s4:gsub("\n", "\n# ")
end

t1.printComment = printComment

local function join(p3, s5: string?) -- line: 183
	-- upvalues: Boolean (copy), Array (copy)
	if Boolean.toJSBoolean(p3) then
		return (Array.join(Array.filter(p3, function(p4) -- line: 195
			-- upvalues: Boolean (copy)
			return Boolean.toJSBoolean(p4)
		end), Boolean.toJSBoolean(s5) and s5 or ""))
	end

	return ""
end
local function hasMultilineItems(p5) -- line: 205
	-- upvalues: Array (copy), String (copy)
	local v52 = if typeof(p5) ~= "table" then nil else Array.some(p5, function(p6) -- line: 212
		-- upvalues: String (copy)
		return String.includes(p6, "\n")
	end)

	if v52 ~= nil then
		return v52
	end

	return false
end
local function addDescription(p7: ((...any) -> ...any)) -- line: 229
	-- upvalues: Array (copy), Object (copy), Boolean (copy), String (copy), t2 (ref), join (copy), printComment (copy)
	return function(p8, t4: {[any]: any}, s6: string, p9, p10, p11) -- line: 230
		-- upvalues: Array (copy), Object (copy), Boolean (copy), String (copy), t2 (ref), join (copy), printComment (copy), p7 (copy)
		local t5 = {}
		local v374 = Array.reduce(p10, function(p12, p13) -- line: 258
			-- upvalues: Object (copy), Array (copy), Boolean (copy), t5 (copy)
			if p13 ~= Object.None and (Array.includes({
				"fields",
				"arguments",
				"values"
			}, p13) and Boolean.toJSBoolean(p12.name)) then
				table.insert(t5, p12.name.value)
			end

			if p12 == Object.None then
				return p13
			end

			return p12[p13]
		end, p11[1] or Object.None)
		local v375 = Array.join(Array.filter(Array.concat({}, t5, { if typeof((if typeof(v374) ~= "table" then nil else v374.name)) ~= "table" then nil else ((if typeof(v374) ~= "table" then nil else v374.name)).value }), Boolean.toJSBoolean), ".")
		local t6 = {}

		if String.includes(t4.kind, "Definition") and Boolean.toJSBoolean(t2[v375]) then
			t6 = Array.concat(t6, t2[v375])
		end

		return (join(Array.concat({}, Array.map(t6, printComment), {
			t4.description or "",
			(p7(p8, t4, s6, p9, p10, p11))
		}), "\n"))
	end
end
local function indent(s7: string?) -- line: 320
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(s7) then
		return ("  %s"):format((s7:gsub("\n", "\n  ")))
	end

	return s7
end
local function block(p14) -- line: 344
	-- upvalues: indent (copy), join (copy)
	if p14 and #p14 ~= 0 then
		return (("{\n%s\n}"):format(indent((join(p14, "\n")))))
	end

	return ""
end
local function wrap(s8: string, p15, s9: string?) -- line: 363
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p15) then
		return s8 .. tostring(p15) .. (Boolean.toJSBoolean(s9) and s9 or "")
	end

	return ""
end
local function printBlockString(s10: string, b1: boolean?) -- line: 377
	-- upvalues: String (copy), Boolean (copy)
	local v61 = b1 ~= nil and b1
	local v62 = s10:gsub("\"", "\\\"\"\"")

	if (s10:sub(1, 1) == " " or s10:sub(1, 1) == "\t") and String.indexOf(s10, "\n") == -1 then
		return ("\"\"\"%s\"\"\""):format((v62:gsub("\"$", "\"\n")))
	end

	return ("\"\"\"\n%s\n\"\"\""):format(if not Boolean.toJSBoolean(v61) then if not Boolean.toJSBoolean(v62) then v62 else ("  %s"):format((v62:gsub("\n", "\n  "))) else v62)
end

local t15 = {
	Name = {
		leave = function(_, p17) -- line: 417
			return p17.value
		end
	},
	Variable = {
		leave = function(_, p19) -- line: 425
			return "$" .. tostring(p19.name)
		end
	},
	Document = {
		leave = function(_, p21) -- line: 434
			-- upvalues: join (copy)
			return (join(p21.definitions, "\n\n"))
		end
	},
	OperationDefinition = {
		leave = function(_, p23) -- line: 442
			-- upvalues: join (copy), Boolean (copy)
			local v71 = join(p23.variableDefinitions, ", ")
			local v72 = not Boolean.toJSBoolean(v71) and "" or "(" .. tostring(v71) .. (not Boolean.toJSBoolean(")") and "" or ")")

			return tostring((join({
				p23.operation,
				join({
					p23.name,
					v72
				}),
				(join(p23.directives, " "))
			}, " "))) .. " " .. tostring(p23.selectionSet)
		end
	},
	VariableDefinition = {
		leave = function(_, p25) -- line: 452
			-- upvalues: Boolean (copy), join (copy)
			local variable = p25.variable
			local type = p25.type
			local defaultValue = p25.defaultValue
			local directives = p25.directives
			local str = tostring(variable)
			local str2 = tostring(type)
			local v82

			if Boolean.toJSBoolean(defaultValue) then
				local str3 = tostring(defaultValue)

				v82 = if not Boolean.toJSBoolean(nil) then " = " .. str3 .. "" else " = " .. str3 .. ""
			else
				v82 = ""
			end

			local str4 = tostring(v82)
			local v84 = join(directives, " ")
			local v86

			if Boolean.toJSBoolean(v84) then
				local str5 = tostring(v84)

				v86 = if not Boolean.toJSBoolean(nil) then " " .. str5 .. "" else " " .. str5 .. ""
			else
				v86 = ""
			end

			return str .. ": " .. str2 .. str4 .. tostring(v86)
		end
	},
	SelectionSet = {
		leave = function(_, p27) -- line: 466
			-- upvalues: indent (copy), join (copy)
			local selections = p27.selections

			if selections and #selections ~= 0 then
				return (("{\n%s\n}"):format(indent((join(selections, "\n")))))
			end

			return ""
		end
	},
	Field = {
		leave = function(_, p29) -- line: 473
			-- upvalues: Boolean (copy), join (copy)
			local alias = p29.alias
			local name = p29.name
			local arguments = p29.arguments
			local directives = p29.directives
			local selectionSet = p29.selectionSet
			local v97 = (not Boolean.toJSBoolean(alias) and "" or "" .. tostring(alias) .. (not Boolean.toJSBoolean(": ") and "" or ": ")) .. name
			local v98 = join(arguments, ", ")
			local v99 = v97 .. (not Boolean.toJSBoolean(v98) and "" or "(" .. tostring(v98) .. (not Boolean.toJSBoolean(")") and "" or ")"))

			if v99.length > 80 then
				local v100 = join(arguments, "\n")
				local v101 = if not Boolean.toJSBoolean(v100) then v100 else ("  %s"):format((v100:gsub("\n", "\n  ")))

				v99 = v97 .. (not Boolean.toJSBoolean(v101) and "" or "(\n" .. tostring(v101) .. (not Boolean.toJSBoolean("\n)") and "" or "\n)"))
			end

			return (join({
				v99,
				join(directives, " "),
				selectionSet
			}, " "))
		end
	},
	Argument = {
		leave = function(_, p31) -- line: 497
			local name = p31.name
			local value = p31.value

			return tostring(name) .. ": " .. tostring(value)
		end
	},
	FragmentSpread = {
		leave = function(_, p33) -- line: 507
			-- upvalues: join (copy), Boolean (copy)
			local name = p33.name
			local directives = p33.directives
			local str = tostring(name)
			local v111 = join(directives, " ")
			local v113

			if Boolean.toJSBoolean(v111) then
				local str6 = tostring(v111)

				v113 = if not Boolean.toJSBoolean(nil) then " " .. str6 .. "" else " " .. str6 .. ""
			else
				v113 = ""
			end

			return "..." .. str .. tostring(v113)
		end
	},
	InlineFragment = {
		leave = function(_, p35) -- line: 516
			-- upvalues: join (copy), Boolean (copy)
			local typeCondition = p35.typeCondition
			local directives = p35.directives
			local selectionSet = p35.selectionSet
			local v119 = join
			local t7 = {}
			local s11 = "..."
			local v123

			if Boolean.toJSBoolean(typeCondition) then
				local str = tostring(typeCondition)

				v123 = if not Boolean.toJSBoolean(nil) then "on " .. str .. "" else "on " .. str .. ""
			else
				v123 = ""
			end

			local v124 = join(directives, " ")

			t7[1] = s11
			t7[2] = v123
			t7[3] = v124
			t7[4] = selectionSet

			return (v119(t7, " "))
		end
	},
	FragmentDefinition = {
		leave = function(_, p37) -- line: 525
			-- upvalues: join (copy), Boolean (copy)
			local name = p37.name
			local typeCondition = p37.typeCondition
			local variableDefinitions = p37.variableDefinitions
			local directives = p37.directives
			local selectionSet = p37.selectionSet
			local str = tostring(name)
			local v133 = join(variableDefinitions, ", ")
			local v134 = ("fragment %s%s "):format(str, not Boolean.toJSBoolean(v133) and "" or "(" .. tostring(v133) .. (not Boolean.toJSBoolean(")") and "" or ")"))
			local str7 = tostring(typeCondition)
			local v136 = join(directives, " ")

			return v134 .. ("on %s %s"):format(str7, (tostring(not Boolean.toJSBoolean(v136) and "" or "" .. tostring(v136) .. (not Boolean.toJSBoolean(" ") and "" or " ")))) .. tostring(selectionSet)
		end
	},
	IntValue = {
		leave = function(_, p39) -- line: 545
			return p39.value
		end
	},
	FloatValue = {
		leave = function(_, p41) -- line: 554
			return p41.value
		end
	},
	StringValue = {
		leave = function(_, p43) -- line: 563
			-- upvalues: Boolean (copy), printBlockString (copy)
			local value = p43.value
			local block2 = p43.block

			if Boolean.toJSBoolean(block2) then
				return printBlockString(value)
			end

			return "'" .. value:gsub("'", "\\'") .. "'"
		end
	},
	BooleanValue = {
		leave = function(_, p45) -- line: 579
			-- upvalues: Boolean (copy)
			local value = p45.value

			if Boolean.toJSBoolean(value) then
				return "true"
			end

			return "false"
		end
	},
	NullValue = {
		leave = function() -- line: 586
			return "null"
		end
	},
	EnumValue = {
		leave = function(_, p47) -- line: 593
			return p47.value
		end
	},
	ListValue = {
		leave = function(_, p49) -- line: 602
			-- upvalues: join (copy)
			local values = p49.values

			return "[" .. tostring((join(values, ", "))) .. "]"
		end
	},
	ObjectValue = {
		leave = function(_, p51) -- line: 611
			-- upvalues: join (copy)
			local fields = p51.fields

			return "{" .. tostring((join(fields, ", "))) .. "}"
		end
	},
	ObjectField = {
		leave = function(_, p53) -- line: 620
			local name = p53.name
			local value = p53.value

			return tostring(name) .. ": " .. tostring(value)
		end
	},
	Directive = {
		leave = function(_, p55) -- line: 630
			-- upvalues: join (copy), Boolean (copy)
			local name = p55.name
			local arguments = p55.arguments
			local str = tostring(name)
			local v165 = join(arguments, ", ")

			return "@" .. str .. tostring(not Boolean.toJSBoolean(v165) and "" or "(" .. tostring(v165) .. (not Boolean.toJSBoolean(")") and "" or ")"))
		end
	},
	NamedType = {
		leave = function(_, p57) -- line: 640
			return p57.name
		end
	},
	ListType = {
		leave = function(_, p59) -- line: 649
			return "[" .. tostring(p59.type) .. "]"
		end
	},
	NonNullType = {
		leave = function(_, p61) -- line: 658
			return tostring(p61.type) .. "!"
		end
	},
	SchemaDefinition = {
		leave = function(_, p63) -- line: 668
			-- upvalues: join (copy), indent (copy)
			local directives = p63.directives
			local operationTypes = p63.operationTypes

			return (join({
				"schema",
				join(directives, " "),
				(not operationTypes or #operationTypes == 0) and "" or ("{\n%s\n}"):format(indent((join(operationTypes, "\n"))))
			}, " "))
		end
	},
	OperationTypeDefinition = {
		leave = function(_, p65) -- line: 677
			local operation = p65.operation
			local type = p65.type

			return tostring(operation) .. ": " .. tostring(type)
		end
	},
	ScalarTypeDefinition = {
		leave = function(_, p67) -- line: 686
			-- upvalues: join (copy)
			local name = p67.name
			local directives = p67.directives

			return (join({
				"scalar",
				name,
				(join(directives, " "))
			}, " "))
		end
	},
	ObjectTypeDefinition = {
		leave = function(_, p69) -- line: 695
			-- upvalues: join (copy), Boolean (copy), indent (copy)
			local name = p69.name
			local interfaces = p69.interfaces
			local directives = p69.directives
			local fields = p69.fields
			local v190 = join
			local t8 = {}
			local s12 = "type"
			local v193 = join(interfaces, " & ")
			local v195

			if Boolean.toJSBoolean(v193) then
				local str = tostring(v193)

				v195 = if not Boolean.toJSBoolean(nil) then "implements " .. str .. "" else "implements " .. str .. ""
			else
				v195 = ""
			end

			local v196 = join(directives, " ")
			local v197 = (not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))

			t8[1] = s12
			t8[2] = name
			t8[3] = v195
			t8[4] = v196
			t8[5] = v197

			return (v190(t8, " "))
		end
	},
	FieldDefinition = {
		leave = function(_, p71) -- line: 710
			-- upvalues: Array (copy), String (copy), join (copy), Boolean (copy)
			local name = p71.name
			local arguments = p71.arguments
			local type = p71.type
			local directives = p71.directives
			local str = tostring(name)
			local v205 = if typeof(arguments) ~= "table" then nil else Array.some(arguments, function(p72) -- line: 212
				-- upvalues: String (copy)
				return String.includes(p72, "\n")
			end)
			local v208

			if v205 ~= nil and v205 then
				local v206 = join(arguments, "\n")
				local v207 = if not Boolean.toJSBoolean(v206) then v206 else ("  %s"):format((v206:gsub("\n", "\n  ")))

				v208 = not Boolean.toJSBoolean(v207) and "" or "(\n" .. tostring(v207) .. (not Boolean.toJSBoolean("\n)") and "" or "\n)")
			else
				local v209 = join(arguments, ", ")

				v208 = not Boolean.toJSBoolean(v209) and "" or "(" .. tostring(v209) .. (not Boolean.toJSBoolean(")") and "" or ")")
			end

			local str8 = tostring(type)
			local v211 = join(directives, " ")
			local v213

			if Boolean.toJSBoolean(v211) then
				local str9 = tostring(v211)

				v213 = if not Boolean.toJSBoolean(nil) then " " .. str9 .. "" else " " .. str9 .. ""
			else
				v213 = ""
			end

			return str .. v208 .. ": " .. str8 .. v213
		end
	},
	InputValueDefinition = {
		leave = function(_, p74) -- line: 735
			-- upvalues: join (copy), Boolean (copy)
			local name = p74.name
			local type = p74.type
			local defaultValue = p74.defaultValue
			local directives = p74.directives
			local v220 = join
			local t9 = {}
			local v222 = tostring(name) .. ": " .. tostring(type)
			local v224

			if Boolean.toJSBoolean(defaultValue) then
				local str = tostring(defaultValue)

				v224 = if not Boolean.toJSBoolean(nil) then "= " .. str .. "" else "= " .. str .. ""
			else
				v224 = ""
			end

			local v225 = join(directives, " ")

			t9[1] = v222
			t9[2] = v224
			t9[3] = v225

			return (v220(t9, " "))
		end
	},
	InterfaceTypeDefinition = {
		leave = function(_, p76) -- line: 748
			-- upvalues: join (copy), Boolean (copy), indent (copy)
			local name = p76.name
			local interfaces = p76.interfaces
			local directives = p76.directives
			local fields = p76.fields
			local v232 = join
			local t10 = {}
			local s13 = "interface"
			local v235 = join(interfaces, " & ")
			local v237

			if Boolean.toJSBoolean(v235) then
				local str = tostring(v235)

				v237 = if not Boolean.toJSBoolean(nil) then "implements " .. str .. "" else "implements " .. str .. ""
			else
				v237 = ""
			end

			local v238 = join(directives, " ")
			local v239 = (not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))

			t10[1] = s13
			t10[2] = name
			t10[3] = v237
			t10[4] = v238
			t10[5] = v239

			return (v232(t10, " "))
		end
	},
	UnionTypeDefinition = {
		leave = function(_, p78) -- line: 763
			-- upvalues: join (copy), Boolean (copy)
			local name = p78.name
			local directives = p78.directives
			local types = p78.types
			local v245 = join
			local t11 = {}
			local s14 = "union"
			local v248 = join(directives, " ")
			local v249 = join(types, " | ")
			local v251

			if Boolean.toJSBoolean(v249) then
				local str = tostring(v249)

				v251 = if not Boolean.toJSBoolean(nil) then "= " .. str .. "" else "= " .. str .. ""
			else
				v251 = ""
			end

			t11[1] = s14
			t11[2] = name
			t11[3] = v248
			t11[4] = v251

			return (v245(t11, " "))
		end
	},
	EnumTypeDefinition = {
		leave = function(_, p80) -- line: 772
			-- upvalues: join (copy), indent (copy)
			local name = p80.name
			local directives = p80.directives
			local values = p80.values

			return (join({
				"enum",
				name,
				join(directives, " "),
				(not values or #values == 0) and "" or ("{\n%s\n}"):format(indent((join(values, "\n"))))
			}, " "))
		end
	},
	EnumValueDefinition = {
		leave = function(_, p82) -- line: 781
			-- upvalues: join (copy)
			local name = p82.name
			local directives = p82.directives

			return (join({
				name,
				(join(directives, " "))
			}, " "))
		end
	},
	InputObjectTypeDefinition = {
		leave = function(_, p84) -- line: 790
			-- upvalues: join (copy), indent (copy)
			local name = p84.name
			local directives = p84.directives
			local fields = p84.fields

			return (join({
				"input",
				name,
				join(directives, " "),
				(not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))
			}, " "))
		end
	},
	DirectiveDefinition = {
		leave = function(_, p86) -- line: 799
			-- upvalues: Boolean (copy), Array (copy), String (copy), join (copy)
			local name = p86.name
			local arguments = p86.arguments
			local repeatable = p86.repeatable
			local locations = p86.locations
			local str = tostring(name)
			local toJSBoolean = Boolean.toJSBoolean
			local v274 = if typeof(arguments) ~= "table" then nil else Array.some(arguments, function(p87) -- line: 212
				-- upvalues: String (copy)
				return String.includes(p87, "\n")
			end)
			local v277

			if toJSBoolean(v274 ~= nil and v274) then
				local v275 = join(arguments, "\n")
				local v276 = if not Boolean.toJSBoolean(v275) then v275 else ("  %s"):format((v275:gsub("\n", "\n  ")))

				v277 = not Boolean.toJSBoolean(v276) and "" or "(\n" .. tostring(v276) .. (not Boolean.toJSBoolean("\n)") and "" or "\n)")
			else
				local v278 = join(arguments, ", ")

				v277 = not Boolean.toJSBoolean(v278) and "" or "(" .. tostring(v278) .. (not Boolean.toJSBoolean(")") and "" or ")")
			end

			return "directive @" .. str .. tostring(v277) .. (not Boolean.toJSBoolean(repeatable) and "" or " repeatable") .. " on " .. tostring((join(locations, " | ")))
		end
	},
	SchemaExtension = {
		leave = function(_, p89) -- line: 817
			-- upvalues: join (copy), indent (copy)
			local directives = p89.directives
			local operationTypes = p89.operationTypes

			return (join({
				"extend schema",
				join(directives, " "),
				(not operationTypes or #operationTypes == 0) and "" or ("{\n%s\n}"):format(indent((join(operationTypes, "\n"))))
			}, " "))
		end
	},
	ScalarTypeExtension = {
		leave = function(_, p91) -- line: 826
			-- upvalues: join (copy)
			local name = p91.name
			local directives = p91.directives

			return (join({
				"extend scalar",
				name,
				(join(directives, " "))
			}, " "))
		end
	},
	ObjectTypeExtension = {
		leave = function(_, p93) -- line: 835
			-- upvalues: join (copy), Boolean (copy), indent (copy)
			local name = p93.name
			local interfaces = p93.interfaces
			local directives = p93.directives
			local fields = p93.fields
			local v293 = join
			local t12 = {}
			local s15 = "extend type"
			local v296 = join(interfaces, " & ")
			local v298

			if Boolean.toJSBoolean(v296) then
				local str = tostring(v296)

				v298 = if not Boolean.toJSBoolean(nil) then "implements " .. str .. "" else "implements " .. str .. ""
			else
				v298 = ""
			end

			local v299 = join(directives, " ")
			local v300 = (not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))

			t12[1] = s15
			t12[2] = name
			t12[3] = v298
			t12[4] = v299
			t12[5] = v300

			return (v293(t12, " "))
		end
	},
	InterfaceTypeExtension = {
		leave = function(_, p95) -- line: 850
			-- upvalues: join (copy), Boolean (copy), indent (copy)
			local name = p95.name
			local interfaces = p95.interfaces
			local directives = p95.directives
			local fields = p95.fields
			local v307 = join
			local t13 = {}
			local s16 = "extend interface"
			local v310 = join(interfaces, " & ")
			local v312

			if Boolean.toJSBoolean(v310) then
				local str = tostring(v310)

				v312 = if not Boolean.toJSBoolean(nil) then "implements " .. str .. "" else "implements " .. str .. ""
			else
				v312 = ""
			end

			local v313 = join(directives, " ")
			local v314 = (not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))

			t13[1] = s16
			t13[2] = name
			t13[3] = v312
			t13[4] = v313
			t13[5] = v314

			return (v307(t13, " "))
		end
	},
	UnionTypeExtension = {
		leave = function(_, p97) -- line: 865
			-- upvalues: join (copy), Boolean (copy)
			local name = p97.name
			local directives = p97.directives
			local types = p97.types
			local v320 = join
			local t14 = {}
			local s17 = "extend union"
			local v323 = join(directives, " ")
			local v324 = join(types, " | ")
			local v326

			if Boolean.toJSBoolean(v324) then
				local str = tostring(v324)

				v326 = if not Boolean.toJSBoolean(nil) then "= " .. str .. "" else "= " .. str .. ""
			else
				v326 = ""
			end

			t14[1] = s17
			t14[2] = name
			t14[3] = v323
			t14[4] = v326

			return (v320(t14, " "))
		end
	},
	EnumTypeExtension = {
		leave = function(_, p99) -- line: 874
			-- upvalues: join (copy), indent (copy)
			local name = p99.name
			local directives = p99.directives
			local values = p99.values

			return (join({
				"extend enum",
				name,
				join(directives, " "),
				(not values or #values == 0) and "" or ("{\n%s\n}"):format(indent((join(values, "\n"))))
			}, " "))
		end
	},
	InputObjectTypeExtension = {
		leave = function(_, p101) -- line: 883
			-- upvalues: join (copy), indent (copy)
			local name = p101.name
			local directives = p101.directives
			local fields = p101.fields

			return (join({
				"extend input",
				name,
				join(directives, " "),
				(not fields or #fields == 0) and "" or ("{\n%s\n}"):format(indent((join(fields, "\n"))))
			}, " "))
		end
	}
}
local v29 = Array.reduce(Object.keys(t15), function(p102, p103) -- line: 900
	-- upvalues: Object (copy), t15 (copy), Array (copy), Boolean (copy), String (copy), t2 (ref), join (copy), printComment (copy)
	local assign = Object.assign
	local t16 = {}
	local t17 = {}
	local leave = t15[p103].leave

	function t17.leave(p104, t18: {[any]: any}, s18: string, p105, p106, p107) -- line: 230
		-- upvalues: Array (copy), Object (copy), Boolean (copy), String (copy), t2 (ref), join (copy), printComment (copy), leave (copy)
		local t19 = {}
		local v386 = Array.reduce(p106, function(p108, p109) -- line: 258
			-- upvalues: Object (copy), Array (copy), Boolean (copy), t19 (copy)
			if p109 ~= Object.None and (Array.includes({
				"fields",
				"arguments",
				"values"
			}, p109) and Boolean.toJSBoolean(p108.name)) then
				table.insert(t19, p108.name.value)
			end

			if p108 == Object.None then
				return p109
			end

			return p108[p109]
		end, p107[1] or Object.None)
		local v387 = Array.join(Array.filter(Array.concat({}, t19, { if typeof((if typeof(v386) ~= "table" then nil else v386.name)) ~= "table" then nil else ((if typeof(v386) ~= "table" then nil else v386.name)).value }), Boolean.toJSBoolean), ".")
		local t20 = {}

		if String.includes(t18.kind, "Definition") and Boolean.toJSBoolean(t2[v387]) then
			t20 = Array.concat(t20, t2[v387])
		end

		return (join(Array.concat({}, Array.map(t20, printComment), {
			t18.description or "",
			(leave(p104, t18, s18, p105, p106, p107))
		}), "\n"))
	end

	t16[p103] = t17

	return (assign({}, p102, t16))
end, {})

function t1.printWithComments(p110) -- line: 914
	-- upvalues: visit (copy), v29 (copy)
	return (visit(p110, v29))
end
function isFieldDefinitionNode(p111) -- line: 920
	return p111.kind == "FieldDefinition"
end
function t1.getDescription(t21: {[any]: any}, t22: {[any]: any}?) -- line: 926
	-- upvalues: Boolean (copy), getComment (ref)
	if t21.description ~= nil then
		return t21.description.value
	end

	if Boolean.toJSBoolean(if typeof(t22) ~= "table" then nil else t22.commentDescriptions) then
		return getComment(t21)
	end

	return nil
end
function getComment(t23: {[any]: any}) -- line: 945
	-- upvalues: getLeadingCommentBlock (ref), dedentBlockStringValue (ref)
	local v348 = getLeadingCommentBlock(t23)

	if v348 ~= nil then
		return dedentBlockStringValue(("\n%s"):format((tostring(v348))))
	end

	return nil
end

t1.getComment = getComment

function getLeadingCommentBlock(t24: {[any]: any}) -- line: 958
	-- upvalues: Boolean (copy), TokenKind (copy), Array (copy)
	local loc = t24.loc

	if not Boolean.toJSBoolean(loc) then
		return
	end

	local t25 = {}
	local prev = loc.startToken.prev

	while prev ~= nil and prev.kind == TokenKind.COMMENT and prev.next ~= nil and prev.prev ~= nil and prev.line + 1 == prev.next.line and prev.line ~= prev.prev.line do
		table.insert(t25, (tostring(prev.value)))
		prev = prev.prev
	end

	if #t25 > 0 then
		return (Array.join(Array.reverse(t25), "\n"))
	end

	return nil
end

t1.getLeadingCommentBlock = getLeadingCommentBlock

function dedentBlockStringValue(s19: string) -- line: 995
	-- upvalues: String (copy), getBlockStringIndentation (ref), isBlank (ref), Array (copy)
	local v354 = String.split(s19, {
		"\r\n",
		"\n",
		"\r"
	})
	local v355 = getBlockStringIndentation(v354)

	if v355 ~= 0 then
		local n1 = 2

		while n1 <= #v354 do
			v354[n1] = String.slice(v354[n1], v355 + 1)
			n1 += 1
		end
	end

	while #v354 > 0 and isBlank(v354[1]) do
		table.remove(v354, 1)
	end

	while #v354 > 0 and isBlank(v354[#v354]) do
		table.remove(v354)
	end

	return Array.join(v354, "\n")
end

t1.dedentBlockStringValue = dedentBlockStringValue

function getBlockStringIndentation(p112) -- line: 1060
	-- upvalues: leadingWhitespace (ref)
	local v358 = nil
	local n2 = 2

	while n2 <= #p112 do
		local v360 = p112[n2]
		local v361 = leadingWhitespace(v360)

		if v361 == #v360 then
			n2 += 1

			continue
		end

		if v358 == nil or v361 < v358 then
			v358 = v361

			if v358 == 0 then
				break
			end
		end

		n2 += 1
	end

	if v358 == nil then
		return 0
	end

	return v358
end

t1.getBlockStringIndentation = getBlockStringIndentation

function leadingWhitespace(s20: string) -- line: 1107
	local n3 = 0

	while n3 < #s20 and (s20:sub(n3 + 1, n3 + 1) == " " or s20:sub(n3 + 1, n3 + 1) == "\t") do
		n3 += 1
	end

	return n3
end
function isBlank(s21: string) -- line: 1123
	-- upvalues: leadingWhitespace (ref)
	return leadingWhitespace(s21) == #s21
end

return t1
