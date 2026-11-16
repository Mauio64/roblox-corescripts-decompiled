local parent = script.Parent
local parent2 = parent.Parent
local Signals = require(parent2.Signals)

require(parent.HttpStoreTypes)

local function createMockHttpStore()
	local v = {}

	local function getOrCreateResponse(p: string, config)
		if not v[p] then
			local signal, set = Signals.createSignal({ status = "NotStarted", config = config })

			v[p] = { get = signal, set = set }
		end

		return v[p]
	end

	return {
		fetch = function(p: string?, config)
			return getOrCreateResponse(p or config.Url, config).get, function() end
		end,
		cancelAll = function() end,
		setResponse = function(p: string, p2)
			if v[p] then
				v[p].set(p2)
				return
			end

			local signal, set = Signals.createSignal(p2)
			v[p] = { get = signal, set = set }
		end,
		reset = function()
			v = {}
		end
	}
end

return createMockHttpStore
