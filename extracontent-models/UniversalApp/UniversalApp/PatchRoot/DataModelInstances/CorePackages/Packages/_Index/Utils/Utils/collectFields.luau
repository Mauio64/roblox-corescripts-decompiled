local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set

local memoize = require(script.Parent.memoize)
local memoize5 = memoize.memoize5

local GraphQL = require(parent.GraphQL)

local Kind = GraphQL.Kind

local getDirectiveValues = GraphQL.getDirectiveValues
local GraphQLSkipDirective = GraphQL.GraphQLSkipDirective
local GraphQLIncludeDirective = GraphQL.GraphQLIncludeDirective
local isAbstractType = GraphQL.isAbstractType
local typeFromAST = GraphQL.typeFromAST

local shouldIncludeNode
local getFieldEntryKey
local doesFragmentConditionMatch
local function collectFields(p, p2, p3, p4, selectionSet, object, object2)
	for _, selection in selectionSet.selections do
		local kind = selection.kind

		if kind == Kind.FIELD then
			if Boolean.toJSBoolean(shouldIncludeNode(p3, selection)) then
				local v = getFieldEntryKey(selection)

				local selections = object:get(v)

				if selections == nil then
					object:set(v, { selection })
				else
					table.insert(selections, selection)
				end
			end
		elseif kind == Kind.INLINE_FRAGMENT then
			if shouldIncludeNode(p3, selection) and doesFragmentConditionMatch(p, selection, p4) then
				collectFields(p, p2, p3, p4, selection.selectionSet, object, object2)
			end
		elseif kind == Kind.FRAGMENT_SPREAD then
			local value = selection.name.value

			if not object2:has(value) and shouldIncludeNode(p3, selection) then
				object2:add(value)
				local v = p2[tostring(value)]

				if Boolean.toJSBoolean(v) and Boolean.toJSBoolean(doesFragmentConditionMatch(p, v, p4)) then
					collectFields(p, p2, p3, p4, v.selectionSet, object, object2)
				end
			end
		end
	end

	return object
end

local CollectFields = {}
CollectFields.collectFields = collectFields

shouldIncludeNode = function(p, selection): boolean
	local directiveValues = getDirectiveValues(GraphQLSkipDirective, selection, p)
	local v

	if typeof(directiveValues) == "table" then
		v = directiveValues["if"]
	end

	if v == true then
		return false
	end

	local directiveValues2 = getDirectiveValues(GraphQLIncludeDirective, selection, p)
	local v2

	if typeof(directiveValues2) == "table" then
		v2 = directiveValues2["if"]
	end

	return v2 ~= false
end

doesFragmentConditionMatch = function(object, p, p2)
	local typeCondition = p.typeCondition

	if not Boolean.toJSBoolean(typeCondition) then
		return true
	end

	local v = typeFromAST(object, typeCondition)

	if v == p2 then
		return true
	end

	if not Boolean.toJSBoolean(isAbstractType(v)) then
		return false
	end

	local possibleTypes = object:getPossibleTypes(v)

	return Array.includes(possibleTypes, p2)
end

getFieldEntryKey = function(selection)
	if selection.alias then
		return selection.alias.value
	end

	return selection.name.value
end

CollectFields.collectSubFields = memoize5(function(p, p2, p3, p4, items)
	local v = Map.new()
	local v2 = Set.new()

	for _, item in items do
		if item.selectionSet then
			collectFields(p, p2, p3, p4, item.selectionSet, v, v2)
		end
	end

	return v
end)
return CollectFields
