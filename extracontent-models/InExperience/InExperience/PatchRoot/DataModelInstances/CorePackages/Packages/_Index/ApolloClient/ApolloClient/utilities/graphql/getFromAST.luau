local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError
local storeUtils = require(script.Parent.storeUtils)
local valueToObjectRepresentation = storeUtils.valueToObjectRepresentation

local function checkDocument(p)
	invariant2(
		p and p.kind == "Document",
		"Expecting a parsed GraphQL document. Perhaps you need to wrap the query string in a \"gql\" tag? http://docs.apollostack.com/apollo-client/core.html#gql"
	)

	local mapped = Array.map(Array.filter(p.definitions, function(p2): boolean
		return p2.kind ~= "FragmentDefinition"
	end), function(p2)
		if p2.kind ~= "OperationDefinition" then
			error(invariantError.new(("Schema type definitions not allowed in queries. Found: \"%s\""):format(p2.kind)))
		end

		return p2
	end)

	invariant2(#mapped <= 1, ("Ambiguous GraphQL document: contains %s operations"):format((tostring(#mapped))))

	return p
end

local GetFromAST = {}
GetFromAST.checkDocument = checkDocument

function GetFromAST.getOperationDefinition(p)
	checkDocument(p)
	return Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "OperationDefinition"
	end)[1]
end

function GetFromAST.getOperationName(p)
	local mapped = Array.map(Array.filter(p.definitions, function(p2)
		if Boolean.toJSBoolean(p2.kind == "OperationDefinition") then
			return p2.name
		end

		return p2.kind == "OperationDefinition"
	end), function(p2)
		return Boolean.toJSBoolean(p2) and Boolean.toJSBoolean(p2.name) and p2.name.value or nil
	end)

	return Boolean.toJSBoolean(mapped[1]) and mapped[1] or nil
end

function GetFromAST.getFragmentDefinitions(p)
	return (Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "FragmentDefinition"
	end))
end

function GetFromAST.getQueryDefinition(p)
	checkDocument(p)
	local queryDefinition = Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "OperationDefinition"
	end)[1]

	invariant2(
		Boolean.toJSBoolean(queryDefinition) and queryDefinition.operation == "query",
		"Must contain a query definition."
	)
	return queryDefinition
end

function GetFromAST.getFragmentDefinition(p)
	invariant2(
		p.kind == "Document",
		"Expecting a parsed GraphQL document. Perhaps you need to wrap the query string in a \"gql\" tag? http://docs.apollostack.com/apollo-client/core.html#gql"
	)

	invariant2(#p.definitions <= 1, "Fragment must have exactly one definition.")

	local definition = p.definitions[1]

	invariant2(definition.kind == "FragmentDefinition", "Must be a fragment definition.")

	return definition
end

function GetFromAST.getMainDefinition(p)
	checkDocument(p)
	local v = nil

	for _, definition in ipairs(p.definitions) do
		if definition.kind == "OperationDefinition" then
			local operation = definition.operation

			if operation == "query" or operation == "mutation" or operation == "subscription" then
				return definition
			end
		end

		if definition.kind ~= "FragmentDefinition" or Boolean.toJSBoolean(v) then
			continue
		end

		v = definition
	end

	if Boolean.toJSBoolean(v) then
		return v
	end

	error(invariantError.new("Expected a parsed GraphQL query with a query, mutation, subscription, or a fragment."))
end

function GetFromAST.getDefaultValues(p)
	local defaultValues = {}
	local variableDefinitions

	if p ~= nil then
		variableDefinitions = p.variableDefinitions
	end

	if variableDefinitions ~= nil and #variableDefinitions > 0 then
		Array.forEach(variableDefinitions, function(p2)
			if Boolean.toJSBoolean(p2.defaultValue) then
				valueToObjectRepresentation(defaultValues, p2.variable.name, p2.defaultValue)
			end
		end)
	end

	return defaultValues
end

return GetFromAST
