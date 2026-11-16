local module = require("@luauforge/bundled/els")
local urlBase = require("@luauforge/bundled/elt").UrlBase

local eventType = require("@luauforge/bundled/ejP").EventType

local fetch = module.fetch
local asPromise = module.asPromise

local v5 = urlBase.APIS .. "/user-recent-activity-api/v1/getUserRecentActivityEvents"

local v6 = { eventType.AvatarChange, eventType.ExperienceJoin, eventType.BadgeAwarded }

local function requestPage(network, userId, p2)
	local fetched = fetch({
		method = "POST",
		url = v5,
		body = { userId = userId, cursor = p2, pageSizeLimit = 20 },
		analyticsKey = "user-recent-activity.events.post",
		network = network,
		decode = function(p3)
			return p3
		end
	})

	local success, result = pcall(function()
		return asPromise(fetched):expect()
	end)

	if not success then
		local v7 = if type(result) == "table" then tostring(result.errorMessage) else tostring(result)
		error(`getUserRecentActivityEvents failed: {v7}`)
	end

	if type(result) ~= "table" then
		error("getUserRecentActivityEvents returned a malformed response")
	end

	return result
end

local function idFor(p2, p3, p4)
	return `user-{p3}-{p4}-{p2.timestamp}-{table.concat(p2.assetIds or {}, ",")}`
end

local function toActivityFeedItem(data, userId, primaryName)
	local assetIds = data.assetIds or {}
	local v7 = v6[data.eventType]

	if v7 == nil then
		return nil
	end

	return {
		id = `user-{userId}-{v7}-{data.timestamp}-{table.concat(data.assetIds or {}, ",")}`,
		eventType = v7,
		actors = {
			{ userId = userId, displayName = primaryName }
		},
		assetIds = assetIds,
		count = #assetIds,
		timestamp = data.timestamp
	}
end

local function createSingleUserRecentActivityEventFeed(data)
	local userId = data.userId
	local primaryName = data.primaryName
	local network = data.network or module.createRequestInternalNetwork()

	return {
		fetchAsync = function(p2)
			local v7 = requestPage(network, userId, p2)

			local v8 = {}

			for k, v9 in v7.activityEvents or {} do
				local v10 = toActivityFeedItem(v9, userId, primaryName)

				if v10 ~= nil then
					table.insert(v8, v10)
				end
			end

			local nextCursor = v7.nextCursor
			local v9 = not (nextCursor == nil or nextCursor == "") and v7.hasMore ~= false

			if not v9 then
				nextCursor = nil
			end

			return { items = v8, nextPage = nextCursor }
		end
	}
end

return createSingleUserRecentActivityEventFeed
