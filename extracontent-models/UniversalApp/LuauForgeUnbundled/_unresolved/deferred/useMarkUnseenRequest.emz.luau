local module = require("@luauforge/deferred/eil")
local v5 = require("@luauforge/deferred/elA").UnseenRequestsStore.get()

local function useMarkUnseenRequest()
	local v6 = module.useCallback(function()
		v5.clearUnseenRequest()
	end, {})

	module.useEffect(function()
		v5.clearUnseenRequestCount()

		return v6
	end, { v6 })

	return v6
end

return useMarkUnseenRequest
