local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local String = LuauPolyfill.String

local GraphQL = require(parent2.GraphQL)

local visit = GraphQL.visit

local remove = GraphQL.REMOVE
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

local getFromAST = require(script.Parent.getFromAST)
local checkDocument = getFromAST.checkDocument
local getOperationDefinition = getFromAST.getOperationDefinition
local getFragmentDefinition = getFromAST.getFragmentDefinition
local getFragmentDefinitions = getFromAST.getFragmentDefinitions
local getMainDefinition = getFromAST.getMainDefinition
local filterInPlace = require(script.Parent.Parent.common.filterInPlace)
local filterInPlace2 = filterInPlace.filterInPlace
local storeUtils = require(script.Parent.storeUtils)
local isField = storeUtils.isField
local isInlineFragment = storeUtils.isInlineFragment

local function createFragmentMap(p) -- 1 equivalent call inferred from this helper
	local fragmentMap = {}
	Array.forEach(p, function(p2)
		fragmentMap[p2.name.value] = p2
	end)
	return fragmentMap
end

local hasDirectivesInSelection
local removeArgumentsFromDocument
local removeFragmentSpreadFromDocument
local getAllFragmentSpreadsFromSelectionSet

local v = {
	kind = "Field",
	name = { kind = "Name", value = "__typename" }
}
local function isEmpty(p, fragmentMap)
	return Array.every(p.selectionSet.selections, function(p2)
		return p2.kind == "FragmentSpread" and isEmpty(fragmentMap[p2.name.value], fragmentMap)
	end, nil)
end

local function nullIfDocIsEmpty(p) -- 3 equivalent calls inferred from this helper
	local v2 = getOperationDefinition(p) or getFragmentDefinition(p)
	local fragmentMap = createFragmentMap(getFragmentDefinitions(p)) -- inferred equivalent call

	if Array.every(v2.selectionSet.selections, function(p2)
		return p2.kind == "FragmentSpread" and isEmpty(fragmentMap[p2.name.value], fragmentMap)
	end, nil) then
		return nil
	end

	return p
end

local function getDirectiveMatcher(p) -- 3 equivalent calls inferred from this helper
	return function(p2)
		return Array.some(p, function(object)
			return Boolean.toJSBoolean(object.name) and object.name == p2.name.value and true
				or Boolean.toJSBoolean(object.test) and object:test(p2)
		end)
	end
end

local function removeDirectivesFromDocument(p, p2)
	local set = {}
	local v2 = {}

	local set2 = {}
	local v3 = {}

	local v4 = nullIfDocIsEmpty(visit(p2, { -- inferred equivalent call
		Variable = {
			enter = function(_, p3, _, p4): nil
				if p4.kind ~= "VariableDefinition" then
					set[p3.name.value] = true
				end

				return nil
			end
		},
		Field = {
			enter = function(_, data)
				if not (Boolean.toJSBoolean(p) and Boolean.toJSBoolean(data.directives) and Array.some(p, function(p3)
					return p3.remove
				end) and data.directives) then
					return nil
				end

				if not Array.some(data.directives, getDirectiveMatcher(p)) then -- inferred equivalent call
					return nil
				end

				if data.arguments then
					Array.forEach(data.arguments, function(p3)
						if p3.value.kind == "Variable" then
							table.insert(v2, { name = p3.value.name.value })
						end
					end)
				end

				if data.selectionSet then
					Array.forEach(getAllFragmentSpreadsFromSelectionSet(data.selectionSet), function(p3)
						table.insert(v3, { name = p3.name.value })
					end)
				end

				return remove
			end
		},
		FragmentSpread = {
			enter = function(_, p3)
				set2[p3.name.value] = true
			end
		},
		Directive = {
			enter = function(_, p3)
				if Boolean.toJSBoolean(getDirectiveMatcher(p)(p3)) then -- inferred equivalent call
					return remove
				end

				return nil
			end
		}
	}))

	if Boolean.toJSBoolean(v4) and Boolean.toJSBoolean(#filterInPlace2(v2, function(p3)
		return (Boolean.toJSBoolean(p3.name) and true or false) and not set[p3.name]
	end)) then
		v4 = removeArgumentsFromDocument(v2, v4)
	end

	if Boolean.toJSBoolean(v4) and Boolean.toJSBoolean(#filterInPlace2(v3, function(p3)
		return (Boolean.toJSBoolean(p3.name) and true or false) and not set2[p3.name]
	end)) then
		return (removeFragmentSpreadFromDocument(v3, v4))
	end

	return v4
end

local Transform = {}
Transform.removeDirectivesFromDocument = removeDirectivesFromDocument
Transform.addTypenameToDocument = Object.assign(setmetatable({}, {
	__call = function(_, p)
		return visit(checkDocument(p), {
			SelectionSet = {
				enter = function(_, p2, _, p3)
					if Boolean.toJSBoolean(p3) and p3.kind == "OperationDefinition" then
						return
					end

					local selections = p2.selections

					if not Boolean.toJSBoolean(selections) then
						return
					end

					if Array.some(selections, function(p4)
						return isField(p4)
							and (p4.name.value == "__typename" or String.lastIndexOf(p4.name.value, "__", 1) == 1)
					end) then
						return
					end

					if
						isField(p3)
						and Boolean.toJSBoolean(p3.directives)
						and Boolean.toJSBoolean(Array.some(p3.directives, function(p4): boolean
							return p4.name.value == "export"
						end))
					then
						return
					end

					return Object.assign({}, p2, {
						selections = Array.concat({}, selections, { v })
					})
				end
			}
		})
	end
}), {
	added = function(_, p): boolean
		return p == v
	end
})

local v2 = {
	test = function(_, p)
		local v2 = p.name.value == "connection"

		if v2 and (not Boolean.toJSBoolean(p.arguments) or Array.some(p.arguments, function(p2): boolean
			return p2.name.value == "key"
		end)) then
			invariant2.warn("Removing an @connection directive even though it does not have a key. You may want to use the key parameter to specify a store key.")
		end

		return v2
	end
}

function Transform.removeConnectionDirectiveFromDocument(p)
	return removeDirectivesFromDocument({ v2 }, checkDocument(p))
end

local function hasDirectivesInSelectionSet(p, selectionSet, flag: boolean?) -- 1 equivalent call inferred from this helper
	local v3 = flag == nil or flag

	return selectionSet and selectionSet.selections and Array.some(selectionSet.selections, function(p2)
		return hasDirectivesInSelection(p, p2, v3)
	end) or false
end

hasDirectivesInSelection = function(p, p2, flag: boolean?)
	local v3 = flag == nil or flag

	if not isField(p2) then
		return true
	end

	if not p2.directives then
		return false
	end

	local v4 = Array.some(p2.directives, getDirectiveMatcher(p)) -- inferred equivalent call

	if not v4 then
		if v3 then
			return hasDirectivesInSelectionSet(p, p2.selectionSet, v3) or false -- inferred equivalent call
		end

		return false
	end

	return v4
end

local function getArgumentMatcher(p) -- 1 equivalent call inferred from this helper
	return function(p2)
		return Array.some(p, function(p3)
			if p2.value and p2.value.kind == "Variable" and p2.value.name then
				return p3.name == p2.value.name.value or (p3.test and p3.test(p3, p2) or false)
			end

			return false
		end)
	end
end

removeArgumentsFromDocument = function(p, p2)
	local argumentMatcher = getArgumentMatcher(p) -- inferred equivalent call
	return nullIfDocIsEmpty(visit(p2, { -- inferred equivalent call
		OperationDefinition = {
			enter = function(_, p3)
				return Object.assign({}, p3, {
					variableDefinitions = p3.variableDefinitions and Array.filter(p3.variableDefinitions, function(p4): boolean
						return not Array.some(p, function(p5): boolean
							return p5.name == p4.variable.name.value
						end)
					end) or {}
				})
			end
		},
		Field = {
			enter = function(_, p3)
				if not Array.some(p, function(p4)
					return p4.remove
				end) then
					return nil
				end

				local count = 0

				if p3.arguments then
					Array.forEach(p3.arguments, function(p4)
						if argumentMatcher(p4) then
							count += 1
						end
					end)
				end

				return if count == 1 then remove else nil
			end
		},
		Argument = {
			enter = function(_, p3)
				if Boolean.toJSBoolean(argumentMatcher(p3)) then
					return remove
				end

				return nil
			end
		}
	}))
end

Transform.removeArgumentsFromDocument = removeArgumentsFromDocument

removeFragmentSpreadFromDocument = function(p, p2)
	local function enter(_, p3)
		if Array.some(p, function(p4): boolean
			return p4.name == p3.name.value
		end) then
			return remove
		end

		return nil
	end

	return nullIfDocIsEmpty(visit(p2, { -- inferred equivalent call
		FragmentSpread = { enter = enter },
		FragmentDefinition = { enter = enter }
	}))
end

Transform.removeFragmentSpreadFromDocument = removeFragmentSpreadFromDocument

getAllFragmentSpreadsFromSelectionSet = function(selectionSet)
	local allFragmentSpreads = {}
	Array.forEach(selectionSet.selections, function(p)
		if (isField(p) or isInlineFragment(p)) and p.selectionSet then
			Array.forEach(getAllFragmentSpreadsFromSelectionSet(p.selectionSet), function(p2)
				table.insert(allFragmentSpreads, p2)
			end)
		elseif p.kind == "FragmentSpread" then
			table.insert(allFragmentSpreads, p)
		end
	end)
	return allFragmentSpreads
end

function Transform.buildQueryFromSelectionSet(p)
	if getMainDefinition(p).operation == "query" then
		return p
	end

	return (visit(p, {
		OperationDefinition = {
			enter = function(_, p2)
				return Object.assign({}, p2, { operation = "query" })
			end
		}
	}))
end

function Transform.removeClientSetsFromDocument(p)
	checkDocument(p)

	local v3 = removeDirectivesFromDocument({
		{
			test = function(_, p2): boolean
				return p2.name.value == "client"
			end,
			remove = true
		}
	}, p)

	if Boolean.toJSBoolean(v3) then
		return (visit(v3, {
			FragmentDefinition = {
				enter = function(_, p2)
					if p2.selectionSet then
						local every = Array.every(p2.selectionSet.selections, function(p3)
							return isField(p3) and p3.name.value == "__typename"
						end)

						if Boolean.toJSBoolean(every) then
							return remove
						end
					end

					return nil
				end
			}
		}))
	end

	return v3
end

return Transform
