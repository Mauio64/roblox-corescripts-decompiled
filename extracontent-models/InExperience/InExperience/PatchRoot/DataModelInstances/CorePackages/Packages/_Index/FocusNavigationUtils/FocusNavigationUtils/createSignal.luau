local function createSignal(p1) -- line: 29
	local t1 = {}
	local t2 = {}
	local u5 = p1
	local u6 = false

	local function fire(p2) -- line: 65
		-- upvalues: u5 (ref), u6 (ref), t1 (copy), t2 (copy)
		u5 = p2
		u6 = true

		for v13, v14 in t1 do
			if not v14.unsubscribed and not t2[v13] then
				v13(p2)
			end
		end

		u6 = false

		for v15, v16 in t2 do
			t1[v15] = v16
		end

		table.clear(t2)
	end

	return {
		subscribe = function(_: {[any]: any}, p3) -- line: 36
			-- upvalues: u6 (ref), t1 (copy), t2 (copy)
			local t4 = {
				unsubscribed = false,
				callback = p3
			}

			if u6 and not t1[p3] then
				t2[p3] = t4
			else
				t1[p3] = t4
			end

			return {
				unsubscribe = function(_: {[any]: any}) -- line: 50
					-- upvalues: t4 (copy), t1 (copy), p3 (copy), t2 (copy)
					t4.unsubscribed = true
					t1[p3] = nil
					t2[p3] = nil
				end
			}
		end,
		getValue = function(_: {[any]: any}) -- line: 61
			-- upvalues: u5 (ref)
			return u5
		end
	}, fire
end

return createSignal
