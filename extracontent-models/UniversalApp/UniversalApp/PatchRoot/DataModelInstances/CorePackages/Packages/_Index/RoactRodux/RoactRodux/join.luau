local function join(...) -- line: 1
	local t1 = {}

	for i = 1, select("#", ...) do
		local v4 = select(i, ...)

		if v4 ~= nil then
			for k, v in pairs(v4) do
				t1[k] = v
			end
		end
	end

	return t1
end

return join
