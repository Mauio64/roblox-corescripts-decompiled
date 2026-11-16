local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local HttpClient = require(parent.HttpClient)

local classifyShareLinkV2 = require(AppChat.Components.ChatConversation.Utils.RobloxUrlUtils.classifyShareLinkV2)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local fetchResolvedShareLink = require(script.Parent.Requests.fetchResolvedShareLink)

local function createShareLinkV2Store(options)
	local v2 = options or {}

	local dataCache = DataHydration.createDataCache(v2.ttlSeconds, v2.failedTtlSeconds)
	local dataResolver = DataHydration.createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p)
			v:warning(`Error resolving share link v2: {tostring(p)}`)
		end,
		fetchFn = function(p: string)
			return HttpClient.asPromise(fetchResolvedShareLink(p, v2.network)):andThen(classifyShareLinkV2)
		end
	})

	return {
		getCachedClassification = dataResolver.getCachedItem,
		fetchClassification = dataResolver.fetchItem,
		getAndFetchClassification = dataResolver.getAndFetchItem,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createShareLinkV2Store
