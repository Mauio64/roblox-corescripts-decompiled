local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal

local function createToastStore() -- line: 35
	-- upvalues: createSignal (copy), Signals (copy)
	local n1 = 0
	local v6, v7 = createSignal({})
	local v8 = Signals.createComputed(function(p1) -- line: 69
		-- upvalues: v6 (copy)
		local v20 = v6(p1)

		if #v20 == 0 then
			return nil
		end

		return v20[#v20].data
	end)

	return {
		getToasts = v6,
		getToast = v8,
		triggerToast = function(t1: {[any]: any}) -- line: 39
			-- upvalues: n1 (ref), v6 (copy), v7 (copy)
			n1 += 1

			local t2 = {
				id = n1,
				data = t1
			}
			local v11 = v6(false)

			if #v11 >= 4 then
				local t3 = {}

				for i = #v11 - 4 + 2, #v11 do
					table.insert(t3, v11[i])
				end

				table.insert(t3, t2)
				v7(t3)

				return
			end

			local v14 = table.clone(v11)

			table.insert(v14, t2)
			v7(v14)
		end,
		dismissToast = function(n2: number) -- line: 58
			-- upvalues: v6 (copy), v7 (copy)
			local t4 = {}

			for _, v18 in (v6(false)) do
				if n2 ~= v18.id then
					table.insert(t4, v18)
				end
			end

			v7(t4)
		end
	}
end

return createToastStore
