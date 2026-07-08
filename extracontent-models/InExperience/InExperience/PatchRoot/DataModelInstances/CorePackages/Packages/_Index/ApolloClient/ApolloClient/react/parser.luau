local t1 = {}
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant).invariant
local Map = LuauPolyfill.Map
local t2 = {
	Query = 0,
	Mutation = 1,
	Subscription = 2
}

t1.DocumentType = t2

local v10 = Map.new(nil)

function t1.operationName(n1: number) -- line: 36
	-- upvalues: t2 (copy)
	local s1 = nil

	if n1 == t2.Query then
		return "Query"
	end

	if n1 == t2.Mutation then
		return "Mutation"
	end

	if n1 == t2.Subscription then
		s1 = "Subscription"
	end

	return s1
end
function t1.parser(p1) -- line: 51
	-- upvalues: v10 (copy), invariant (copy), Boolean (copy), Array (copy), t2 (copy)
	local v14 = v10:get(p1)

	if v14 ~= nil then
		return v14
	end

	invariant(Boolean.toJSBoolean(p1) and Boolean.toJSBoolean(p1.kind), ("Argument of %s passed to parser was not a valid GraphQL "):format((tostring(p1))) .. "DocumentNode. You may need to use 'graphql-tag' or another method " .. "to convert your operation into a document")

	local v15 = Array.filter(p1.definitions, function(p2) -- line: 63
		return p2.kind == "FragmentDefinition"
	end)
	local v16 = Array.filter(p1.definitions, function(p3) -- line: 67
		return p3.kind == "OperationDefinition" and p3.operation == "query"
	end)
	local v17 = Array.filter(p1.definitions, function(p4) -- line: 72
		return p4.kind == "OperationDefinition" and p4.operation == "mutation"
	end)
	local v18 = Array.filter(p1.definitions, function(p5) -- line: 77
		return p5.kind == "OperationDefinition" and p5.operation == "subscription"
	end)

	invariant(#v15 == 0 or (#v16 ~= 0 or (#v17 ~= 0 or #v18 ~= 0)), "Passing only a fragment to 'graphql' is not yet supported. You must include a query, subscription or mutation as well")
	invariant(#v16 + #v17 + #v18 <= 1, "react-apollo only supports a query, subscription, or a mutation per HOC. " .. ("%s had %s queries, %s "):format(tostring(p1), tostring(#v16), (tostring(#v18))) .. ("subscriptions and %s mutations. "):format((tostring(#v17))) .. "You can use 'compose' to join multiple operation types to a component")

	local v19 = if #v16 == 0 then t2.Mutation else t2.Query

	if #v16 == 0 and #v17 == 0 then
		v19 = t2.Subscription
	end

	local v20 = if not (#v16 > 0) then if not (#v17 > 0) then v18 else v17 else v16

	invariant(#v20 == 1, ("react-apollo only supports one definition per HOC. %s had "):format((tostring(p1))) .. ("%s definitions. "):format((tostring(#v20))) .. "You can use 'compose' to join multiple operation types to a component")

	local v21 = v20[1]
	local v22 = v21.variableDefinitions and v21.variableDefinitions or {}
	local t3 = {
		name = (not v21.name or v21.name.kind ~= "Name") and "data" or v21.name.value,
		type = v19,
		variables = v22
	}

	v10:set(p1, t3)

	return t3
end

return t1
