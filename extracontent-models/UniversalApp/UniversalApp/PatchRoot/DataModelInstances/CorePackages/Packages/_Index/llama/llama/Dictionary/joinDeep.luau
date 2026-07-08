local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)

local function joinDeep(...) -- line: 5
	-- upvalues: None (copy), copyDeep (copy), joinDeep (copy)
	local t1 = {}

	for i = 1, select("#", ...) do
		local v6 = select(i, ...)

		if v6 then
			for k, v in pairs(v6) do
				if v == None then
					t1[k] = nil
				elseif type(v) == "table" then
					if t1[k] == nil or type(t1[k] ~= "table") then
						t1[k] = copyDeep(v)
					else
						t1[k] = joinDeep(t1[k], v)
					end
				else
					t1[k] = v
				end
			end
		end
	end

	return t1
end

return joinDeep
