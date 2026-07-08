local None = require(script.Parent.Parent.None)

local function zipAll(...) -- line: 4
	-- upvalues: None (copy)
	local t1 = {}
	local v4 = select("#", ...)
	local v5 = #select(1, ...)

	for i = 2, v4 do
		local v7 = #select(i, ...)

		if v5 < v7 then
			v5 = v7
		end
	end

	for i = 1, v5 do
		t1[i] = {}

		for j = 1, v4 do
			if select(j, ...)[i] == nil then
				t1[i][j] = None
			else
				t1[i][j] = select(j, ...)[i]
			end
		end
	end

	return t1
end

return zipAll
