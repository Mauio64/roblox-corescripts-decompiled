local function littleTraceback(value: number?)
	local v = 1 + (value or 5)
	local traceback = debug.traceback()
	local v2 = 1
	local v3 = nil

	for _ = 1, v do
		local _, v4 = traceback:find("\n", v2, true)

		if not v4 then
			return traceback:sub(v3 or 1)
		end

		v2 = v4 + 1

		if not v3 then
			v3 = v2
		end
	end

	return traceback:sub(v3 or 1, v2 - 1)
end

return littleTraceback
