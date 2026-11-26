local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local function createMomentsShellStackStore()
	local signal, v5 = Signals.createSignal({})
	local computed = Signals.createComputed(function(p2)
		local v6 = signal(p2)
		return v6[#v6]
	end)

	local count = 0

	local function pushShell()
		count += 1
		local v6 = count
		v5(function(p2)
			local clone = table.clone(p2)
			table.insert(clone, v6)
			return clone
		end)

		local function removeShell()
			v5(function(list)
				local index = table.find(list, v6)

				if index == nil then
					return list
				end

				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end)
		end

		return v6, removeShell
	end

	return { getTopShellId = computed, pushShell = pushShell }
end

return createMomentsShellStackStore
