local None = require(script.Parent.Parent.None)

local function join(...) -- line: 4
	-- upvalues: None (copy)
	local t1 = {}
	local n1 = 1

	for i = 1, select("#", ...) do
		local v6 = select(i, ...)

		if v6 then
			for j = 1, #v6 do
				if v6[j] ~= None then
					t1[n1] = v6[j]
					n1 += 1
				end
			end
		end
	end

	return t1
end

return join
