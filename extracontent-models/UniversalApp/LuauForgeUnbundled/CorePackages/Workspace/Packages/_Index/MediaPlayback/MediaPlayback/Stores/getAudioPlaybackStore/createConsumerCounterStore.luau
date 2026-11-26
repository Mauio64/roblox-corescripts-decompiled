local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")

local function createConsumerCounterStore()
	local signal, v5 = Signals.createSignal({})

	return {
		subscribe = function(p2)
			v5(function(p3)
				local v6 = p3[p2] or 0
				return Cryo.Dictionary.join(p3, {
					[p2] = v6 + 1
				})
			end)
		end,
		unsubscribe = function(p2)
			local v6 = nil

			v5(function(p3)
				v6 = math.max(0, (p3[p2] or 0) - 1)

				local join = Cryo.Dictionary.join
				local v9 = if v6 > 0 then v6 else Cryo.None
				return join(p3, { [p2] = v9 })
			end)

			return v6
		end,
		getConsumerCounts = signal
	}
end

return createConsumerCounterStore
