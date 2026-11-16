local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Cryo")

local function createSignalMap(items)
	local v5 = {}
	local count = 0

	if items then
		for k, item in pairs(items) do
			v5[k] = item
			count += 1
		end
	end

	local signal, v6 = Signals.createSignal(v5)
	local signal2, v7 = Signals.createSignal(count)

	return {
		getData = function(p2, p3)
			return signal(p3)[p2]
		end,
		setData = function(p2, p3, p4)
			local v8 = signal(p4)
			local v9 = v8[p2]
			local joined = Cryo.Dictionary.join(v8, { [p2] = p3 })

			if not v9 then
				v7(signal2(p4) + 1)
			end

			v6(joined)
		end,
		removeData = function(p2, p3)
			local v8 = signal(p3)

			if v8[p2] then
				local joined = Cryo.Dictionary.join(v8, { [p2] = Cryo.None })

				v7(signal2(p3) - 1)
				v6(joined)
			end
		end,
		getCount = signal2,
		iterateData = function(callback, p2)
			return Signals.createEffect(function()
				local v8 = signal(p2)

				for k, v9 in pairs(v8) do
					callback(k, v9)
				end
			end)
		end,
		getAllData = Signals.createComputed(function(p2)
			return signal(p2)
		end)
	}
end

return createSignalMap
