local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set

require(parent.jsutils.ObjMap)

require(parent.language.ast)

local kinds = require(parent.language.kinds)
local kind = kinds.Kind
local visitor = require(parent.language.visitor)
local visit = visitor.visit

local collectDependencies
local collectTransitiveDependencies

local function separateOperations(p)
	local definitions = {}
	local v = {}

	for _, definition in pairs(p.definitions) do
		local kind2 = definition.kind

		if kind2 == kind.OPERATION_DEFINITION then
			table.insert(definitions, definition)
		elseif kind2 == kind.FRAGMENT_DEFINITION then
			v[definition.name.value] = collectDependencies(definition.selectionSet)
		end
	end

	local result = {}

	for _, v2 in pairs(definitions) do
		local v3 = Set.new()

		for _, v4 in pairs(collectDependencies(v2.selectionSet)) do
			collectTransitiveDependencies(v3, v, v4)
		end

		result[v2.name and v2.name.value or ""] = {
			kind = kind.DOCUMENT,
			definitions = Array.filter(p.definitions, function(p2)
				if p2 == v2 then
					return true
				elseif p2.kind == kind.FRAGMENT_DEFINITION then
					return (v3:has(p2.name.value))
				else
					return false
				end
			end)
		}
	end

	return result
end

collectTransitiveDependencies = function(object, p, p2: string)
	if not object:has(p2) then
		object:add(p2)

		local v = p[p2]

		if v ~= nil then
			for _, v2 in pairs(v) do
				collectTransitiveDependencies(object, p, v2)
			end
		end
	end
end

collectDependencies = function(selectionSet)
	local dependencies = {}

	visit(selectionSet, {
		FragmentSpread = function(_, p)
			table.insert(dependencies, p.name.value)
		end
	})

	return dependencies
end

return { separateOperations = separateOperations }
