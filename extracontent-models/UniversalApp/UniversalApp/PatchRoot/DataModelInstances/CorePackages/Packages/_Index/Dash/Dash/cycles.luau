local scriptParent = script.Parent

require(scriptParent.Types)

local includes = require(scriptParent.includes)
local keys = require(scriptParent.keys)
local sort = table.sort

local function getDefaultCycles() -- line: 19
	return {
		nextRef = 1,
		visited = {},
		refs = {},
		omit = {}
	}
end
local function cycles(p1, n1: number?, p2) -- line: 41
	-- upvalues: getDefaultCycles (copy), keys (copy), sort (copy), includes (copy), cycles (copy)
	if n1 == -1 then
		return p2
	end

	if typeof(p1) == "table" then
		local v10 = p2 or getDefaultCycles()

		if v10.visited[p1] then
			if not v10.refs[p1] then
				v10.refs[p1] = v10.nextRef
				v10.nextRef = v10.nextRef + 1
			end

			return nil
		end

		v10.visited[p1] = true

		local v11 = keys(p1)

		sort(v11, function(p3, p4) -- line: 62
			if typeof(p3) == "number" and typeof(p4) == "number" then
				return p3 < p4
			end

			return tostring(p3) < tostring(p4)
		end)

		for _, v in ipairs(v11) do
			local v14 = p1[v]

			if not includes(v10.omit, v) then
				if n1 then
					cycles(v, n1 - 1, v10)
					cycles(v14, n1 - 1, v10)
				else
					cycles(v, nil, v10)
					cycles(v14, nil, v10)
				end
			end
		end

		return v10
	end

	return nil
end

return cycles
