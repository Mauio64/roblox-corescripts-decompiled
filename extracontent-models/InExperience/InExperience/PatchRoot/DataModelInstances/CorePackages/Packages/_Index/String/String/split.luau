local scriptParent = script.Parent
local findOr = require(scriptParent.findOr)
local slice = require(scriptParent.slice)
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.ES7Types)

local MAX_SAFE_INTEGER = require(scriptParentParent.Number).MAX_SAFE_INTEGER

local function split(s1: string, p1, n1: number?) -- line: 27
	-- upvalues: MAX_SAFE_INTEGER (copy), findOr (copy), slice (copy)
	if p1 == nil then
		return { s1 }
	end

	if n1 == 0 then
		return {}
	end

	local v10 = if n1 ~= nil and not (n1 < 0) then n1 else MAX_SAFE_INTEGER

	if typeof(p1) == "string" then
		if p1 == "" then
			local t1 = {}

			for match in s1:gmatch(".") do
				table.insert(t1, match)
			end

			return t1
		end

		p1 = { p1 }
	end

	local n2 = 1
	local t2 = {}
	local v15 = nil
	local v16, v17 = utf8.len(s1)

	assert(v16 ~= nil, ("string `%s` has an invalid byte at position %s"):format(s1, (tostring(v17))))

	repeat
		local v18 = findOr(s1, p1, n2)

		if v18 ~= nil then
			table.insert(t2, slice(s1, n2, v18.index))

			local v19 = utf8.len(v18.match)

			n2 = v18.index + v19
		else
			table.insert(t2, slice(s1, n2, nil))
		end

		if v18 ~= nil then
			v15 = v18
		end
	until v18 == nil or v16 < n2 or v10 <= #t2

	if v15 ~= nil then
		local v20, v21 = utf8.len(v15.match)

		assert(v20 ~= nil, ("string `%s` has an invalid byte at position %s"):format(v15.match, (tostring(v21))))

		if v15.index + v20 == v16 + 1 then
			table.insert(t2, "")
		end
	end

	return t2
end

return split
