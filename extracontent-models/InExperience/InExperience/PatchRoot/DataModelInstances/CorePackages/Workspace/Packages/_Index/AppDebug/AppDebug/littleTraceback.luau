local function littleTraceback(n1: number?) -- line: 7
	local v3 = 1 + (n1 or 5)
	local trace = debug.traceback()
	local v5 = nil
	local n2 = 1

	for _ = 1, v3 do
		local _, stop = trace:find("\n", n2, true)

		if not stop then
			return trace:sub(v5 or 1)
		end

		n2 = stop + 1

		if not v5 then
			v5 = n2
		end
	end

	return trace:sub(v5 or 1, n2 - 1)
end

return littleTraceback
