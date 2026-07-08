local function createSignal() -- line: 36
	local t1 = {}
	local t2 = {}
	local u4 = false

	local function subscribe(p1) -- line: 41
		-- upvalues: u4 (ref), t1 (copy), t2 (copy)
		assert(typeof(p1) == "function", "Can only subscribe to signals with a function.")

		local t3 = {
			disconnected = false,
			callback = p1
		}

		if u4 and not t1[p1] then
			t2[p1] = t3
		end

		t1[p1] = t3

		local function disconnect() -- line: 60
			-- upvalues: t3 (copy), t1 (copy), p1 (copy), t2 (copy)
			assert(not t3.disconnected, "Listeners can only be disconnected once.")
			t3.disconnected = true
			t1[p1] = nil
			t2[p1] = nil
		end

		return disconnect
	end
	local function fire(...) -- line: 74
		-- upvalues: u4 (ref), t1 (copy), t2 (copy)
		u4 = true

		for v10, v11 in t1 do
			if not v11.disconnected and not t2[v10] then
				v10(...)
			end
		end

		u4 = false
		table.clear(t2)
	end

	return subscribe, fire
end

return createSignal
