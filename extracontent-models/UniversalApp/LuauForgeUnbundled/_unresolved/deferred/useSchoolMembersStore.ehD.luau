local module = require("@luauforge/deferred/egU")
local module2 = require("@luauforge/deferred/ehe")
local module3 = require("@luauforge/deferred/ehf")

local module4 = require("@luauforge/deferred/ehE")
require("@luauforge/deferred/ehF")

local useSignalState = module2.useSignalState

local function useSchoolMembersStore(p2, p3)
	local v5 = module4()
	local getMembers = v5.getMembers

	local v6 = module.useMemo(function()
		if p2 == "" then
			return nil
		end

		return (getMembers(p2, p3))
	end, { p2, p3, getMembers })

	local v7 = module.useMemo(function()
		return module3.createComputed(function(p4)
			if v6 then
				return (v6.status(p4))
			end

			return "NotReady"
		end)
	end, { v6 })

	local v8 = module.useMemo(function()
		return module3.createComputed(function(p4)
			if v6 then
				return (v6.data(p4))
			end

			return nil
		end)
	end, { v6 })

	return {
		status = useSignalState(v7),
		data = useSignalState(v8),
		hasMore = useSignalState(v5.getHasMore),
		isLoadingMore = useSignalState(v5.getIsLoadingMore),
		roleHasMore = useSignalState(v5.getRoleHasMore),
		loadMore = module.useCallback(function(p4)
			v5.loadMore(p2, p4)
		end, { p2, v5 })
	}
end

return useSchoolMembersStore
