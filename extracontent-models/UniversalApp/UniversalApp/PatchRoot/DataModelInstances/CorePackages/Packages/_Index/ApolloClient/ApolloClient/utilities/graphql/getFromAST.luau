local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
local valueToObjectRepresentation = require(script.Parent.storeUtils).valueToObjectRepresentation

local function checkDocument(p1) -- line: 29
	-- upvalues: invariant2 (copy), Array (copy), InvariantError (copy)
	invariant2(p1 and p1.kind == "Document", "Expecting a parsed GraphQL document. Perhaps you need to wrap the query string in a \"gql\" tag? http://docs.apollostack.com/apollo-client/core.html#gql")

	local v13 = Array.map(Array.filter(p1.definitions, function(p2) -- line: 36
		return p2.kind ~= "FragmentDefinition"
	end), function(p3) -- line: 39
		-- upvalues: InvariantError (copy)
		if p3.kind ~= "OperationDefinition" then
			error(InvariantError.new(("Schema type definitions not allowed in queries. Found: \"%s\""):format(p3.kind)))
		end

		return p3
	end)

	invariant2(#v13 <= 1, ("Ambiguous GraphQL document: contains %s operations"):format((tostring(#v13))))

	return p1
end

t1.checkDocument = checkDocument

function t1.getOperationDefinition(p4) -- line: 57
	-- upvalues: checkDocument (copy), Array (copy)
	checkDocument(p4)

	return Array.filter(p4.definitions, function(p5) -- line: 59
		return p5.kind == "OperationDefinition"
	end)[1]
end
function t1.getOperationName(p6) -- line: 65
	-- upvalues: Array (copy), Boolean (copy)
	local v16 = Array.map(Array.filter(p6.definitions, function(p7) -- line: 67
		-- upvalues: Boolean (copy)
		if Boolean.toJSBoolean(p7.kind == "OperationDefinition") then
			return p7.name
		end

		return p7.kind == "OperationDefinition"
	end), function(p8) -- line: 74
		-- upvalues: Boolean (copy)
		return Boolean.toJSBoolean(p8) and (not not Boolean.toJSBoolean(p8.name) and p8.name.value) or nil
	end)

	return Boolean.toJSBoolean(v16[1]) and v16[1] or nil
end
function t1.getFragmentDefinitions(p9) -- line: 84
	-- upvalues: Array (copy)
	return (Array.filter(p9.definitions, function(p10) -- line: 85
		return p10.kind == "FragmentDefinition"
	end))
end
function t1.getQueryDefinition(p11) -- line: 91
	-- upvalues: checkDocument (copy), Array (copy), invariant2 (copy), Boolean (copy)
	checkDocument(p11)

	local v19 = Array.filter(p11.definitions, function(p12) -- line: 59
		return p12.kind == "OperationDefinition"
	end)[1]

	invariant2(Boolean.toJSBoolean(v19) and v19.operation == "query", "Must contain a query definition.")

	return v19
end
function t1.getFragmentDefinition(p13) -- line: 99
	-- upvalues: invariant2 (copy)
	invariant2(p13.kind == "Document", "Expecting a parsed GraphQL document. Perhaps you need to wrap the query string in a \"gql\" tag? http://docs.apollostack.com/apollo-client/core.html#gql")
	invariant2(#p13.definitions <= 1, "Fragment must have exactly one definition.")

	local v21 = p13.definitions[1]

	invariant2(v21.kind == "FragmentDefinition", "Must be a fragment definition.")

	return v21
end
function t1.getMainDefinition(p14) -- line: 120
	-- upvalues: checkDocument (copy), Boolean (copy), InvariantError (copy)
	checkDocument(p14)

	local v23 = nil

	for _, v in ipairs(p14.definitions) do
		if v.kind == "OperationDefinition" then
			local operation = v.operation

			if operation == "query" or operation == "mutation" or operation == "subscription" then
				return v
			end
		end

		if v.kind == "FragmentDefinition" and not Boolean.toJSBoolean(v23) then
			v23 = v
		end
	end

	if Boolean.toJSBoolean(v23) then
		return v23
	end

	error(InvariantError.new("Expected a parsed GraphQL query with a query, mutation, subscription, or a fragment."))
end
function t1.getDefaultValues(p15) -- line: 148
	-- upvalues: Array (copy), Boolean (copy), valueToObjectRepresentation (copy)
	local t2 = {}
	local v29 = if p15 == nil then nil else p15.variableDefinitions

	if v29 ~= nil and #v29 > 0 then
		Array.forEach(v29, function(p16) -- line: 157
			-- upvalues: Boolean (copy), valueToObjectRepresentation (copy), t2 (copy)
			if Boolean.toJSBoolean(p16.defaultValue) then
				valueToObjectRepresentation(t2, p16.variable.name, p16.defaultValue)
			end
		end)
	end

	return t2
end

return t1
