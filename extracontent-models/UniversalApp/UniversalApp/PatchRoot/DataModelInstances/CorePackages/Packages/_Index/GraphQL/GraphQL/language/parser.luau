local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent

require(scriptParentParentParent.LuauPolyfill)
require(scriptParentParent.error)

local tokenKind = require(scriptParent.tokenKind)
local Location = require(scriptParent.ast).Location
local Source = require(scriptParent.source).Source
local lexer = require(scriptParent.lexer)
local Lexer = lexer.Lexer
local isPunctuatorTokenKind = lexer.isPunctuatorTokenKind
local TokenKind = tokenKind.TokenKind
local DirectiveLocation = require(scriptParent.directiveLocation).DirectiveLocation
local Kind = require(scriptParent.kinds).Kind
local syntaxError = require(script.Parent.Parent.error.syntaxError).syntaxError
local getTokenDesc = nil
local getTokenKindDesc = nil
local t1 = {}

t1.__index = t1

function t1.new(p1, t2: {[any]: any}?) -- line: 262
	-- upvalues: Source (copy), Lexer (copy), t1 (copy)
	local v29 = if typeof(p1) ~= "string" then p1 else Source.new(p1)

	return (setmetatable({
		_lexer = Lexer.new(v29),
		_options = t2
	}, t1))
end
function t1.parseName(p2) -- line: 280
	-- upvalues: TokenKind (copy), Kind (copy)
	local v31 = p2:expectToken(TokenKind.NAME)

	return {
		kind = Kind.NAME,
		value = v31.value,
		loc = p2:loc(v31)
	}
end
function t1.parseDocument(p3) -- line: 294
	-- upvalues: Kind (copy), TokenKind (copy)
	local token = p3._lexer.token

	return {
		kind = Kind.DOCUMENT,
		definitions = p3:many(TokenKind.SOF, p3.parseDefinition, TokenKind.EOF),
		loc = p3:loc(token)
	}
end
function t1.parseDefinition(p4) -- line: 314
	-- upvalues: TokenKind (copy)
	if p4:peek(TokenKind.NAME) then
		local value = p4._lexer.token.value

		if value == "query" or value == "mutation" or value == "subscription" then
			return p4:parseOperationDefinition()
		end

		if value == "fragment" then
			return p4:parseFragmentDefinition()
		end

		if value == "schema" or value == "scalar" or value == "type" or value == "interface" or value == "union" or value == "enum" or value == "input" or value == "directive" then
			return p4:parseTypeSystemDefinition()
		end

		if value == "extend" then
			return p4:parseTypeSystemExtension()
		end
	else
		if p4:peek(TokenKind.BRACE_L) then
			return p4:parseOperationDefinition()
		end

		if p4:peekDescription() then
			return p4:parseTypeSystemDefinition()
		end
	end

	error(p4:unexpected())
end
function t1.parseOperationDefinition(p5) -- line: 351
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p5._lexer.token

	if p5:peek(TokenKind.BRACE_L) then
		return {
			operation = "query",
			name = nil,
			kind = Kind.OPERATION_DEFINITION,
			variableDefinitions = {},
			directives = {},
			selectionSet = p5:parseSelectionSet(),
			loc = p5:loc(token)
		}
	end

	local v38 = p5:parseOperationType()
	local v39 = nil

	if p5:peek(TokenKind.NAME) then
		v39 = p5:parseName()
	end

	return {
		kind = Kind.OPERATION_DEFINITION,
		operation = v38,
		name = v39,
		variableDefinitions = p5:parseVariableDefinitions(),
		directives = p5:parseDirectives(false),
		selectionSet = p5:parseSelectionSet(),
		loc = p5:loc(token)
	}
end
function t1.parseOperationType(p6) -- line: 384
	-- upvalues: TokenKind (copy)
	local v41 = p6:expectToken(TokenKind.NAME)

	if v41.value == "query" then
		return "query"
	end

	if v41.value == "mutation" then
		return "mutation"
	end

	if v41.value == "subscription" then
		return "subscription"
	end

	error(p6:unexpected(v41))
end
function t1.parseVariableDefinitions(p7) -- line: 401
	-- upvalues: TokenKind (copy)
	return p7:optionalMany(TokenKind.PAREN_L, p7.parseVariableDefinition, TokenKind.PAREN_R)
end
function t1.parseVariableDefinition(p8) -- line: 408
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p8._lexer.token
	local v45 = p8:parseVariable()

	p8:expectToken(TokenKind.COLON)

	local v46 = p8:parseTypeReference()

	return {
		kind = Kind.VARIABLE_DEFINITION,
		variable = v45,
		type = v46,
		defaultValue = if not p8:expectOptionalToken(TokenKind.EQUALS) then nil else p8:parseValueLiteral(true),
		directives = p8:parseDirectives(true),
		loc = p8:loc(token)
	}
end
function t1.parseVariable(p9) -- line: 428
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p9._lexer.token

	p9:expectToken(TokenKind.DOLLAR)

	return {
		kind = Kind.VARIABLE,
		name = p9:parseName(),
		loc = p9:loc(token)
	}
end
function t1.parseSelectionSet(p10) -- line: 441
	-- upvalues: Kind (copy), TokenKind (copy)
	local token = p10._lexer.token

	return {
		kind = Kind.SELECTION_SET,
		selections = p10:many(TokenKind.BRACE_L, p10.parseSelection, TokenKind.BRACE_R),
		loc = p10:loc(token)
	}
end
function t1.parseSelection(p11) -- line: 456
	-- upvalues: TokenKind (copy)
	if p11:peek(TokenKind.SPREAD) then
		return p11:parseFragment()
	end

	return p11:parseField()
end
function t1.parseField(p12) -- line: 469
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p12._lexer.token
	local v54 = p12:parseName()
	local v55 = nil

	if p12:expectOptionalToken(TokenKind.COLON) then
		v55 = v54
		v54 = p12:parseName()
	end

	return {
		kind = Kind.FIELD,
		alias = v55,
		name = v54,
		arguments = p12:parseArguments(false),
		directives = p12:parseDirectives(false),
		selectionSet = p12:peek(TokenKind.BRACE_L) and p12:parseSelectionSet() or nil,
		loc = p12:loc(token)
	}
end
function t1.parseArguments(t3: {[any]: any}, b1: boolean) -- line: 497
	-- upvalues: TokenKind (copy)
	local v58 = if not b1 then t3.parseArgument else t3.parseConstArgument

	return t3:optionalMany(TokenKind.PAREN_L, v58, TokenKind.PAREN_R)
end
function t1.parseArgument(p13) -- line: 510
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p13._lexer.token
	local v61 = p13:parseName()

	p13:expectToken(TokenKind.COLON)

	return {
		kind = Kind.ARGUMENT,
		name = v61,
		value = p13:parseValueLiteral(false),
		loc = p13:loc(token)
	}
end
function t1.parseConstArgument(p14) -- line: 523
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p14._lexer.token
	local v64 = p14:parseName()

	p14:expectToken(TokenKind.COLON)

	local v65 = p14:parseValueLiteral(true)

	return {
		kind = Kind.ARGUMENT,
		name = v64,
		value = v65,
		loc = p14:loc(token)
	}
end
function t1.parseFragment(p15) -- line: 545
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p15._lexer.token

	p15:expectToken(TokenKind.SPREAD)

	local v68 = p15:expectOptionalKeyword("on")

	if not v68 and p15:peek(TokenKind.NAME) then
		return {
			kind = Kind.FRAGMENT_SPREAD,
			name = p15:parseFragmentName(),
			directives = p15:parseDirectives(false),
			loc = p15:loc(token)
		}
	end

	return {
		kind = Kind.INLINE_FRAGMENT,
		typeCondition = if not v68 then nil else p15:parseNamedType(),
		directives = p15:parseDirectives(false),
		selectionSet = p15:parseSelectionSet(),
		loc = p15:loc(token)
	}
end
function t1.parseFragmentDefinition(p16) -- line: 573
	-- upvalues: Kind (copy)
	local token = p16._lexer.token

	p16:expectKeyword("fragment")

	if (p16._options and p16._options.experimentalFragmentVariables) == true then
		local v71 = p16:parseFragmentName()
		local v72 = p16:parseVariableDefinitions()

		p16:expectKeyword("on")

		local v73 = p16:parseNamedType()
		local v74 = p16:parseDirectives(false)
		local v75 = p16:parseSelectionSet()
		local v76 = p16:loc(token)

		return {
			kind = Kind.FRAGMENT_DEFINITION,
			name = v71,
			variableDefinitions = v72,
			typeCondition = v73,
			directives = v74,
			selectionSet = v75,
			loc = v76
		}
	end

	local v77 = p16:parseFragmentName()

	p16:expectKeyword("on")

	local v78 = p16:parseNamedType()
	local v79 = p16:parseDirectives(false)
	local v80 = p16:parseSelectionSet()
	local v81 = p16:loc(token)

	return {
		kind = Kind.FRAGMENT_DEFINITION,
		name = v77,
		typeCondition = v78,
		directives = v79,
		selectionSet = v80,
		loc = v81
	}
end
function t1.parseFragmentName(p17) -- line: 616
	if p17._lexer.token.value == "on" then
		error(p17:unexpected())
	end

	return p17:parseName()
end
function t1.parseValueLiteral(t4: {[any]: any}, b2: boolean) -- line: 643
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = t4._lexer.token
	local kind = token.kind

	if kind == TokenKind.BRACKET_L then
		return t4:parseList(b2)
	end

	if kind == TokenKind.BRACE_L then
		return t4:parseObject(b2)
	end

	if kind == TokenKind.INT then
		t4._lexer:advance()

		return {
			kind = Kind.INT,
			value = token.value,
			loc = t4:loc(token)
		}
	end

	if kind == TokenKind.FLOAT then
		t4._lexer:advance()

		return {
			kind = Kind.FLOAT,
			value = token.value,
			loc = t4:loc(token)
		}
	end

	if kind == TokenKind.STRING or kind == TokenKind.BLOCK_STRING then
		return t4:parseStringLiteral()
	end

	if kind == TokenKind.NAME then
		t4._lexer:advance()

		local value = token.value

		if value == "true" then
			return {
				value = true,
				kind = Kind.BOOLEAN,
				loc = t4:loc(token)
			}
		end

		if value == "false" then
			return {
				value = false,
				kind = Kind.BOOLEAN,
				loc = t4:loc(token)
			}
		end

		if value == "null" then
			return {
				kind = Kind.NULL,
				loc = t4:loc(token)
			}
		end

		return {
			kind = Kind.ENUM,
			value = value,
			loc = t4:loc(token)
		}
	end

	if kind == TokenKind.DOLLAR and not b2 then
		return t4:parseVariable()
	end

	error(t4:unexpected())
end
function t1.parseStringLiteral(p18) -- line: 692
	-- upvalues: Kind (copy), TokenKind (copy)
	local token = p18._lexer.token

	p18._lexer:advance()

	return {
		kind = Kind.STRING,
		value = token.value,
		block = token.kind == TokenKind.BLOCK_STRING,
		loc = p18:loc(token)
	}
end
function t1.parseList(t5: {[any]: any}, b3: boolean) -- line: 708
	-- upvalues: Kind (copy), TokenKind (copy)
	local token = t5._lexer.token

	return {
		kind = Kind.LIST,
		values = t5:any(TokenKind.BRACKET_L, function() -- line: 710
			-- upvalues: t5 (copy), b3 (copy)
			return t5:parseValueLiteral(b3)
		end, TokenKind.BRACKET_R),
		loc = t5:loc(token)
	}
end
function t1.parseObject(t6: {[any]: any}, b4: boolean) -- line: 725
	-- upvalues: Kind (copy), TokenKind (copy)
	local token = t6._lexer.token

	return {
		kind = Kind.OBJECT,
		fields = t6:any(TokenKind.BRACE_L, function() -- line: 727
			-- upvalues: t6 (copy), b4 (copy)
			return t6:parseObjectField(b4)
		end, TokenKind.BRACE_R),
		loc = t6:loc(token)
	}
end
function t1.parseObjectField(t7: {[any]: any}, b5: boolean) -- line: 740
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = t7._lexer.token
	local v99 = t7:parseName()

	t7:expectToken(TokenKind.COLON)

	return {
		kind = Kind.OBJECT_FIELD,
		name = v99,
		value = t7:parseValueLiteral(b5),
		loc = t7:loc(token)
	}
end
function t1.parseDirectives(p19, p20) -- line: 753
	-- upvalues: TokenKind (copy)
	local t8 = {}

	while p19:peek(TokenKind.AT) do
		table.insert(t8, p19:parseDirective(p20))
	end

	return t8
end
function t1.parseDirective(p21, p22) -- line: 764
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p21._lexer.token

	p21:expectToken(TokenKind.AT)

	return {
		kind = Kind.DIRECTIVE,
		name = p21:parseName(),
		arguments = p21:parseArguments(p22),
		loc = p21:loc(token)
	}
end
function t1.parseTypeReference(p23) -- line: 783
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p23._lexer.token
	local t9

	if p23:expectOptionalToken(TokenKind.BRACKET_L) then
		local v108 = p23:parseTypeReference()

		p23:expectToken(TokenKind.BRACKET_R)
		t9 = {
			kind = Kind.LIST_TYPE,
			type = v108,
			loc = p23:loc(token)
		}
	else
		t9 = p23:parseNamedType()
	end

	if p23:expectOptionalToken(TokenKind.BANG) then
		return {
			kind = Kind.NON_NULL_TYPE,
			type = t9,
			loc = p23:loc(token)
		}
	end

	return t9
end
function t1.parseNamedType(p24) -- line: 816
	-- upvalues: Kind (copy)
	local token = p24._lexer.token

	return {
		kind = Kind.NAMED_TYPE,
		name = p24:parseName(),
		loc = p24:loc(token)
	}
end
function t1.parseTypeSystemDefinition(p25) -- line: 839
	-- upvalues: TokenKind (copy)
	local v113 = if not p25:peekDescription() then p25._lexer.token else p25._lexer:lookahead()

	if v113.kind == TokenKind.NAME then
		local value = v113.value

		if value == "schema" then
			return p25:parseSchemaDefinition()
		end

		if value == "scalar" then
			return p25:parseScalarTypeDefinition()
		end

		if value == "type" then
			return p25:parseObjectTypeDefinition()
		end

		if value == "interface" then
			return p25:parseInterfaceTypeDefinition()
		end

		if value == "union" then
			return p25:parseUnionTypeDefinition()
		end

		if value == "enum" then
			return p25:parseEnumTypeDefinition()
		end

		if value == "input" then
			return p25:parseInputObjectTypeDefinition()
		end

		if value == "directive" then
			return p25:parseDirectiveDefinition()
		end
	end

	error(p25:unexpected(v113))
end
function t1.peekDescription(p26) -- line: 869
	-- upvalues: TokenKind (copy)
	return p26:peek(TokenKind.STRING) or p26:peek(TokenKind.BLOCK_STRING)
end
function t1.parseDescription(p27) -- line: 876
	if p27:peekDescription() then
		return p27:parseStringLiteral()
	end
end
function t1.parseSchemaDefinition(p28) -- line: 886
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p28._lexer.token
	local v119 = p28:parseDescription()

	p28:expectKeyword("schema")

	local v120 = p28:parseDirectives(true)
	local v121 = p28:many(TokenKind.BRACE_L, p28.parseOperationTypeDefinition, TokenKind.BRACE_R)

	return {
		kind = Kind.SCHEMA_DEFINITION,
		description = v119,
		directives = v120,
		operationTypes = v121,
		loc = p28:loc(token)
	}
end
function t1.parseOperationTypeDefinition(p29) -- line: 908
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p29._lexer.token
	local v124 = p29:parseOperationType()

	p29:expectToken(TokenKind.COLON)

	local v125 = p29:parseNamedType()

	return {
		kind = Kind.OPERATION_TYPE_DEFINITION,
		operation = v124,
		type = v125,
		loc = p29:loc(token)
	}
end
function t1.parseScalarTypeDefinition(p30) -- line: 925
	-- upvalues: Kind (copy)
	local token = p30._lexer.token
	local v128 = p30:parseDescription()

	p30:expectKeyword("scalar")

	local v129 = p30:parseName()
	local v130 = p30:parseDirectives(true)

	return {
		kind = Kind.SCALAR_TYPE_DEFINITION,
		description = v128,
		name = v129,
		directives = v130,
		loc = p30:loc(token)
	}
end
function t1.parseObjectTypeDefinition(p31) -- line: 945
	-- upvalues: Kind (copy)
	local token = p31._lexer.token
	local v133 = p31:parseDescription()

	p31:expectKeyword("type")

	local v134 = p31:parseName()
	local v135 = p31:parseImplementsInterfaces()
	local v136 = p31:parseDirectives(true)
	local v137 = p31:parseFieldsDefinition()

	return {
		kind = Kind.OBJECT_TYPE_DEFINITION,
		description = v133,
		name = v134,
		interfaces = v135,
		directives = v136,
		fields = v137,
		loc = p31:loc(token)
	}
end
function t1.parseImplementsInterfaces(p32) -- line: 969
	-- upvalues: TokenKind (copy)
	if p32:expectOptionalKeyword("implements") then
		return p32:delimitedMany(TokenKind.AMP, p32.parseNamedType)
	end

	return {}
end
function t1.parseFieldsDefinition(p33) -- line: 980
	-- upvalues: TokenKind (copy)
	return p33:optionalMany(TokenKind.BRACE_L, p33.parseFieldDefinition, TokenKind.BRACE_R)
end
function t1.parseFieldDefinition(p34) -- line: 988
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p34._lexer.token
	local v142 = p34:parseDescription()
	local v143 = p34:parseName()
	local v144 = p34:parseArgumentDefs()

	p34:expectToken(TokenKind.COLON)

	local v145 = p34:parseTypeReference()
	local v146 = p34:parseDirectives(true)

	return {
		kind = Kind.FIELD_DEFINITION,
		description = v142,
		name = v143,
		arguments = v144,
		type = v145,
		directives = v146,
		loc = p34:loc(token)
	}
end
function t1.parseArgumentDefs(p35) -- line: 1010
	-- upvalues: TokenKind (copy)
	return p35:optionalMany(TokenKind.PAREN_L, p35.parseInputValueDef, TokenKind.PAREN_R)
end
function t1.parseInputValueDef(p36) -- line: 1018
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p36._lexer.token
	local v150 = p36:parseDescription()
	local v151 = p36:parseName()

	p36:expectToken(TokenKind.COLON)

	local v152 = p36:parseTypeReference()
	local v153 = nil

	if p36:expectOptionalToken(TokenKind.EQUALS) then
		v153 = p36:parseValueLiteral(true)
	end

	local v154 = p36:parseDirectives(true)

	return {
		kind = Kind.INPUT_VALUE_DEFINITION,
		description = v150,
		name = v151,
		type = v152,
		defaultValue = v153,
		directives = v154,
		loc = p36:loc(token)
	}
end
function t1.parseInterfaceTypeDefinition(p37) -- line: 1044
	-- upvalues: Kind (copy)
	local token = p37._lexer.token
	local v157 = p37:parseDescription()

	p37:expectKeyword("interface")

	local v158 = p37:parseName()
	local v159 = p37:parseImplementsInterfaces()
	local v160 = p37:parseDirectives(true)
	local v161 = p37:parseFieldsDefinition()

	return {
		kind = Kind.INTERFACE_TYPE_DEFINITION,
		description = v157,
		name = v158,
		interfaces = v159,
		directives = v160,
		fields = v161,
		loc = p37:loc(token)
	}
end
function t1.parseUnionTypeDefinition(p38) -- line: 1067
	-- upvalues: Kind (copy)
	local token = p38._lexer.token
	local v164 = p38:parseDescription()

	p38:expectKeyword("union")

	local v165 = p38:parseName()
	local v166 = p38:parseDirectives(true)
	local v167 = p38:parseUnionMemberTypes()

	return {
		kind = Kind.UNION_TYPE_DEFINITION,
		description = v164,
		name = v165,
		directives = v166,
		types = v167,
		loc = p38:loc(token)
	}
end
function t1.parseUnionMemberTypes(p39) -- line: 1089
	-- upvalues: TokenKind (copy)
	local t10 = {}

	if p39:expectOptionalToken(TokenKind.EQUALS) then
		p39:expectOptionalToken(TokenKind.PIPE)

		repeat
			table.insert(t10, p39:parseNamedType())
		until not p39:expectOptionalToken(TokenKind.PIPE)
	end

	return t10
end
function t1.parseEnumTypeDefinition(p40) -- line: 1105
	-- upvalues: Kind (copy)
	local token = p40._lexer.token
	local v172 = p40:parseDescription()

	p40:expectKeyword("enum")

	local v173 = p40:parseName()
	local v174 = p40:parseDirectives(true)
	local v175 = p40:parseEnumValuesDefinition()

	return {
		kind = Kind.ENUM_TYPE_DEFINITION,
		description = v172,
		name = v173,
		directives = v174,
		values = v175,
		loc = p40:loc(token)
	}
end
function t1.parseEnumValuesDefinition(p41) -- line: 1125
	-- upvalues: TokenKind (copy)
	return p41:optionalMany(TokenKind.BRACE_L, p41.parseEnumValueDefinition, TokenKind.BRACE_R)
end
function t1.parseEnumValueDefinition(p42) -- line: 1134
	-- upvalues: Kind (copy)
	local token = p42._lexer.token
	local v179 = p42:parseDescription()
	local v180 = p42:parseName()
	local v181 = p42:parseDirectives(true)

	return {
		kind = Kind.ENUM_VALUE_DEFINITION,
		description = v179,
		name = v180,
		directives = v181,
		loc = p42:loc(token)
	}
end
function t1.parseInputObjectTypeDefinition(p43) -- line: 1152
	-- upvalues: Kind (copy)
	local token = p43._lexer.token
	local v184 = p43:parseDescription()

	p43:expectKeyword("input")

	local v185 = p43:parseName()
	local v186 = p43:parseDirectives(true)
	local v187 = p43:parseInputFieldsDefinition()

	return {
		kind = Kind.INPUT_OBJECT_TYPE_DEFINITION,
		description = v184,
		name = v185,
		directives = v186,
		fields = v187,
		loc = p43:loc(token)
	}
end
function t1.parseInputFieldsDefinition(p44) -- line: 1172
	-- upvalues: TokenKind (copy)
	return p44:optionalMany(TokenKind.BRACE_L, p44.parseInputValueDef, TokenKind.BRACE_R)
end
function t1.parseTypeSystemExtension(p45) -- line: 1189
	-- upvalues: TokenKind (copy)
	local v190 = p45._lexer:lookahead()

	if v190.kind == TokenKind.NAME then
		local value = v190.value

		if value == "schema" then
			return p45:parseSchemaExtension()
		end

		if value == "scalar" then
			return p45:parseScalarTypeExtension()
		end

		if value == "type" then
			return p45:parseObjectTypeExtension()
		end

		if value == "interface" then
			return p45:parseInterfaceTypeExtension()
		end

		if value == "union" then
			return p45:parseUnionTypeExtension()
		end

		if value == "enum" then
			return p45:parseEnumTypeExtension()
		end

		if value == "input" then
			return p45:parseInputObjectTypeExtension()
		end
	end

	error(p45:unexpected(v190))
end
function t1.parseSchemaExtension(p46) -- line: 1219
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p46._lexer.token

	p46:expectKeyword("extend")
	p46:expectKeyword("schema")

	local v194 = p46:parseDirectives(true)
	local v195 = p46:optionalMany(TokenKind.BRACE_L, p46.parseOperationTypeDefinition, TokenKind.BRACE_R)

	if #v194 == 0 and #v195 == 0 then
		error(p46:unexpected())
	end

	return {
		kind = Kind.SCHEMA_EXTENSION,
		directives = v194,
		operationTypes = v195,
		loc = p46:loc(token)
	}
end
function t1.parseScalarTypeExtension(p47) -- line: 1244
	-- upvalues: Kind (copy)
	local token = p47._lexer.token

	p47:expectKeyword("extend")
	p47:expectKeyword("scalar")

	local v198 = p47:parseName()
	local v199 = p47:parseDirectives(true)

	if #v199 == 0 then
		error(p47:unexpected())
	end

	return {
		kind = Kind.SCALAR_TYPE_EXTENSION,
		name = v198,
		directives = v199,
		loc = p47:loc(token)
	}
end
function t1.parseObjectTypeExtension(p48) -- line: 1267
	-- upvalues: Kind (copy)
	local token = p48._lexer.token

	p48:expectKeyword("extend")
	p48:expectKeyword("type")

	local v202 = p48:parseName()
	local v203 = p48:parseImplementsInterfaces()
	local v204 = p48:parseDirectives(true)
	local v205 = p48:parseFieldsDefinition()

	if #v203 == 0 and (#v204 == 0 and #v205 == 0) then
		error(p48:unexpected())
	end

	return {
		kind = Kind.OBJECT_TYPE_EXTENSION,
		name = v202,
		interfaces = v203,
		directives = v204,
		fields = v205,
		loc = p48:loc(token)
	}
end
function t1.parseInterfaceTypeExtension(p49) -- line: 1294
	-- upvalues: Kind (copy)
	local token = p49._lexer.token

	p49:expectKeyword("extend")
	p49:expectKeyword("interface")

	local v208 = p49:parseName()
	local v209 = p49:parseImplementsInterfaces()
	local v210 = p49:parseDirectives(true)
	local v211 = p49:parseFieldsDefinition()

	if #v209 == 0 and (#v210 == 0 and #v211 == 0) then
		error(p49:unexpected())
	end

	return {
		kind = Kind.INTERFACE_TYPE_EXTENSION,
		name = v208,
		interfaces = v209,
		directives = v210,
		fields = v211,
		loc = p49:loc(token)
	}
end
function t1.parseUnionTypeExtension(p50) -- line: 1320
	-- upvalues: Kind (copy)
	local token = p50._lexer.token

	p50:expectKeyword("extend")
	p50:expectKeyword("union")

	local v214 = p50:parseName()
	local v215 = p50:parseDirectives(true)
	local v216 = p50:parseUnionMemberTypes()

	if #v215 == 0 and #v216 == 0 then
		error(p50:unexpected())
	end

	return {
		kind = Kind.UNION_TYPE_EXTENSION,
		name = v214,
		directives = v215,
		types = v216,
		loc = p50:loc(token)
	}
end
function t1.parseEnumTypeExtension(p51) -- line: 1344
	-- upvalues: Kind (copy)
	local token = p51._lexer.token

	p51:expectKeyword("extend")
	p51:expectKeyword("enum")

	local v219 = p51:parseName()
	local v220 = p51:parseDirectives(true)
	local v221 = p51:parseEnumValuesDefinition()

	if #v220 == 0 and #v221 == 0 then
		error(p51:unexpected())
	end

	return {
		kind = Kind.ENUM_TYPE_EXTENSION,
		name = v219,
		directives = v220,
		values = v221,
		loc = p51:loc(token)
	}
end
function t1.parseInputObjectTypeExtension(p52) -- line: 1368
	-- upvalues: Kind (copy)
	local token = p52._lexer.token

	p52:expectKeyword("extend")
	p52:expectKeyword("input")

	local v224 = p52:parseName()
	local v225 = p52:parseDirectives(true)
	local v226 = p52:parseInputFieldsDefinition()

	if #v225 == 0 and #v226 == 0 then
		error(p52:unexpected())
	end

	return {
		kind = Kind.INPUT_OBJECT_TYPE_EXTENSION,
		name = v224,
		directives = v225,
		fields = v226,
		loc = p52:loc(token)
	}
end
function t1.parseDirectiveDefinition(p53) -- line: 1391
	-- upvalues: TokenKind (copy), Kind (copy)
	local token = p53._lexer.token
	local v229 = p53:parseDescription()

	p53:expectKeyword("directive")
	p53:expectToken(TokenKind.AT)

	local v230 = p53:parseName()
	local v231 = p53:parseArgumentDefs()
	local v232 = p53:expectOptionalKeyword("repeatable")

	p53:expectKeyword("on")

	local v233 = p53:parseDirectiveLocations()

	return {
		kind = Kind.DIRECTIVE_DEFINITION,
		description = v229,
		name = v230,
		arguments = v231,
		repeatable = v232,
		locations = v233,
		loc = p53:loc(token)
	}
end
function t1.parseDirectiveLocations(p54) -- line: 1417
	-- upvalues: TokenKind (copy)
	p54:expectOptionalToken(TokenKind.PIPE)

	local t11 = {}

	repeat
		table.insert(t11, p54:parseDirectiveLocation())
	until not p54:expectOptionalToken(TokenKind.PIPE)

	return t11
end
function t1.parseDirectiveLocation(p55) -- line: 1454
	-- upvalues: DirectiveLocation (copy)
	local token = p55._lexer.token
	local v238 = p55:parseName()

	if DirectiveLocation[v238.value] ~= nil then
		return v238
	end

	error(p55:unexpected(token))
end
function t1.loc(p56, p57) -- line: 1467
	-- upvalues: Location (copy)
	if (p56._options and p56._options.noLocation) ~= true then
		return Location.new(p57, p56._lexer.lastToken, p56._lexer.source)
	end

	return nil
end
function t1.peek(p58, p59) -- line: 1477
	return p59 == p58._lexer.token.kind
end
function t1.expectToken(p60, p61) -- line: 1485
	-- upvalues: syntaxError (copy), getTokenKindDesc (ref), getTokenDesc (ref)
	local token = p60._lexer.token

	if p61 == token.kind then
		p60._lexer:advance()

		return token
	end

	error(syntaxError(p60._lexer.source, token.start, "Expected " .. getTokenKindDesc(p61) .. ", found " .. getTokenDesc(token) .. "."))
end
function t1.expectOptionalToken(p62, p63) -- line: 1505
	local token = p62._lexer.token

	if p63 == token.kind then
		p62._lexer:advance()

		return token
	end

	return nil
end
function t1.expectKeyword(t12: {[any]: any}, s1: string) -- line: 1518
	-- upvalues: TokenKind (copy), syntaxError (copy), getTokenDesc (ref)
	local token = t12._lexer.token

	if token.kind == TokenKind.NAME and s1 == token.value then
		t12._lexer:advance()

		return
	end

	error(syntaxError(t12._lexer.source, token.start, "Expected \"" .. s1 .. "\", found " .. getTokenDesc(token) .. "."))
end
function t1.expectOptionalKeyword(t13: {[any]: any}, s2: string) -- line: 1537
	-- upvalues: TokenKind (copy)
	local token = t13._lexer.token

	if token.kind == TokenKind.NAME and s2 == token.value then
		t13._lexer:advance()

		return true
	end

	return false
end
function t1.unexpected(p64, p65) -- line: 1550
	-- upvalues: syntaxError (copy), getTokenDesc (ref)
	local v257 = p65 ~= nil and p65 or p64._lexer.token

	return syntaxError(p64._lexer.source, v257.start, "Unexpected " .. getTokenDesc(v257) .. ".")
end
function t1.any(t14: {[any]: any}, p66, p67: ((...any) -> ...any), p68) -- line: 1561
	t14:expectToken(p66)

	local t15 = {}

	while not t14:expectOptionalToken(p68) do
		table.insert(t15, p67(t14))
	end

	return t15
end
function t1.optionalMany(t16: {[any]: any}, p69, p70: ((...any) -> ...any), p71) -- line: 1582
	if t16:expectOptionalToken(p69) then
		local t17 = {}

		repeat
			table.insert(t17, p70(t16))
		until t16:expectOptionalToken(p71)

		return t17
	end

	return {}
end
function t1.many(t18: {[any]: any}, p72, p73: ((...any) -> ...any), p74) -- line: 1604
	t18:expectToken(p72)

	local t19 = {}

	repeat
		table.insert(t19, p73(t18))
	until t18:expectOptionalToken(p74)

	return t19
end
function t1.delimitedMany(t20: {[any]: any}, p75, p76: ((...any) -> ...any)) -- line: 1623
	t20:expectOptionalToken(p75)

	local t21 = {}

	repeat
		table.insert(t21, p76(t20))
	until not t20:expectOptionalToken(p75)

	return t21
end
function getTokenDesc(p77) -- line: 1640
	-- upvalues: getTokenKindDesc (ref)
	local value = p77.value

	return getTokenKindDesc(p77.kind) .. (value ~= nil and " \"" .. value .. "\"" or "")
end
function getTokenKindDesc(p78) -- line: 1648
	-- upvalues: isPunctuatorTokenKind (copy)
	return isPunctuatorTokenKind(p78) and "\"" .. p78 .. "\"" or p78
end

return {
	Parser = t1,
	parse = function(p79, t22: {[any]: any}?) -- line: 221
		-- upvalues: t1 (copy)
		return t1.new(p79, t22):parseDocument()
	end,
	parseValue = function(p80, t23: {[any]: any}?) -- line: 236
		-- upvalues: t1 (copy), TokenKind (copy)
		local v21 = t1.new(p80, t23)

		v21:expectToken(TokenKind.SOF)

		local v22 = v21:parseValueLiteral(false)

		v21:expectToken(TokenKind.EOF)

		return v22
	end,
	parseType = function(p81, t24: {[any]: any}?) -- line: 254
		-- upvalues: t1 (copy), TokenKind (copy)
		local v25 = t1.new(p81, t24)

		v25:expectToken(TokenKind.SOF)

		local v26 = v25:parseTypeReference()

		v25:expectToken(TokenKind.EOF)

		return v26
	end
}
