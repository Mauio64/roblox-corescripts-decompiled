local parent = script.Parent
require(parent.Types)
local includes = require(parent.includes)
local keys = require(parent.keys)

local sort = table.sort

local function getDefaultCycles()
	return { visited = {}, refs = {}, nextRef = 1, omit = {} }
end

local function cycles(p, p2: number?, p3)
	if p2 == -1 then
		return p3
	end

	if typeof(p) ~= "table" then
		return nil
	end

	local v = p3 or getDefaultCycles()

	if v.visited[p] then
		if not v.refs[p] then
			v.refs[p] = v.nextRef
			v.nextRef += 1
		end

		return nil
	else
		v.visited[p] = true

		local v2 = keys(p)
		sort(v2, function(value, value2): boolean
			if typeof(value) == "number" and typeof(value2) == "number" then
				return value < value2
			end

			return tostring(value) < tostring(value2)
		end)

		for _, v3 in ipairs(v2) do
			local v4 = p[v3]

			if includes(v.omit, v3) then
				continue
			end

			if p2 then
				cycles(v3, p2 - 1, v)
				cycles(v4, p2 - 1, v)
			else
				cycles(v3, nil, v)
				cycles(v4, nil, v)
			end
		end

		return v
	end
end

return cycles
