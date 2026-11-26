local function littleTraceback(value)
	local v5 = 1 + (value or 5)
	local traceback = debug.traceback()
	local v6 = 1
	local v7 = nil

	for i = 1, v5 do
		local v8, v9 = traceback:find("\n", v6, true)

		if not v9 then
			return traceback:sub(v7 or 1)
		end

		v6 = v9 + 1

		if not v7 then
			v7 = v6
		end
	end

	return traceback:sub(v7 or 1, v6 - 1)
end

return littleTraceback
