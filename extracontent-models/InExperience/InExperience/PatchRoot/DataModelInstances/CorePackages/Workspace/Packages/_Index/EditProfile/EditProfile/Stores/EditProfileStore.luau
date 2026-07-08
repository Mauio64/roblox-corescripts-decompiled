local Parent = script:FindFirstAncestor("EditProfile").Parent

require(Parent.Signals)

local DataHydration = require(Parent.DataHydration)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local fetchUserDescription = require(script.Parent.Requests.fetchUserDescription)
local updateUserDescription = require(script.Parent.Requests.updateUserDescription)
local v7 = createDataCache()
local v8 = createDataResolver({
	supportsMultiGet = false,
	queueProcessDelaySec = 0,
	cache = v7,
	fetchFn = fetchUserDescription
})

return {
	getDescription = function(s1: string) -- line: 29
		-- upvalues: v8 (copy)
		return (v8.getAndFetchItem(s1))
	end,
	updateDescription = function(s2: string, s3: string) -- line: 34
		-- upvalues: updateUserDescription (copy), v7 (copy)
		return updateUserDescription(s3):andThen(function(p1) -- line: 35
			-- upvalues: v7 (copy), s2 (copy)
			v7.replaceItem(s2, p1)

			return p1
		end)
	end
}
