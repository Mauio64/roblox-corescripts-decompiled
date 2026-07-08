local function addToMap(p1, p2, p3) -- line: 15
	local t1 = {}

	for k, v in pairs(p1) do
		t1[k] = v
	end

	t1[p2] = p3

	return t1
end
local function removeFromMap(p4, p5) -- line: 27
	local t2 = {}

	for k, v in pairs(p4) do
		if k ~= p5 then
			t2[k] = v
		end
	end

	return t2
end
local function createSignal() -- line: 39
	local t3 = {}

	return {
		subscribe = function(_, p7) -- line: 42
			-- upvalues: t3 (ref)
			assert(typeof(p7) == "function", "Can only subscribe to signals with a function.")

			local t4 = {
				disconnected = false,
				callback = p7
			}
			local v19 = t3
			local t5 = {}

			for k, v in pairs(v19) do
				t5[k] = v
			end

			t5[p7] = t4
			t3 = t5

			local function disconnect() -- line: 52
				-- upvalues: t4 (copy), t3 (ref), p7 (copy)
				assert(not t4.disconnected, "Listeners can only be disconnected once.")
				t4.disconnected = true

				local v27 = t3
				local v28 = p7
				local t6 = {}

				for k, v in pairs(v27) do
					if k ~= v28 then
						t6[k] = v
					end
				end

				t3 = t6
			end

			return disconnect
		end,
		fire = function(_, ...) -- line: 62
			-- upvalues: t3 (ref)
			for k, v in pairs(t3) do
				if not v.disconnected then
					k(...)
				end
			end
		end
	}
end

return createSignal
