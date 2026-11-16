require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Signals")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/DataHydration")
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local fetchUserDescription = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/Requests/fetchUserDescription")
local fetchUsernameChangePrice = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/Requests/fetchUsernameChangePrice")
local updateUserDescription = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Stores/Requests/updateUserDescription")

local dataCache = createDataCache()
local dataResolver = createDataResolver({
	cache = dataCache,
	supportsMultiGet = false,
	fetchFn = fetchUserDescription,
	queueProcessDelaySec = 0
})

local dataResolver2 = createDataResolver({
	cache = createDataCache(),
	supportsMultiGet = false,
	fetchFn = fetchUsernameChangePrice,
	queueProcessDelaySec = 0
})
return {
	getDescription = function(p2)
		return (dataResolver.getAndFetchItem(p2))
	end,
	getUsernameChangePrice = function(p2)
		return dataResolver2.getAndFetchItem(p2)
	end,
	updateDescription = function(p2, p3)
		return updateUserDescription(p3):andThen(function(p4)
			dataCache.replaceItem(p2, p4)
			return p4
		end)
	end
}
