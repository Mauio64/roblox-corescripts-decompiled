local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local Promise = require(Parent.Promise)

require(Parent.MomentsTypes)
require(script.Parent.MomentsStoreTypes)

local reactToFeedItem = require(script.Parent.Requests.reactToFeedItem)
local reactToFeedItemV2 = require(script.Parent.Requests.reactToFeedItemV2)
local createMomentsEmojiSetsStore = require(script.Parent.createMomentsEmojiSetsStore)
local FFlagMomentsEmojiSetsApi = require(script.Parent.FFlagMomentsEmojiSetsApi)

local function createMomentsReactionsStore(p1) -- line: 19
	-- upvalues: HttpClient (copy), reactToFeedItem (copy), reactToFeedItemV2 (copy), Promise (copy), FFlagMomentsEmojiSetsApi (copy), createMomentsEmojiSetsStore (copy)
	local v10 = p1 or {}

	local function reactToFeedItem2(p2) -- line: 22
		-- upvalues: HttpClient (copy), reactToFeedItem (copy), v10 (copy)
		return HttpClient.asPromise(reactToFeedItem(p2, v10.network))
	end

	if FFlagMomentsEmojiSetsApi then
		local v12 = createMomentsEmojiSetsStore(v10)

		return {
			reactToFeedItem = reactToFeedItem2,
			reactToFeedItemV2 = function(p3) -- line: 26
				-- upvalues: HttpClient (copy), reactToFeedItemV2 (copy), v10 (copy), Promise (copy)
				return HttpClient.asPromise(reactToFeedItemV2(p3, v10.network)):catch(function(p4) -- line: 27
					-- upvalues: Promise (copy)
					warn(`[Moments] Failed to react to feed item (v2): { tostring(p4) }`)

					return Promise.reject(p4)
				end)
			end,
			getAndFetchEmojiSets = v12.getAndFetchEmojiSets,
			getEmojis = v12.getEmojis
		}
	end

	return {
		reactToFeedItem = reactToFeedItem2
	}
end

return createMomentsReactionsStore
