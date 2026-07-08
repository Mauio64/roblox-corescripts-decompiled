local None = require(script.Parent.Parent.None)

local function join(...) -- line: 6
	-- upvalues: None (copy)
	local t1 = {}

	for i = 1, select("#", ...) do
		local v5 = select(i, ...)
		local v6 = #t1

		for j = 1, #v5 do
			if v5[j] == None then
				v6 -= 1
			else
				t1[v6 + j] = v5[j]
			end
		end
	end

	return t1
end

return join
