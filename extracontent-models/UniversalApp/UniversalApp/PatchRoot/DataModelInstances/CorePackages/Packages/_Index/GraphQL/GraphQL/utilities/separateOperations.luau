local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set

require(ParentParent.jsutils.ObjMap)
require(ParentParent.language.ast)

local Kind = require(ParentParent.language.kinds).Kind
local visit = require(ParentParent.language.visitor).visit
local collectDependencies = nil

local function collectTransitiveDependencies(p1, p2, s1: string) -- line: 95
	-- upvalues: collectTransitiveDependencies (ref)
	if not p1:has(s1) then
		p1:add(s1)

		local v25 = p2[s1]

		if v25 ~= nil then
			for _, v in pairs(v25) do
				collectTransitiveDependencies(p1, p2, v)
			end
		end
	end
end

function collectDependencies(p3) -- line: 112
	-- upvalues: visit (copy)
	local t1 = {}

	visit(p3, {
		FragmentSpread = function(_, p5) -- line: 116
			-- upvalues: t1 (copy)
			table.insert(t1, p5.name.value)
		end
	})

	return t1
end

return {
	separateOperations = function(p6) -- line: 38
		-- upvalues: Kind (copy), collectDependencies (ref), Set (copy), collectTransitiveDependencies (ref), Array (copy)
		local t2 = {}
		local t3 = {}

		for _, v in pairs(p6.definitions) do
			local kind = v.kind

			if kind == Kind.OPERATION_DEFINITION then
				table.insert(t2, v)
			elseif kind == Kind.FRAGMENT_DEFINITION then
				t3[v.name.value] = collectDependencies(v.selectionSet)
			end
		end

		local t4 = {}

		for _, v in pairs(t2) do
			local v19 = Set.new()

			for _, v2 in pairs(collectDependencies(v.selectionSet)) do
				collectTransitiveDependencies(v19, t3, v2)
			end

			t4[v.name and v.name.value or ""] = {
				kind = Kind.DOCUMENT,
				definitions = Array.filter(p6.definitions, function(p7) -- line: 81
					-- upvalues: v (copy), Kind (copy), v19 (copy)
					return p7 == v or p7.kind == Kind.FRAGMENT_DEFINITION and v19:has(p7.name.value)
				end)
			}
		end

		return t4
	end
}
