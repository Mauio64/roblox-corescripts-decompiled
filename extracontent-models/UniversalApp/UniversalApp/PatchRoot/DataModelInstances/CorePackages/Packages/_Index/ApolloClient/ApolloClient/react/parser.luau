local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

local documentType = { Query = 0, Mutation = 1, Subscription = 2 }
local Parser = {}
Parser.DocumentType = documentType
local v = LuauPolyfill.Map.new(nil)
function Parser.operationName(p: number): nil | boolean | string
	if p == documentType.Query then
		return "Query"
	end

	if p == documentType.Mutation then
		return "Mutation"
	end

	return p == documentType.Subscription and "Subscription" or nil
end

function Parser.parser(p)
	local v2 = v:get(p)

	if v2 ~= nil then
		return v2
	end

	invariant2(
		Boolean.toJSBoolean(p) and Boolean.toJSBoolean(p.kind),
		("Argument of %s passed to parser was not a valid GraphQL "):format((tostring(p))) .. "DocumentNode. You may need to use 'graphql-tag' or another method to convert your operation into a document"
	)

	local filtered = Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "FragmentDefinition"
	end)

	local filtered2 = Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "OperationDefinition" and p2.operation == "query"
	end)

	local filtered3 = Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "OperationDefinition" and p2.operation == "mutation"
	end)

	local v3 = Array.filter(p.definitions, function(p2): boolean
		return p2.kind == "OperationDefinition" and p2.operation == "subscription"
	end)

	invariant2(
		#filtered == 0 or #filtered2 ~= 0 or #filtered3 ~= 0 or #v3 ~= 0,
		"Passing only a fragment to 'graphql' is not yet supported. You must include a query, subscription or mutation as well"
	)

	invariant2(
		#filtered2 + #filtered3 + #v3 <= 1,
		"react-apollo only supports a query, subscription, or a mutation per HOC. " .. ("%s had %s queries, %s "):format(
			tostring(p),
			tostring(#filtered2),
			(tostring(#v3))
		) .. ("subscriptions and %s mutations. "):format((tostring(#filtered3))) .. "You can use 'compose' to join multiple operation types to a component"
	)
	local v4

	if #filtered2 == 0 then
		v4 = documentType.Mutation
	else
		v4 = documentType.Query
	end

	if #filtered2 == 0 and #filtered3 == 0 then
		v4 = documentType.Subscription
	end

	if #filtered2 > 0 then
		v3 = filtered2
	elseif #filtered3 > 0 then
		v3 = filtered3
	end

	invariant2(
		#v3 == 1,
		("react-apollo only supports one definition per HOC. %s had "):format((tostring(p))) .. ("%s definitions. "):format((tostring(#v3))) .. "You can use 'compose' to join multiple operation types to a component"
	)

	local v5 = v3[1]
	local variableDefinitions = v5.variableDefinitions and v5.variableDefinitions or {}
	local v6 = {
		name = (not v5.name or v5.name.kind ~= "Name") and "data" or v5.name.value,
		type = v4,
		variables = variableDefinitions
	}
	v:set(p, v6)
	return v6
end

return Parser
