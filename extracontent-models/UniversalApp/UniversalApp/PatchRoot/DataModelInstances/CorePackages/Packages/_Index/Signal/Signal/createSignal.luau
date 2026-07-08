require(script.Parent.types)

local function createSignal() -- line: 25
	local t1 = {}
	local t2 = {}
	local u4 = false

	local function fire(p1) -- line: 56
		-- upvalues: u4 (ref), t1 (copy), t2 (copy)
		u4 = true

		for v10, v11 in t1 do
			if not v11.unsubscribed and not t2[v10] then
				v10(p1)
			end
		end

		u4 = false

		for v12, v13 in t2 do
			t1[v12] = v13
		end

		table.clear(t2)
	end

	return {
		subscribe = function(_, p3) -- line: 31
			-- upvalues: u4 (ref), t1 (copy), t2 (copy)
			local t3 = {
				unsubscribed = false,
				callback = p3
			}

			if u4 and not t1[p3] then
				t2[p3] = t3
			else
				t1[p3] = t3
			end

			return {
				unsubscribe = function(_) -- line: 45
					-- upvalues: t3 (copy), t1 (copy), p3 (copy), t2 (copy)
					t3.unsubscribed = true
					t1[p3] = nil
					t2[p3] = nil
				end
			}
		end
	}, fire
end

return createSignal
