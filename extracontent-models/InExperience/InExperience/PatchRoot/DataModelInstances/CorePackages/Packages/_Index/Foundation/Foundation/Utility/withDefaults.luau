local Parent = script:FindFirstAncestor("Foundation").Parent
local Dash = require(Parent.Dash)
local ReactIs = require(Parent.ReactIs)

local function isTableNotBinding(p1) -- line: 7
	-- upvalues: ReactIs (copy)
	return type(p1) == "table" and not ReactIs.isBinding(p1)
end
local function deepJoin(p2, p3) -- line: 11
	-- upvalues: ReactIs (copy), deepJoin (copy)
	local v10 = table.clone(p2)

	for v11, v12 in p3 do
		if type(v12) == "table" and not ReactIs.isBinding(v12) then
			local v13 = v10[v11]

			if type(v13) == "table" and not ReactIs.isBinding(v13) then
				v10[v11] = deepJoin(v10[v11], v12)

				continue
			end
		end

		v10[v11] = v12
	end

	return v10
end
local function withDefaults(p4, p5) -- line: 23
	-- upvalues: deepJoin (copy), Dash (copy)
	local t1 = {}

	if type(p4) == "table" and type(p5) == "table" then
		for v17, _ in p5 do
			t1[v17] = p4[v17]
		end
	end

	local v19 = deepJoin(p5, t1)

	return (Dash.union(p4, v19))
end

return withDefaults
