local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

local function createSignalMap(items)
	local v = {}
	local count = 0

	if items then
		for k, item in pairs(items) do
			v[k] = item
			count += 1
		end
	end

	local signal, v2 = Signals.createSignal(v)
	local signal2, v3 = Signals.createSignal(count)

	return {
		getData = function(p, p2)
			return signal(p2)[p]
		end,
		setData = function(p, p2, p3)
			local v4 = signal(p3)
			local v5 = v4[p]
			local joined = Cryo.Dictionary.join(v4, { [p] = p2 })

			if not v5 then
				v3(signal2(p3) + 1)
			end

			v2(joined)
		end,
		removeData = function(p, p2)
			local v4 = signal(p2)

			if v4[p] then
				local joined = Cryo.Dictionary.join(v4, { [p] = Cryo.None })

				v3(signal2(p2) - 1)
				v2(joined)
			end
		end,
		getCount = signal2,
		iterateData = function(callback, p)
			return Signals.createEffect(function()
				local v4 = signal(p)

				for k, v5 in pairs(v4) do
					callback(k, v5)
				end
			end)
		end,
		getAllData = Signals.createComputed(function(p)
			return signal(p)
		end)
	}
end

return createSignalMap
