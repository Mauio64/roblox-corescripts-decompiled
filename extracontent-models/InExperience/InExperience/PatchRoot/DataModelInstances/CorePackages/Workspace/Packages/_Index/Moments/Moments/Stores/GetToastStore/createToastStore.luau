local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createToastStore()
	local count = 0
	local signal, v = createSignal({})

	local function triggerToast(p)
		count += 1
		local v2 = { id = count, data = p }
		local v3 = signal(false)

		if #v3 >= 4 then
			local v4 = {}

			for i = #v3 - 4 + 2, #v3 do
				table.insert(v4, v3[i])
			end

			table.insert(v4, v2)
			v(v4)
		else
			local clone = table.clone(v3)
			table.insert(clone, v2)
			v(clone)
		end

		return v2.id
	end

	return {
		getToasts = signal,
		getToast = Signals.createComputed(function(p)
			local v2 = signal(p)

			if #v2 == 0 then
				return nil
			end

			return v2[#v2].data
		end),
		triggerToast = triggerToast,
		dismissToast = function(p: number)
			local v2 = signal(false)
			local v3 = {}

			for _, v4 in v2 do
				if v4.id ~= p then
					table.insert(v3, v4)
				end
			end

			v(v3)
		end
	}
end

return createToastStore
