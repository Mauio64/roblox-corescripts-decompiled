local findOr = require(script.Parent.findOr)
local slice = require(script.Parent.slice)
local ParentParent = script.Parent.Parent

require(ParentParent.types)

local MAX_SAFE_INTEGER = require(ParentParent.Number).MAX_SAFE_INTEGER

local function split(s1: string, p1, n1: number?) -- line: 12
	-- upvalues: MAX_SAFE_INTEGER (copy), findOr (copy), slice (copy)
	if p1 == nil then
		return { s1 }
	end

	if n1 == 0 then
		return {}
	end

	local v9 = if n1 ~= nil and not (n1 < 0) then n1 else MAX_SAFE_INTEGER

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
	local v14 = nil
	local v15, v16 = utf8.len(s1)

	assert(v15 ~= nil, ("string `%s` has an invalid byte at position %s"):format(s1, (tostring(v16))))

	repeat
		local v17 = findOr(s1, p1, n2)

		if v17 ~= nil then
			table.insert(t2, slice(s1, n2, v17.index))

			local v18 = utf8.len(v17.match)

			n2 = v17.index + v18
		else
			table.insert(t2, slice(s1, n2, nil))
		end

		if v17 ~= nil then
			v14 = v17
		end
	until v17 == nil or v15 < n2 or v9 <= #t2

	if v14 ~= nil then
		local v19, v20 = utf8.len(v14.match)

		assert(v19 ~= nil, ("string `%s` has an invalid byte at position %s"):format(v14.match, (tostring(v20))))

		if v14.index + v19 == v15 + 1 then
			table.insert(t2, "")
		end
	end

	return t2
end

return split
