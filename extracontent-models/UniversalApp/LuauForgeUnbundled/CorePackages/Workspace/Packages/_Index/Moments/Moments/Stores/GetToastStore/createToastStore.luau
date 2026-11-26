local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local createSignal = Signals.createSignal

local function createToastStore()
	local count = 0
	local signal, v5 = createSignal({})

	local function triggerToast(p2)
		count += 1
		local v6 = { id = count, data = p2 }
		local v7 = signal(false)

		if #v7 >= 4 then
			local v8 = {}

			for i = #v7 - 4 + 2, #v7 do
				table.insert(v8, v7[i])
			end

			table.insert(v8, v6)
			v5(v8)
		else
			local clone = table.clone(v7)
			table.insert(clone, v6)
			v5(clone)
		end

		return v6.id
	end

	return {
		getToasts = signal,
		getToast = Signals.createComputed(function(p2)
			local v6 = signal(p2)

			if #v6 == 0 then
				return nil
			end

			return v6[#v6].data
		end),
		triggerToast = triggerToast,
		dismissToast = function(p2)
			local v6 = signal(false)
			local v7 = {}

			for k, v8 in v6 do
				if v8.id ~= p2 then
					table.insert(v7, v8)
				end
			end

			v5(v7)
		end
	}
end

return createToastStore
