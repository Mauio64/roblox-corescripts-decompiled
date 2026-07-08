local None = require(script.Parent.Parent.None)

local function join(...) -- line: 12
	-- upvalues: None (copy)
	local v3 = select("#", ...)

	if v3 == 0 then
		return {}
	end

	if v3 == 1 then
		local v4 = table.clone(...)

		setmetatable(v4, nil)

		return v4
	end

	local v5 = table.clone(select(1, ...))

	setmetatable(v5, nil)

	for i = 2, v3 do
		local v7 = select(i, ...)

		for k, v in pairs(v7) do
			if v == None then
				v5[k] = nil
			else
				v5[k] = v
			end
		end
	end

	return v5
end

return join
