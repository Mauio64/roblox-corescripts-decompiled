local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local function createMockHttpStore()
	local v5 = {}

	local function getOrCreateResponse(p2, p3)
		if not v5[p2] then
			local signal, v6 = Signals.createSignal({
				status = "NotStarted",
				config = p3
			})

			v5[p2] = { get = signal, set = v6 }
		end

		return v5[p2]
	end

	return {
		fetch = function(p2, p3)
			return getOrCreateResponse(p2 or p3.Url, p3).get, function() end
		end,
		cancelAll = function() end,
		setResponse = function(p2, p3)
			if v5[p2] then
				v5[p2].set(p3)
				return
			end

			local signal, v6 = Signals.createSignal(p3)
			v5[p2] = { get = signal, set = v6 }
		end,
		reset = function()
			v5 = {}
		end
	}
end

return createMockHttpStore
