local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local HttpService = game:GetService("HttpService")

require(GraphQLServer.Parent.LuauPolyfill)
require(GraphQLServer.graphql.generatedTypes)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError
local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder).UrlBuilder
local t1 = {}
local v10 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")
local v11 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")
local v12 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps/counters")
local v13 = UrlBuilder.fromString("apis:virtual-events/v1/universes/{id}/virtual-events?cursor={cursor}&limit={limit}&fromUtc={fromUtc}")
local v14 = UrlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")
local v15 = UrlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")

function t1.findVirtualEventById(s1: string, p1) -- line: 34
	-- upvalues: fetch (copy), Promise (copy), v10 (copy), Response (copy), GraphQLError (copy)
	local v18 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 37
		-- upvalues: v10 (copy), s1 (copy), v18 (copy), Response (copy), GraphQLError (copy)
		local v39 = v10({
			id = s1
		})
		local v40 = v18(v39, {
			method = "GET"
		}):catch(function() -- line: 40
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v40.ok then
			reject(GraphQLError.new(string.format("Failed to find VirtualEvent matching id: %s.", s1)))

			return
		end

		local v41 = v40:json():catch(function() -- line: 52
			return nil
		end):expect()

		if not v41 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for VirtualEvent matching id: %s.", s1)))

			return
		end

		resolve(v41)
	end)
end
function t1.findVirtualEventsByUniverseId(n1: number, p2, p3) -- line: 75
	-- upvalues: fetch (copy), Promise (copy), v13 (copy), Response (copy), GraphQLError (copy)
	local v22 = p3 or fetch

	return Promise.new(function(resolve, reject) -- line: 82
		-- upvalues: v13 (copy), n1 (copy), p2 (copy), v22 (copy), Response (copy), GraphQLError (copy)
		local v44 = v13({
			id = n1,
			cursor = (not p2 or not p2.cursor) and "" or p2.cursor,
			limit = (not p2 or not p2.limit) and 25 or p2.limit,
			fromUtc = (not p2 or not p2.fromUtc) and "" or p2.fromUtc
		})
		local v45 = v22(v44, {
			method = "GET"
		}):catch(function() -- line: 91
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v45.ok then
			reject(GraphQLError.new(string.format("Failed to find experience matching universeId: %i", n1)))

			return
		end

		local v46 = v45:json():catch(function() -- line: 103
			return nil
		end):expect()

		if not v46 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for experience matching universeId: %i", n1)))

			return
		end

		resolve({
			cursor = v46.nextPageCursor,
			virtualEvents = v46.data
		})
	end)
end
function t1.findRsvpsByVirtualEventId(s2: string, p4) -- line: 131
	-- upvalues: fetch (copy), Promise (copy), v11 (copy), Response (copy), GraphQLError (copy)
	local v25 = p4 or fetch

	return Promise.new(function(resolve, reject) -- line: 134
		-- upvalues: v11 (copy), s2 (copy), v25 (copy), Response (copy), GraphQLError (copy)
		local v49 = v11({
			id = s2
		})
		local v50 = v25(v49, {
			method = "GET"
		}):catch(function() -- line: 137
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v50.ok then
			reject(GraphQLError.new(string.format("Failed to find RSVPs matching VirtualEvent id: %s.", s2)))

			return
		end

		local v51 = v50:json():catch(function() -- line: 150
			return nil
		end):expect()

		if not v51 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for RSVPs matching VirtualEvent id: %s.", s2)))

			return
		end

		resolve(v51.data)
	end)
end
function t1.findRsvpCountersByVirtualEventId(s3: string, p5) -- line: 173
	-- upvalues: fetch (copy), Promise (copy), v12 (copy), Response (copy), GraphQLError (copy)
	local v28 = p5 or fetch

	return Promise.new(function(resolve, reject) -- line: 176
		-- upvalues: v12 (copy), s3 (copy), v28 (copy), Response (copy), GraphQLError (copy)
		local v54 = v12({
			id = s3
		})
		local v55 = v28(v54, {
			method = "GET"
		}):catch(function() -- line: 179
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v55.ok then
			reject(GraphQLError.new(string.format("Failed to find RSVP counters matching VirtualEvent id: %s.", s3)))

			return
		end

		local v56 = v55:json():catch(function() -- line: 194
			return nil
		end):expect()

		if not v56 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for RSVP counters matching VirtualEvent id: %s.", s3)))

			return
		end

		resolve(v56.counters)
	end)
end
function t1.updateRsvpStatus(s4: string, p6, p7) -- line: 217
	-- upvalues: fetch (copy), Promise (copy), v11 (copy), HttpService (copy), Response (copy), GraphQLError (copy)
	local v32 = p7 or fetch

	return Promise.new(function(resolve, reject) -- line: 224
		-- upvalues: v11 (copy), s4 (copy), v32 (copy), HttpService (copy), p6 (copy), Response (copy), GraphQLError (copy)
		local v59 = v11({
			id = s4
		})
		local v60 = v32(v59, {
			method = "POST",
			body = HttpService:JSONEncode({
				rsvpStatus = p6
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function() -- line: 236
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if not v60.ok then
			reject(GraphQLError.new(string.format("Failed to set RSVP status matching VirtualEvent id: %s.", s4)))

			return
		end

		local v61 = v60:json():catch(function() -- line: 251
			return nil
		end):expect()

		if not v61 then
			reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for RSVP status matching VirtualEvent id: %s.", s4)))

			return
		end

		resolve({
			shouldSeeNotificationsUpsellModal = v61.shouldSeeNotificationsUpsellModal,
			virtualEvent = {
				id = s4,
				userRsvpStatus = v61.rsvpStatus
			}
		})
	end)
end
function t1.neverShowNotificationModalAgain(p8) -- line: 282
	-- upvalues: fetch (copy), Promise (copy), v14 (copy), Response (copy), GraphQLError (copy)
	local v34 = p8 or fetch

	return Promise.new(function(resolve, reject) -- line: 285
		-- upvalues: v14 (copy), v34 (copy), Response (copy), GraphQLError (copy)
		local v64 = v14()

		if not v34(v64, {
			method = "POST"
		}):catch(function() -- line: 290
			-- upvalues: Response (copy)
			return Response.error()
		end):expect().ok then
			reject(GraphQLError.new("Failed to update modal history"))

			return
		end

		resolve(true)
	end)
end
function t1.enablePushNotifications(p9) -- line: 306
	-- upvalues: fetch (copy), Promise (copy), v15 (copy), HttpService (copy), Response (copy), GraphQLError (copy)
	local v36 = p9 or fetch

	return Promise.new(function(resolve, reject) -- line: 309
		-- upvalues: v15 (copy), v36 (copy), HttpService (copy), Response (copy), GraphQLError (copy)
		local v67 = v15()

		if not v36(v67, {
			method = "POST",
			body = HttpService:JSONEncode({
				isEnabled = true
			}),
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function() -- line: 322
			-- upvalues: Response (copy)
			return Response.error()
		end):expect().ok then
			reject(GraphQLError.new("Failed to update notification preferences"))

			return
		end

		resolve(true)
	end)
end

return t1
