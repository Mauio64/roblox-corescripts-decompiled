local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant).invariant
local Error = LuauPolyfill.Error

function t1.getFragmentQueryDocument(p1, s1: string?) -- line: 49
	-- upvalues: Array (copy), Error (copy), Boolean (copy), invariant (copy), Object (copy)
	local t2 = {}

	Array.forEach(p1.definitions, function(p2) -- line: 55
		-- upvalues: Error (copy), Boolean (copy), t2 (copy)
		if p2.kind == "OperationDefinition" then
			error(Error.new(("Found a %s operation%s. "):format(tostring(p2.operation), not Boolean.toJSBoolean(p2.name) and "" or (" named '%s'"):format((tostring(p2.name.value)))) .. "No operations are allowed when using a fragment as a query. Only fragments are allowed."))
		end

		if p2.kind == "FragmentDefinition" then
			table.insert(t2, p2)
		end
	end)

	if typeof(s1) == "nil" then
		invariant(#t2 == 1, string.format("Found %s fragments. `fragmentName` must be provided when there is not exactly 1 fragment.", (tostring(#t2))))
		s1 = t2[1].name.value
	end

	return (Object.assign({}, p1, {
		definitions = Array.concat({}, {{
			kind = "OperationDefinition",
			operation = "query",
			selectionSet = {
				kind = "SelectionSet",
				selections = {{
					kind = "FragmentSpread",
					name = {
						kind = "Name",
						value = s1
					}
				}}
			}
		}}, p1.definitions)
	}))
end
function t1.createFragmentMap(p3) -- line: 121
	-- upvalues: Array (copy)
	local v14 = if p3 == nil then {} else p3
	local t3 = {}

	Array.forEach(v14, function(p4) -- line: 124
		-- upvalues: t3 (copy)
		t3[p4.name.value] = p4
	end)

	return t3
end
function t1.getFragmentFromSelection(p5, t4: {[any]: any}?) -- line: 131
	-- upvalues: invariant (copy)
	local kind = p5.kind

	if kind == "InlineFragment" then
		return p5
	end

	if kind == "FragmentSpread" then
		local v19 = t4 and t4[p5.name.value]

		invariant(v19, ("No fragment named %s."):format(p5.name.value))

		return v19
	end

	return nil
end

return t1
