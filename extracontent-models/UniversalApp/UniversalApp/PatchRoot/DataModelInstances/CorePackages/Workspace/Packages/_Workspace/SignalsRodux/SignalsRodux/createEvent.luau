local function createEvent() -- line: 7
	local t1 = {}

	local function connect(p1: ((...any) -> ...any)) -- line: 10
		-- upvalues: t1 (copy)
		t1[p1] = true

		return function() -- line: 12
			-- upvalues: t1 (copy), p1 (copy)
			t1[p1] = nil
		end
	end
	local function fire(...) -- line: 17
		-- upvalues: t1 (copy)
		for v6 in table.clone(t1) do
			v6(...)
		end
	end

	return connect, fire
end

return createEvent
