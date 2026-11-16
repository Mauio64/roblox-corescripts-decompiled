local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local Fragments = {}
require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local Error = LuauPolyfill.Error

function Fragments.getFragmentQueryDocument(p, p2: string?)
	local data = {}
	Array.forEach(p.definitions, function(data2)
		if data2.kind == "OperationDefinition" then
			error(Error.new(("Found a %s operation%s. "):format(
				tostring(data2.operation),
				not Boolean.toJSBoolean(data2.name) and "" or (" named '%s'"):format((tostring(data2.name.value)))
			) .. "No operations are allowed when using a fragment as a query. Only fragments are allowed."))
		end

		if data2.kind == "FragmentDefinition" then
			table.insert(data, data2)
		end
	end)

	if typeof(p2) == "nil" then
		invariant2(
			#data == 1,
			string.format(
				"Found %s fragments. `fragmentName` must be provided when there is not exactly 1 fragment.",
				(tostring(#data))
			)
		)

		p2 = data[1].name.value
	end

	return (Object.assign({}, p, {
		definitions = Array.concat({}, {
			{
				kind = "OperationDefinition",
				operation = "query",
				selectionSet = {
					kind = "SelectionSet",
					selections = {
						{
							kind = "FragmentSpread",
							name = { kind = "Name", value = p2 }
						}
					}
				}
			}
		}, p.definitions)
	}))
end

function Fragments.createFragmentMap(p)
	local v = p == nil and {} or p
	local fragmentMap = {}
	Array.forEach(v, function(p2)
		fragmentMap[p2.name.value] = p2
	end)
	return fragmentMap
end

function Fragments.getFragmentFromSelection(p, p2)
	local kind = p.kind

	if kind == "InlineFragment" then
		return p
	end

	if kind ~= "FragmentSpread" then
		return nil
	end

	local selected = p2 and p2[p.name.value]

	invariant2(selected, ("No fragment named %s."):format(p.name.value))
	return selected
end

return Fragments
