local function intersect(...) -- line: 2
	local t1 = {}
	local v3 = select("#", ...)
	local v4 = select(1, ...)

	for k, _ in pairs(v4) do
		local v7 = true

		for i = 2, v3 do
			if select(i, ...)[k] == nil then
				v7 = false

				break
			end
		end

		if v7 then
			t1[k] = true
		end
	end

	return t1
end

return intersect
