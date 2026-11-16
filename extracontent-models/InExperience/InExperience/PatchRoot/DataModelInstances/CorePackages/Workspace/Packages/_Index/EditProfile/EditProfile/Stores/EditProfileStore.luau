local parent = script:FindFirstAncestor("EditProfile").Parent
require(parent.Signals)

local DataHydration = require(parent.DataHydration)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local fetchUserDescription = require(script.Parent.Requests.fetchUserDescription)
local fetchUsernameChangePrice = require(script.Parent.Requests.fetchUsernameChangePrice)
local updateUserDescription = require(script.Parent.Requests.updateUserDescription)

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
local EditProfileStore = {}

function EditProfileStore.getDescription(p: string)
	return (dataResolver.getAndFetchItem(p))
end

function EditProfileStore.getUsernameChangePrice(p: string)
	return dataResolver2.getAndFetchItem(p)
end

function EditProfileStore.updateDescription(p: string, p2: string)
	return updateUserDescription(p2):andThen(function(p3)
		dataCache.replaceItem(p, p3)
		return p3
	end)
end

return EditProfileStore
