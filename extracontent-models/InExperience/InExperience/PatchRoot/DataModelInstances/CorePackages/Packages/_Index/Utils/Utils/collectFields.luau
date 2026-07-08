local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local t1 = {}
local memoize5 = require(script.Parent.memoize).memoize5
local GraphQL = require(ParentParent.GraphQL)
local Kind = GraphQL.Kind
local getDirectiveValues = GraphQL.getDirectiveValues
local GraphQLSkipDirective = GraphQL.GraphQLSkipDirective
local GraphQLIncludeDirective = GraphQL.GraphQLIncludeDirective
local isAbstractType = GraphQL.isAbstractType
local typeFromAST = GraphQL.typeFromAST
local shouldIncludeNode = nil
local getFieldEntryKey = nil
local doesFragmentConditionMatch = nil

local function collectFields(p1, t2: {[any]: any}, t3: {[any]: any}, p2, p3, p4, p5) -- line: 52
	-- upvalues: Kind (copy), Boolean (copy), shouldIncludeNode (ref), getFieldEntryKey (ref), doesFragmentConditionMatch (ref), collectFields (copy)
	for _, v28 in p3.selections do
		local kind = v28.kind

		if kind == Kind.FIELD then
			if Boolean.toJSBoolean(shouldIncludeNode(t3, v28)) then
				local v30 = getFieldEntryKey(v28)
				local v31 = p4:get(v30)

				if v31 ~= nil then
					table.insert(v31, v28)
				else
					p4:set(v30, { v28 })
				end
			end
		elseif kind == Kind.INLINE_FRAGMENT then
			if shouldIncludeNode(t3, v28) and doesFragmentConditionMatch(p1, v28, p2) then
				collectFields(p1, t2, t3, p2, v28.selectionSet, p4, p5)
			end
		elseif kind == Kind.FRAGMENT_SPREAD then
			local value = v28.name.value

			if not p5:has(value) and shouldIncludeNode(t3, v28) then
				p5:add(value)

				local v33 = t2[tostring(value)]

				if Boolean.toJSBoolean(v33) and Boolean.toJSBoolean(doesFragmentConditionMatch(p1, v33, p2)) then
					collectFields(p1, t2, t3, p2, v33.selectionSet, p4, p5)
				end
			end
		end
	end

	return p4
end

t1.collectFields = collectFields

function shouldIncludeNode(t4: {[any]: any}, p6) -- line: 164
	-- upvalues: getDirectiveValues (copy), GraphQLSkipDirective (copy), GraphQLIncludeDirective (copy)
	local v36 = getDirectiveValues(GraphQLSkipDirective, p6, t4)

	if ((if typeof(v36) ~= "table" then nil else v36["if"])) == true then
		return false
	end

	local v37 = getDirectiveValues(GraphQLIncludeDirective, p6, t4)

	if ((if typeof(v37) ~= "table" then nil else v37["if"])) == false then
		return false
	end

	return true
end
function doesFragmentConditionMatch(p7, p8, p9) -- line: 184
	-- upvalues: Boolean (copy), typeFromAST (copy), isAbstractType (copy), Array (copy)
	local typeCondition = p8.typeCondition

	if not Boolean.toJSBoolean(typeCondition) then
		return true
	end

	local v42 = typeFromAST(p7, typeCondition)

	if v42 == p9 then
		return true
	end

	if Boolean.toJSBoolean(isAbstractType(v42)) then
		local v43 = p7:getPossibleTypes(v42)

		return Array.includes(v43, p9)
	end

	return false
end
function getFieldEntryKey(p10) -- line: 218
	if p10.alias then
		return p10.alias.value
	end

	return p10.name.value
end

t1.collectSubFields = memoize5(function(p11, t5: {[any]: any}, t6: {[any]: any}, p12, p13) -- line: 226
	-- upvalues: Map (copy), Set (copy), collectFields (copy)
	local v50 = Map.new()
	local v51 = Set.new()

	for _, v53 in p13 do
		if v53.selectionSet then
			collectFields(p11, t5, t6, p12, v53.selectionSet, v50, v51)
		end
	end

	return v50
end)

return t1
