local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
require(parent3.LuauPolyfill)

require(parent2.error)

local tokenKind = require(parent.tokenKind)

local ast = require(parent.ast)
local location = ast.Location

local source = require(parent.source)
local source2 = source.Source

local lexer = require(parent.lexer)
local lexer2 = lexer.Lexer

local isPunctuatorTokenKind = lexer.isPunctuatorTokenKind

local tokenKind2 = tokenKind.TokenKind
local directiveLocation = require(parent.directiveLocation)
local directiveLocation2 = directiveLocation.DirectiveLocation
local kinds = require(parent.kinds)
local kind = kinds.Kind

local syntaxError = require(script.Parent.Parent.error.syntaxError)
local syntaxError2 = syntaxError.syntaxError

local getTokenDesc
local getTokenKindDesc

local class = {}
class.__index = class

function class.new(value, options)
	if typeof(value) == "string" then
		value = source2.new(value)
	end

	return (setmetatable({ ["_lexer"] = lexer2.new(value), _options = options }, class))
end

function class:parseName()
	local expectToken = self:expectToken(tokenKind2.NAME)
	return { kind = kind.NAME, value = expectToken.value, loc = self:loc(expectToken) }
end

function class:parseDocument()
	local token = self._lexer.token
	return {
		kind = kind.DOCUMENT,
		definitions = self:many(tokenKind2.SOF, self.parseDefinition, tokenKind2.EOF),
		loc = self:loc(token)
	}
end

function class:parseDefinition()
	if self:peek(tokenKind2.NAME) then
		local value = self._lexer.token.value

		if value == "query" or value == "mutation" or value == "subscription" then
			return self:parseOperationDefinition()
		end

		if value == "fragment" then
			return self:parseFragmentDefinition()
		end

		if
			value == "schema"
			or value == "scalar"
			or value == "type"
			or value == "interface"
			or value == "union"
			or value == "enum"
			or value == "input"
			or value == "directive"
		then
			return self:parseTypeSystemDefinition()
		end

		if value == "extend" then
			return self:parseTypeSystemExtension()
		end
	else
		if self:peek(tokenKind2.BRACE_L) then
			return self:parseOperationDefinition()
		end

		if self:peekDescription() then
			return self:parseTypeSystemDefinition()
		end
	end

	error(self:unexpected())
end

function class:parseOperationDefinition()
	local token = self._lexer.token

	if self:peek(tokenKind2.BRACE_L) then
		return {
			kind = kind.OPERATION_DEFINITION,
			operation = "query",
			name = nil,
			variableDefinitions = {},
			directives = {},
			selectionSet = self:parseSelectionSet(),
			loc = self:loc(token)
		}
	end

	local operationType = self:parseOperationType()
	local name

	if self:peek(tokenKind2.NAME) then
		name = self:parseName()
	end

	return {
		kind = kind.OPERATION_DEFINITION,
		operation = operationType,
		name = name,
		variableDefinitions = self:parseVariableDefinitions(),
		directives = self:parseDirectives(false),
		selectionSet = self:parseSelectionSet(),
		loc = self:loc(token)
	}
end

function class:parseOperationType()
	local expectToken = self:expectToken(tokenKind2.NAME)

	if expectToken.value == "query" then
		return "query"
	end

	if expectToken.value == "mutation" then
		return "mutation"
	end

	if expectToken.value == "subscription" then
		return "subscription"
	end

	error(self:unexpected(expectToken))
end

function class:parseVariableDefinitions()
	return self:optionalMany(tokenKind2.PAREN_L, self.parseVariableDefinition, tokenKind2.PAREN_R)
end

function class:parseVariableDefinition()
	local token = self._lexer.token
	local variable = self:parseVariable()
	self:expectToken(tokenKind2.COLON)
	local typeReference = self:parseTypeReference()
	local variableDefinition = {
		kind = kind.VARIABLE_DEFINITION,
		variable = variable,
		type = typeReference,
		defaultValue = 0,
		directives = 0,
		loc = 0
	}
	local defaultValue

	if self:expectOptionalToken(tokenKind2.EQUALS) then
		defaultValue = self:parseValueLiteral(true)
	end

	variableDefinition.defaultValue = defaultValue

	variableDefinition.directives = self:parseDirectives(true)
	variableDefinition.loc = self:loc(token)
	return variableDefinition
end

function class:parseVariable()
	local token = self._lexer.token
	self:expectToken(tokenKind2.DOLLAR)
	return { kind = kind.VARIABLE, name = self:parseName(), loc = self:loc(token) }
end

function class:parseSelectionSet()
	local token = self._lexer.token
	return {
		kind = kind.SELECTION_SET,
		selections = self:many(tokenKind2.BRACE_L, self.parseSelection, tokenKind2.BRACE_R),
		loc = self:loc(token)
	}
end

function class:parseSelection()
	if self:peek(tokenKind2.SPREAD) then
		return self:parseFragment()
	end

	return self:parseField()
end

function class:parseField()
	local token = self._lexer.token

	local name = self:parseName()
	local name2

	if self:expectOptionalToken(tokenKind2.COLON) then
		name2 = self:parseName()
	else
		name2 = name
		name = nil
	end

	local field = {
		kind = kind.FIELD,
		alias = name,
		name = name2,
		arguments = self:parseArguments(false),
		directives = self:parseDirectives(false),
		selectionSet = 0,
		loc = 0
	}
	local selectionSet

	if self:peek(tokenKind2.BRACE_L) then
		selectionSet = self:parseSelectionSet() or nil
	end

	field.selectionSet = selectionSet
	field.loc = self:loc(token)
	return field
end

function class:parseArguments(flag: boolean)
	local v

	if flag then
		v = self.parseConstArgument
	else
		v = self.parseArgument
	end

	return self:optionalMany(tokenKind2.PAREN_L, v, tokenKind2.PAREN_R)
end

function class:parseArgument()
	local token = self._lexer.token
	local name = self:parseName()

	self:expectToken(tokenKind2.COLON)
	return {
		kind = kind.ARGUMENT,
		name = name,
		value = self:parseValueLiteral(false),
		loc = self:loc(token)
	}
end

function class:parseConstArgument()
	local token = self._lexer.token
	local name = self:parseName()
	self:expectToken(tokenKind2.COLON)
	local valueLiteral = self:parseValueLiteral(true)
	return { kind = kind.ARGUMENT, name = name, value = valueLiteral, loc = self:loc(token) }
end

function class:parseFragment()
	local token = self._lexer.token
	self:expectToken(tokenKind2.SPREAD)

	local expectOptionalKeyword = self:expectOptionalKeyword("on")

	if not expectOptionalKeyword and self:peek(tokenKind2.NAME) then
		return {
			kind = kind.FRAGMENT_SPREAD,
			name = self:parseFragmentName(),
			directives = self:parseDirectives(false),
			loc = self:loc(token)
		}
	end

	local v = {
		kind = kind.INLINE_FRAGMENT,
		typeCondition = 0,
		directives = 0,
		selectionSet = 0,
		loc = 0
	}
	local typeCondition

	if expectOptionalKeyword then
		typeCondition = self:parseNamedType()
	end

	v.typeCondition = typeCondition
	v.directives = self:parseDirectives(false)
	v.selectionSet = self:parseSelectionSet()
	v.loc = self:loc(token)
	return v
end

function class:parseFragmentDefinition()
	local token = self._lexer.token
	self:expectKeyword("fragment")

	if (self._options and self._options.experimentalFragmentVariables) == true then
		local fragmentName = self:parseFragmentName()
		local variableDefinitions = self:parseVariableDefinitions()
		self:expectKeyword("on")
		local namedType = self:parseNamedType()
		local directives = self:parseDirectives(false)
		local selectionSet = self:parseSelectionSet()
		local loc = self:loc(token)
		return {
			kind = kind.FRAGMENT_DEFINITION,
			name = fragmentName,
			variableDefinitions = variableDefinitions,
			typeCondition = namedType,
			directives = directives,
			selectionSet = selectionSet,
			loc = loc
		}
	else
		local fragmentName = self:parseFragmentName()
		self:expectKeyword("on")
		local namedType = self:parseNamedType()
		local directives = self:parseDirectives(false)
		local selectionSet = self:parseSelectionSet()
		local loc = self:loc(token)
		return {
			kind = kind.FRAGMENT_DEFINITION,
			name = fragmentName,
			typeCondition = namedType,
			directives = directives,
			selectionSet = selectionSet,
			loc = loc
		}
	end
end

function class:parseFragmentName()
	if self._lexer.token.value == "on" then
		error(self:unexpected())
	end

	return self:parseName()
end

function class:parseValueLiteral(flag: boolean)
	local token = self._lexer.token

	local kind2 = token.kind

	if kind2 == tokenKind2.BRACKET_L then
		return self:parseList(flag)
	end

	if kind2 == tokenKind2.BRACE_L then
		return self:parseObject(flag)
	end

	if kind2 == tokenKind2.INT then
		self._lexer:advance()
		return { kind = kind.INT, value = token.value, loc = self:loc(token) }
	end

	if kind2 == tokenKind2.FLOAT then
		self._lexer:advance()
		return { kind = kind.FLOAT, value = token.value, loc = self:loc(token) }
	end

	if kind2 == tokenKind2.STRING or kind2 == tokenKind2.BLOCK_STRING then
		return self:parseStringLiteral()
	end

	if kind2 == tokenKind2.NAME then
		self._lexer:advance()
		local value = token.value

		if value == "true" then
			return { kind = kind.BOOLEAN, value = true, loc = self:loc(token) }
		elseif value == "false" then
			return { kind = kind.BOOLEAN, value = false, loc = self:loc(token) }
		elseif value == "null" then
			return { kind = kind.NULL, loc = self:loc(token) }
		end

		return { kind = kind.ENUM, value = value, loc = self:loc(token) }
	end

	if kind2 == tokenKind2.DOLLAR and not flag then
		return self:parseVariable()
	end

	error(self:unexpected())
end

function class:parseStringLiteral()
	local token = self._lexer.token
	self._lexer:advance()
	return {
		kind = kind.STRING,
		value = token.value,
		block = token.kind == tokenKind2.BLOCK_STRING,
		loc = self:loc(token)
	}
end

function class:parseList(flag: boolean)
	local token = self._lexer.token
	return {
		kind = kind.LIST,
		values = self:any(tokenKind2.BRACKET_L, function()
			return self:parseValueLiteral(flag)
		end, tokenKind2.BRACKET_R),
		loc = self:loc(token)
	}
end

function class:parseObject(flag: boolean)
	local token = self._lexer.token
	return {
		kind = kind.OBJECT,
		fields = self:any(tokenKind2.BRACE_L, function()
			return self:parseObjectField(flag)
		end, tokenKind2.BRACE_R),
		loc = self:loc(token)
	}
end

function class:parseObjectField(flag: boolean)
	local token = self._lexer.token
	local name = self:parseName()
	self:expectToken(tokenKind2.COLON)

	return {
		kind = kind.OBJECT_FIELD,
		name = name,
		value = self:parseValueLiteral(flag),
		loc = self:loc(token)
	}
end

function class:parseDirectives(p)
	local directives = {}

	while self:peek(tokenKind2.AT) do
		table.insert(directives, self:parseDirective(p))
	end

	return directives
end

function class:parseDirective(p)
	local token = self._lexer.token
	self:expectToken(tokenKind2.AT)
	return {
		kind = kind.DIRECTIVE,
		name = self:parseName(),
		arguments = self:parseArguments(p),
		loc = self:loc(token)
	}
end

function class:parseTypeReference()
	local token = self._lexer.token
	local selected

	if self:expectOptionalToken(tokenKind2.BRACKET_L) then
		local typeReference = self:parseTypeReference()
		self:expectToken(tokenKind2.BRACKET_R)
		selected = { kind = kind.LIST_TYPE, type = typeReference, loc = self:loc(token) }
	else
		selected = self:parseNamedType()
	end

	if self:expectOptionalToken(tokenKind2.BANG) then
		return { kind = kind.NON_NULL_TYPE, type = selected, loc = self:loc(token) }
	end

	return selected
end

function class:parseNamedType()
	local token = self._lexer.token
	return { kind = kind.NAMED_TYPE, name = self:parseName(), loc = self:loc(token) }
end

function class:parseTypeSystemDefinition()
	local v

	if self:peekDescription() then
		v = self._lexer:lookahead()
	else
		v = self._lexer.token
	end

	if v.kind == tokenKind2.NAME then
		local value = v.value

		if value == "schema" then
			return self:parseSchemaDefinition()
		elseif value == "scalar" then
			return self:parseScalarTypeDefinition()
		elseif value == "type" then
			return self:parseObjectTypeDefinition()
		elseif value == "interface" then
			return self:parseInterfaceTypeDefinition()
		elseif value == "union" then
			return self:parseUnionTypeDefinition()
		elseif value == "enum" then
			return self:parseEnumTypeDefinition()
		elseif value == "input" then
			return self:parseInputObjectTypeDefinition()
		elseif value == "directive" then
			return self:parseDirectiveDefinition()
		end
	end

	error(self:unexpected(v))
end

function class:peekDescription()
	return self:peek(tokenKind2.STRING) or self:peek(tokenKind2.BLOCK_STRING)
end

function class:parseDescription()
	if self:peekDescription() then
		return self:parseStringLiteral()
	end
end

function class:parseSchemaDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("schema")
	local directives = self:parseDirectives(true)
	local many = self:many(tokenKind2.BRACE_L, self.parseOperationTypeDefinition, tokenKind2.BRACE_R)

	return {
		kind = kind.SCHEMA_DEFINITION,
		description = description,
		directives = directives,
		operationTypes = many,
		loc = self:loc(token)
	}
end

function class:parseOperationTypeDefinition()
	local token = self._lexer.token

	local operationType = self:parseOperationType()
	self:expectToken(tokenKind2.COLON)
	local namedType = self:parseNamedType()
	return {
		kind = kind.OPERATION_TYPE_DEFINITION,
		operation = operationType,
		type = namedType,
		loc = self:loc(token)
	}
end

function class:parseScalarTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("scalar")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	return {
		kind = kind.SCALAR_TYPE_DEFINITION,
		description = description,
		name = name,
		directives = directives,
		loc = self:loc(token)
	}
end

function class:parseObjectTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("type")
	local name = self:parseName()
	local implementsInterfaces = self:parseImplementsInterfaces()
	local directives = self:parseDirectives(true)
	local fieldsDefinition = self:parseFieldsDefinition()
	return {
		kind = kind.OBJECT_TYPE_DEFINITION,
		description = description,
		name = name,
		interfaces = implementsInterfaces,
		directives = directives,
		fields = fieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseImplementsInterfaces()
	if self:expectOptionalKeyword("implements") then
		return self:delimitedMany(tokenKind2.AMP, self.parseNamedType)
	end

	return {}
end

function class:parseFieldsDefinition()
	return self:optionalMany(tokenKind2.BRACE_L, self.parseFieldDefinition, tokenKind2.BRACE_R)
end

function class:parseFieldDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	local name = self:parseName()
	local argumentDefs = self:parseArgumentDefs()
	self:expectToken(tokenKind2.COLON)
	local typeReference = self:parseTypeReference()
	local directives = self:parseDirectives(true)
	return {
		kind = kind.FIELD_DEFINITION,
		description = description,
		name = name,
		arguments = argumentDefs,
		type = typeReference,
		directives = directives,
		loc = self:loc(token)
	}
end

function class:parseArgumentDefs()
	return self:optionalMany(tokenKind2.PAREN_L, self.parseInputValueDef, tokenKind2.PAREN_R)
end

function class:parseInputValueDef()
	local token = self._lexer.token
	local description = self:parseDescription()
	local name = self:parseName()
	self:expectToken(tokenKind2.COLON)
	local typeReference = self:parseTypeReference()
	local defaultValue

	if self:expectOptionalToken(tokenKind2.EQUALS) then
		defaultValue = self:parseValueLiteral(true)
	end

	local directives = self:parseDirectives(true)
	return {
		kind = kind.INPUT_VALUE_DEFINITION,
		description = description,
		name = name,
		type = typeReference,
		defaultValue = defaultValue,
		directives = directives,
		loc = self:loc(token)
	}
end

function class:parseInterfaceTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("interface")
	local name = self:parseName()
	local implementsInterfaces = self:parseImplementsInterfaces()
	local directives = self:parseDirectives(true)
	local fieldsDefinition = self:parseFieldsDefinition()
	return {
		kind = kind.INTERFACE_TYPE_DEFINITION,
		description = description,
		name = name,
		interfaces = implementsInterfaces,
		directives = directives,
		fields = fieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseUnionTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("union")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local unionMemberTypes = self:parseUnionMemberTypes()
	return {
		kind = kind.UNION_TYPE_DEFINITION,
		description = description,
		name = name,
		directives = directives,
		types = unionMemberTypes,
		loc = self:loc(token)
	}
end

function class:parseUnionMemberTypes()
	local unionMemberTypes = {}

	if not self:expectOptionalToken(tokenKind2.EQUALS) then
		return unionMemberTypes
	end

	self:expectOptionalToken(tokenKind2.PIPE)

	repeat
		table.insert(unionMemberTypes, self:parseNamedType())
	until not self:expectOptionalToken(tokenKind2.PIPE)

	return unionMemberTypes
end

function class:parseEnumTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("enum")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local enumValuesDefinition = self:parseEnumValuesDefinition()
	return {
		kind = kind.ENUM_TYPE_DEFINITION,
		description = description,
		name = name,
		directives = directives,
		values = enumValuesDefinition,
		loc = self:loc(token)
	}
end

function class:parseEnumValuesDefinition()
	return self:optionalMany(tokenKind2.BRACE_L, self.parseEnumValueDefinition, tokenKind2.BRACE_R)
end

function class:parseEnumValueDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	return {
		kind = kind.ENUM_VALUE_DEFINITION,
		description = description,
		name = name,
		directives = directives,
		loc = self:loc(token)
	}
end

function class:parseInputObjectTypeDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("input")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local inputFieldsDefinition = self:parseInputFieldsDefinition()
	return {
		kind = kind.INPUT_OBJECT_TYPE_DEFINITION,
		description = description,
		name = name,
		directives = directives,
		fields = inputFieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseInputFieldsDefinition()
	return self:optionalMany(tokenKind2.BRACE_L, self.parseInputValueDef, tokenKind2.BRACE_R)
end

function class:parseTypeSystemExtension()
	local lookahead = self._lexer:lookahead()

	if lookahead.kind == tokenKind2.NAME then
		local value = lookahead.value

		if value == "schema" then
			return self:parseSchemaExtension()
		elseif value == "scalar" then
			return self:parseScalarTypeExtension()
		elseif value == "type" then
			return self:parseObjectTypeExtension()
		elseif value == "interface" then
			return self:parseInterfaceTypeExtension()
		elseif value == "union" then
			return self:parseUnionTypeExtension()
		elseif value == "enum" then
			return self:parseEnumTypeExtension()
		elseif value == "input" then
			return self:parseInputObjectTypeExtension()
		end
	end

	error(self:unexpected(lookahead))
end

function class:parseSchemaExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("schema")
	local directives = self:parseDirectives(true)
	local optionalMany = self:optionalMany(tokenKind2.BRACE_L, self.parseOperationTypeDefinition, tokenKind2.BRACE_R)

	if #directives == 0 and #optionalMany == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.SCHEMA_EXTENSION,
		directives = directives,
		operationTypes = optionalMany,
		loc = self:loc(token)
	}
end

function class:parseScalarTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("scalar")
	local name = self:parseName()
	local directives = self:parseDirectives(true)

	if #directives == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.SCALAR_TYPE_EXTENSION,
		name = name,
		directives = directives,
		loc = self:loc(token)
	}
end

function class:parseObjectTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("type")
	local name = self:parseName()
	local implementsInterfaces = self:parseImplementsInterfaces()
	local directives = self:parseDirectives(true)
	local fieldsDefinition = self:parseFieldsDefinition()

	if #implementsInterfaces == 0 and #directives == 0 and #fieldsDefinition == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.OBJECT_TYPE_EXTENSION,
		name = name,
		interfaces = implementsInterfaces,
		directives = directives,
		fields = fieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseInterfaceTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("interface")
	local name = self:parseName()
	local implementsInterfaces = self:parseImplementsInterfaces()
	local directives = self:parseDirectives(true)
	local fieldsDefinition = self:parseFieldsDefinition()

	if #implementsInterfaces == 0 and #directives == 0 and #fieldsDefinition == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.INTERFACE_TYPE_EXTENSION,
		name = name,
		interfaces = implementsInterfaces,
		directives = directives,
		fields = fieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseUnionTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("union")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local unionMemberTypes = self:parseUnionMemberTypes()

	if #directives == 0 and #unionMemberTypes == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.UNION_TYPE_EXTENSION,
		name = name,
		directives = directives,
		types = unionMemberTypes,
		loc = self:loc(token)
	}
end

function class:parseEnumTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("enum")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local enumValuesDefinition = self:parseEnumValuesDefinition()

	if #directives == 0 and #enumValuesDefinition == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.ENUM_TYPE_EXTENSION,
		name = name,
		directives = directives,
		values = enumValuesDefinition,
		loc = self:loc(token)
	}
end

function class:parseInputObjectTypeExtension()
	local token = self._lexer.token
	self:expectKeyword("extend")
	self:expectKeyword("input")
	local name = self:parseName()
	local directives = self:parseDirectives(true)
	local inputFieldsDefinition = self:parseInputFieldsDefinition()

	if #directives == 0 and #inputFieldsDefinition == 0 then
		error(self:unexpected())
	end

	return {
		kind = kind.INPUT_OBJECT_TYPE_EXTENSION,
		name = name,
		directives = directives,
		fields = inputFieldsDefinition,
		loc = self:loc(token)
	}
end

function class:parseDirectiveDefinition()
	local token = self._lexer.token
	local description = self:parseDescription()
	self:expectKeyword("directive")
	self:expectToken(tokenKind2.AT)
	local name = self:parseName()
	local argumentDefs = self:parseArgumentDefs()
	local expectOptionalKeyword = self:expectOptionalKeyword("repeatable")
	self:expectKeyword("on")
	local directiveLocations = self:parseDirectiveLocations()
	return {
		kind = kind.DIRECTIVE_DEFINITION,
		description = description,
		name = name,
		arguments = argumentDefs,
		repeatable = expectOptionalKeyword,
		locations = directiveLocations,
		loc = self:loc(token)
	}
end

function class:parseDirectiveLocations()
	self:expectOptionalToken(tokenKind2.PIPE)
	local directiveLocations = {}

	repeat
		table.insert(directiveLocations, self:parseDirectiveLocation())
	until not self:expectOptionalToken(tokenKind2.PIPE)

	return directiveLocations
end

function class:parseDirectiveLocation()
	local token = self._lexer.token
	local directiveLocation3 = self:parseName()

	if directiveLocation2[directiveLocation3.value] ~= nil then
		return directiveLocation3
	end

	error(self:unexpected(token))
end

function class:loc(p)
	if (self._options and self._options.noLocation) == true then
		return nil
	end

	return location.new(p, self._lexer.lastToken, self._lexer.source)
end

function class:peek(p): boolean
	return self._lexer.token.kind == p
end

function class:expectToken(p)
	local token = self._lexer.token

	if token.kind == p then
		self._lexer:advance()
		return token
	end

	error(syntaxError2(
		self._lexer.source,
		token.start,
		"Expected " .. getTokenKindDesc(p) .. ", found " .. getTokenDesc(token) .. "."
	))
end

function class:expectOptionalToken(p)
	local token = self._lexer.token

	if token.kind ~= p then
		return nil
	end

	self._lexer:advance()
	return token
end

function class:expectKeyword(p: string)
	local token = self._lexer.token

	if token.kind == tokenKind2.NAME and token.value == p then
		self._lexer:advance()
	else
		error(syntaxError2(
			self._lexer.source,
			token.start,
			"Expected \"" .. p .. "\", found " .. getTokenDesc(token) .. "."
		))
	end
end

function class:expectOptionalKeyword(p: string): boolean
	local token = self._lexer.token

	if token.kind ~= tokenKind2.NAME or token.value ~= p then
		return false
	end

	self._lexer:advance()
	return true
end

function class:unexpected(p)
	if p == nil or not p then
		p = self._lexer.token
	end

	return syntaxError2(self._lexer.source, p.start, "Unexpected " .. getTokenDesc(p) .. ".")
end

function class:any(p, callback, p2)
	self:expectToken(p)
	local result = {}

	while not self:expectOptionalToken(p2) do
		table.insert(result, callback(self))
	end

	return result
end

function class:optionalMany(p, callback, p2)
	if not self:expectOptionalToken(p) then
		return {}
	end

	local result = {}

	repeat
		table.insert(result, callback(self))
	until self:expectOptionalToken(p2)

	return result
end

function class:many(p, callback, p2)
	self:expectToken(p)
	local result = {}

	repeat
		table.insert(result, callback(self))
	until self:expectOptionalToken(p2)

	return result
end

function class:delimitedMany(p, callback)
	self:expectOptionalToken(p)

	local result = {}

	repeat
		table.insert(result, callback(self))
	until not self:expectOptionalToken(p)

	return result
end

getTokenDesc = function(p)
	local value = p.value
	return getTokenKindDesc(p.kind) .. (value == nil and "" or " \"" .. value .. "\"" or "")
end

getTokenKindDesc = function(p)
	return isPunctuatorTokenKind(p) and "\"" .. p .. "\"" or p
end

local Parser = {}
Parser.Parser = class

function Parser.parse(p, p2)
	return class.new(p, p2):parseDocument()
end

function Parser.parseValue(p, p2)
	local v = class.new(p, p2)
	v:expectToken(tokenKind2.SOF)
	local value = v:parseValueLiteral(false)
	v:expectToken(tokenKind2.EOF)
	return value
end

function Parser.parseType(p, p2)
	local v = class.new(p, p2)
	v:expectToken(tokenKind2.SOF)
	local kind2 = v:parseTypeReference()
	v:expectToken(tokenKind2.EOF)
	return kind2
end

return Parser
