local function addToMap(p1, p2, p3) -- line: 16
	local v7 = table.clone(p1)

	v7[p2] = p3

	return v7
end
local function removeFromMap(p4, p5) -- line: 26
	local t1 = {}

	for k, v in pairs(p4) do
		if k ~= p5 then
			t1[k] = v
		end
	end

	return t1
end
local function createSignal() -- line: 38
	local t2 = {}

	return {
		subscribe = function(_, p7) -- line: 41
			-- upvalues: t2 (ref)
			assert(typeof(p7) == "function", "Can only subscribe to signals with a function.")

			local t3 = {
				disconnected = false,
				callback = p7
			}
			local v17 = t2
			local v18 = table.clone(v17)

			v18[p7] = t3
			t2 = v18

			local function disconnect() -- line: 51
				-- upvalues: t3 (copy), t2 (ref), p7 (copy)
				assert(not t3.disconnected, "Listeners can only be disconnected once.")
				t3.disconnected = true

				local v23 = t2
				local v24 = p7
				local t4 = {}

				for k, v in pairs(v23) do
					if k ~= v24 then
						t4[k] = v
					end
				end

				t2 = t4
			end

			return disconnect
		end,
		fire = function(_, ...) -- line: 61
			-- upvalues: t2 (ref)
			for k, v in pairs(t2) do
				if not v.disconnected then
					k(...)
				end
			end
		end
	}
end

return createSignal
