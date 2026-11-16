local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local function createMomentsShellStackStore()
	local signal, v = Signals.createSignal({})
	local getTopShellId = Signals.createComputed(function(p)
		local v2 = signal(p)
		return v2[#v2]
	end)

	local count = 0

	local function pushShell()
		count += 1
		local v2 = count
		v(function(p)
			local clone = table.clone(p)
			table.insert(clone, v2)
			return clone
		end)

		local function removeShell()
			v(function(list)
				local index = table.find(list, v2)

				if index == nil then
					return list
				end

				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end)
		end

		return v2, removeShell
	end

	return { getTopShellId = getTopShellId, pushShell = pushShell }
end

return createMomentsShellStackStore
