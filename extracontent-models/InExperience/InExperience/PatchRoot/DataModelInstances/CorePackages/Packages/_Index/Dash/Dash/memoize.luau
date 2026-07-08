local scriptParent = script.Parent

require(scriptParent.Types)

local function memoize(p1, p2: ((...any) -> ...any)?) -- line: 26
	local t1 = {}

	return function(...) -- line: 29
		-- upvalues: p2 (copy), t1 (copy), p1 (copy)
		local v6 = if not p2 then table.concat({ ... }, "|") else p2(...)

		if t1[v6] == nil then
			t1[v6] = p1(...)
		end

		return t1[v6]
	end
end

return memoize
