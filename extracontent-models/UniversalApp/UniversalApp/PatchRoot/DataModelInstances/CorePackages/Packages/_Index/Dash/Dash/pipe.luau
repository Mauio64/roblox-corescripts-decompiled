local function pipe(p1: ((...any) -> ...any), ...) -- line: 22
	local v3 = select("#", ...)

	if v3 == 0 then
		return p1
	end

	local t1 = { ... }

	return function(...) -- line: 28
		-- upvalues: p1 (copy), v3 (copy), t1 (copy)
		local t2 = { p1(...) }

		for i = 1, v3 do
			t2 = { t1[i](unpack(t2)) }
		end

		return unpack(t2)
	end
end

return pipe
