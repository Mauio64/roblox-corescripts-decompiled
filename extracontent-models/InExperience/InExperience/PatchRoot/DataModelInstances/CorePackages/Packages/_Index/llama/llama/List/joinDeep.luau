local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)

local function joinDeep(...) -- line: 5
	-- upvalues: copyDeep (copy), joinDeep (copy), None (copy)
	local t1 = {}
	local n1 = 1

	for i = 1, select("#", ...) do
		local v7 = select(i, ...)

		if v7 then
			for j = 1, #v7 do
				if type(v7[j]) == "table" then
					if t1[n1] == nil or type(t1[n1] ~= "table") then
						t1[n1] = copyDeep(v7[j])
					else
						t1[n1] = joinDeep(t1[n1], v7[j])
					end
				elseif v7[j] ~= None then
					t1[n1] = v7[j]
				end

				n1 += 1
			end
		end
	end

	return t1
end

return joinDeep
