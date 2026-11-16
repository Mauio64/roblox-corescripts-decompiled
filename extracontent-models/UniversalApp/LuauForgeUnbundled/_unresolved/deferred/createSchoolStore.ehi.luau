local module = require("@luauforge/deferred/egZ")
local createDataCache = module.createDataCache
local createDataResolver = module.createDataResolver

local module2 = require("@luauforge/deferred/ehj")
local module3 = require("@luauforge/deferred/egW")
require("@luauforge/deferred/egX")
local module4 = require("@luauforge/deferred/ehr")

local function createSchoolStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return module2():andThen(function(p4)
				if module4 and p4 ~= nil and p4.status == module3.SchoolStatus.Locked then
					return { school = p4, isLocked = true }
				end

				return { school = p4 }
			end)
		end,
		queueProcessDelaySec = 0
	})

	local function getVerifiedSchoolResult(p2)
		return (dataResolver.getAndFetchItem(p2))
	end

	return {
		getVerifiedSchool = getVerifiedSchoolResult,
		updateVerifiedSchool = function(p2, p3)
			dataCache.replaceItem(p2, { school = p3 })
		end,
		refresh = function(p2)
			dataResolver.fetchItem(p2)
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createSchoolStore
