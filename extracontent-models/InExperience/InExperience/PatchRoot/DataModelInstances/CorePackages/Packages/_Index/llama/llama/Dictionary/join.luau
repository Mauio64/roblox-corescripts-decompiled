local None = require(script.Parent.Parent.None)

local function join(...) -- line: 4
	-- upvalues: None (copy)
	local t1 = {}

	for i = 1, select("#", ...) do
		local v5 = select(i, ...)

		if v5 then
			for k, v in pairs(v5) do
				if v == None then
					t1[k] = nil
				else
					t1[k] = v
				end
			end
		end
	end

	return t1
end

return join
