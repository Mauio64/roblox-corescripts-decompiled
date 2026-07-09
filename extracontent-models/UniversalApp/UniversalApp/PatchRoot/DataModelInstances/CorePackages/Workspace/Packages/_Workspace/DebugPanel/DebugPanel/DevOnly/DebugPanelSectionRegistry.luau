local Parent = script:FindFirstAncestor("DebugPanel").Parent

require(Parent.React)

local function makeEmptyRoot() -- line: 39
	return {
		title = "root",
		leafId = nil,
		component = nil,
		order = 0,
		defaultCollapsed = nil,
		children = {}
	}
end
local function deepCloneNode(t1: {[any]: any}) -- line: 50
	-- upvalues: deepCloneNode (copy)
	local t2 = {
		title = t1.title,
		children = {},
		leafId = t1.leafId,
		component = t1.component,
		order = t1.order,
		defaultCollapsed = t1.defaultCollapsed
	}

	for v10, v11 in t1.children do
		t2.children[v10] = deepCloneNode(v11)
	end

	return t2
end
local function pruneEmptyAncestors(t3: {[any]: any}, t4: {[any]: any}) -- line: 67
	for i = #t4 - 1, 1, -1 do
		local v15 = t3

		for j = 1, i - 1 do
			v15 = v15.children[t4[j]]

			if v15 == nil then
				return
			end
		end

		local v17 = v15.children[t4[i]]

		if not v17 or v17.component ~= nil or next(v17.children) then
			return
		end

		v15.children[t4[i]] = nil
	end
end

local v5, v6 = require(Parent.Signals).createSignal({
	title = "root",
	leafId = nil,
	component = nil,
	order = 0,
	defaultCollapsed = nil,
	children = {}
})

local function registerSection(t5: {[any]: any}) -- line: 87
	-- upvalues: v6 (copy), deepCloneNode (copy), pruneEmptyAncestors (copy)
	assert(t5.id and #t5.id > 0, "[DebugPanel] registerSection: id is required")
	assert(t5.path and #t5.path > 0, "[DebugPanel] registerSection: path must have at least one segment")
	assert(t5.component ~= nil, "[DebugPanel] registerSection: component is required")

	local v19 = t5.order or 0

	v6(function(p1) -- line: 94
		-- upvalues: deepCloneNode (copy), t5 (copy), v19 (copy)
		local v25 = deepCloneNode(p1)
		local v26 = v25

		for i = 1, #t5.path - 1 do
			local v28 = t5.path[i]

			if v26.children[v28] == nil then
				v26.children[v28] = {
					leafId = nil,
					component = nil,
					defaultCollapsed = nil,
					title = v28,
					children = {},
					order = v19
				}
			elseif v19 < v26.children[v28].order then
				v26.children[v28].order = v19
			end

			v26 = v26.children[v28]
		end

		local v29 = t5.path[#t5.path]
		local v30 = v26.children[v29]

		if v30 then
			if v30.leafId ~= nil and v30.leafId ~= t5.id then
				warn(string.format("[DebugPanel] registerSection: path '%s' is already claimed by id '%s', rejecting id '%s'", table.concat(t5.path, " > "), v30.leafId, t5.id))

				return v25
			end

			v30.leafId = t5.id
			v30.component = t5.component
			v30.defaultCollapsed = t5.defaultCollapsed

			if v19 < v30.order then
				v30.order = v19

				return v25
			end
		else
			v26.children[v29] = {
				title = v29,
				children = {},
				leafId = t5.id,
				component = t5.component,
				order = v19,
				defaultCollapsed = t5.defaultCollapsed
			}
		end

		return v25
	end)

	return function() -- line: 157
		-- upvalues: v6 (copy), deepCloneNode (copy), t5 (copy), pruneEmptyAncestors (copy)
		v6(function(p2) -- line: 158
			-- upvalues: deepCloneNode (copy), t5 (copy), pruneEmptyAncestors (copy)
			local v34 = deepCloneNode(p2)
			local v35 = v34

			for i = 1, #t5.path - 1 do
				local v37 = t5.path[i]

				if v35.children[v37] == nil then
					return v34
				end

				v35 = v35.children[v37]
			end

			local v38 = t5.path[#t5.path]
			local v39 = v35.children[v38]

			if v39 == nil or v39.leafId ~= t5.id then
				return v34
			end

			if next(v39.children) then
				v39.leafId = nil
				v39.component = nil

				return v34
			end

			v35.children[v38] = nil
			pruneEmptyAncestors(v34, t5.path)

			return v34
		end)
	end
end

return {
	registerSection = registerSection,
	registerSections = function(t6: {[any]: any}) -- line: 191
		-- upvalues: registerSection (copy)
		local t7 = {}

		for _, v23 in t6 do
			table.insert(t7, (registerSection(v23)))
		end

		return function() -- line: 196
			-- upvalues: t7 (copy)
			for _, v32 in t7 do
				v32()
			end
		end
	end,
	getRootSignal = v5
}
