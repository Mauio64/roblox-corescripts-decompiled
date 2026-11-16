local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")

local v5 = {}

local function getOrCreateEntry(p2)
	local entry = v5[p2]

	if entry == nil then
		local signal, v6 = Signals.createSignal(nil)
		entry = { get = signal, set = v6 }
		v5[p2] = entry
	end

	return entry
end

return {
	setRouteOnScreen = function(p2, p3)
		local v6 = v5[p2]

		if v6 == nil then
			local signal, v7 = Signals.createSignal(nil)
			v6 = { get = signal, set = v7 }
			v5[p2] = v6
		end

		v6.set(p3)
	end,
	getRouteOnScreen = function(p2, p3)
		local v6 = v5[p3]

		if v6 == nil then
			local signal, v7 = Signals.createSignal(nil)
			v6 = { get = signal, set = v7 }
			v5[p3] = v6
		end

		return v6.get(p2)
	end,
	_resetForTest = function()
		table.clear(v5)
	end
}
