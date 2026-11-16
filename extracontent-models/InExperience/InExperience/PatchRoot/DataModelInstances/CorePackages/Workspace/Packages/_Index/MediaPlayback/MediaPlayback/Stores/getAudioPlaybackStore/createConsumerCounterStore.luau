local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local Cryo = require(MediaPlayback.Parent.Cryo)
local Signals = require(MediaPlayback.Parent.Signals)

local function createConsumerCounterStore()
	local signal, v = Signals.createSignal({})

	return {
		subscribe = function(p: string)
			v(function(p2)
				local v2 = p2[p] or 0
				return Cryo.Dictionary.join(p2, {
					[p] = v2 + 1
				})
			end)
		end,
		unsubscribe = function(p: string)
			local v2 = nil

			v(function(p2)
				v2 = math.max(0, (p2[p] or 0) - 1)

				local join = Cryo.Dictionary.join
				local v3 = if v2 > 0 then v2 else Cryo.None
				return join(p2, { [p] = v3 })
			end)

			return v2
		end,
		getConsumerCounts = signal
	}
end

return createConsumerCounterStore
