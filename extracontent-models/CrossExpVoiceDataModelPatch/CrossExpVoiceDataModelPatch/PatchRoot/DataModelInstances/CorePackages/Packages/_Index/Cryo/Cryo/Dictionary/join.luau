local None = require(script.Parent.Parent.None)

local function join(...)
	local v = select("#", ...)

	if v == 0 then
		return {}
	end

	if v == 1 then
		local clone = table.clone(...)
		setmetatable(clone, nil)
		return clone
	else
		local clone = table.clone((select)(1, ...))
		setmetatable(clone, nil)

		for i = 2, v do
			local v2 = select(i, ...)

			for k, v3 in pairs(v2) do
				if v3 == None then
					clone[k] = nil
				else
					clone[k] = v3
				end
			end
		end

		return clone
	end
end

return join
