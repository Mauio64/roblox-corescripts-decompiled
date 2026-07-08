local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local Cryo = require(MediaPlayback.Parent.Cryo)
local Signals = require(MediaPlayback.Parent.Signals)

local function createConsumerCounterStore() -- line: 19
	-- upvalues: Signals (copy), Cryo (copy)
	local v5, v6 = Signals.createSignal({})

	return {
		subscribe = function(s1: string) -- line: 22
			-- upvalues: v6 (copy), Cryo (copy)
			v6(function(p1) -- line: 23
				-- upvalues: s1 (copy), Cryo (copy)
				local v11 = p1[s1] or 0

				return Cryo.Dictionary.join(p1, {
					[s1] = v11 + 1
				})
			end)
		end,
		unsubscribe = function(s2: string) -- line: 31
			-- upvalues: v6 (copy), Cryo (copy)
			local u9 = nil

			v6(function(p2) -- line: 34
				-- upvalues: s2 (copy), u9 (ref), Cryo (copy)
				u9 = math.max(0, (p2[s2] or 0) - 1)

				return Cryo.Dictionary.join(p2, {
					[s2] = if not (u9 > 0) then Cryo.None else u9
				})
			end)

			return u9
		end,
		getConsumerCounts = v5
	}
end

return createConsumerCounterStore
