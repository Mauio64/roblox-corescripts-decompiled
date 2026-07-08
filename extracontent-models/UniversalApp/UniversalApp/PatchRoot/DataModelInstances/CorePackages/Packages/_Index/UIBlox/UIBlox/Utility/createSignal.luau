local function createSignal() -- line: 11
	local t1 = {}
	local t2 = {}
	local u4 = false

	return {
		subscribe = function(_, p2) -- line: 16
			-- upvalues: u4 (ref), t1 (copy), t2 (copy)
			assert(typeof(p2) == "function", "Can only subscribe to signals with a function.")

			local t3 = {
				disconnected = false,
				callback = p2
			}

			if u4 and not t1[p2] then
				t2[p2] = t3
			end

			t1[p2] = t3

			local function disconnect() -- line: 32
				-- upvalues: t3 (copy), t1 (copy), p2 (copy), t2 (copy)
				assert(not t3.disconnected, "Listeners can only be disconnected once.")
				t3.disconnected = true
				t1[p2] = nil
				t2[p2] = nil
			end

			return disconnect
		end,
		fire = function(_, ...) -- line: 43
			-- upvalues: u4 (ref), t1 (copy), t2 (copy)
			u4 = true

			for k, v in pairs(t1) do
				if not v.disconnected and not t2[k] then
					k(...)
				end
			end

			u4 = false

			for k, _ in pairs(t2) do
				t2[k] = nil
			end
		end
	}
end

return createSignal
