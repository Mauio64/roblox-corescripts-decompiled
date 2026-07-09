local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)

require(Parent.MomentsTypes)
require(script.Parent.MomentsStoreTypes)

local reactToFeedItem = require(script.Parent.Requests.reactToFeedItem)

local function createMomentsReactionsStore(p1) -- line: 14
	-- upvalues: HttpClient (copy), reactToFeedItem (copy)
	local v6 = p1 or {}

	return {
		reactToFeedItem = function(p2) -- line: 17
			-- upvalues: HttpClient (copy), reactToFeedItem (copy), v6 (copy)
			return HttpClient.asPromise(reactToFeedItem(p2, v6.network))
		end
	}
end

return createMomentsReactionsStore
