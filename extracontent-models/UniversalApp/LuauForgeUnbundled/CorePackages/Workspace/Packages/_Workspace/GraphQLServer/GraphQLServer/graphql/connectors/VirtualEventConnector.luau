local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local fetch = Fetch.fetch

local response = Fetch.Response
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder

local v6 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")
local v7 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")
local v8 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps/counters")
local v9 = urlBuilder.fromString("apis:virtual-events/v1/universes/{id}/virtual-events?cursor={cursor}&limit={limit}&fromUtc={fromUtc}")

local v10 = urlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")
local v11 = urlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")
return {
	findVirtualEventById = function(p2, p3)
		local v12 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v12(v6({ id = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format("Failed to find VirtualEvent matching id: %s.", p2)))
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for VirtualEvent matching id: %s.",
					p2
				)))
			end
		end)
	end,
	findVirtualEventsByUniverseId = function(p2, data, p3)
		local v12 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v12(v9({
				id = p2,
				cursor = not (data and data.cursor) and "" or data.cursor,
				limit = not (data and data.limit) and 25 or data.limit,
				fromUtc = not (data and data.fromUtc) and "" or data.fromUtc
			}), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to find experience matching universeId: %i",
					p2
				)))
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({
					cursor = expect2.nextPageCursor,
					virtualEvents = expect2.data
				})
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for experience matching universeId: %i",
					p2
				)))
			end
		end)
	end,
	findRsvpsByVirtualEventId = function(p2, p3)
		local v12 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v12(v7({ id = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to find RSVPs matching VirtualEvent id: %s.",
					p2
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.data)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for RSVPs matching VirtualEvent id: %s.",
					p2
				)))
			end
		end)
	end,
	findRsvpCountersByVirtualEventId = function(p2, p3)
		local v12 = p3 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v12(v8({ id = p2 }), { method = "GET" }):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to find RSVP counters matching VirtualEvent id: %s.",
					p2
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback(expect2.counters)
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for RSVP counters matching VirtualEvent id: %s.",
					p2
				)))
			end
		end)
	end,
	updateRsvpStatus = function(p2, p3, p4)
		local v12 = p4 or fetch
		return Promise.new(function(callback, callback2)
			local expect = v12(v7({ id = p2 }), {
				method = "POST",
				body = HttpService:JSONEncode({ rsvpStatus = p3 }),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function()
				return response.error()
			end):expect()

			if not expect.ok then
				callback2(graphQLError.new(string.format(
					"Failed to set RSVP status matching VirtualEvent id: %s.",
					p2
				)))

				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if expect2 then
				callback({
					shouldSeeNotificationsUpsellModal = expect2.shouldSeeNotificationsUpsellModal,
					virtualEvent = { id = p2, userRsvpStatus = expect2.rsvpStatus }
				})
			else
				callback2(graphQLError.new(string.format(
					"Failed to decode HTTP response as JSON for RSVP status matching VirtualEvent id: %s.",
					p2
				)))
			end
		end)
	end,
	neverShowNotificationModalAgain = function(p2)
		local v12 = p2 or fetch
		return Promise.new(function(callback, callback2)
			if v12(v10(), { method = "POST" }):catch(function()
				return response.error()
			end):expect().ok then
				callback(true)
			else
				callback2(graphQLError.new("Failed to update modal history"))
			end
		end)
	end,
	enablePushNotifications = function(p2)
		local v12 = p2 or fetch
		return Promise.new(function(callback, callback2)
			if v12(v11(), {
				method = "POST",
				body = HttpService:JSONEncode({ isEnabled = true }),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function()
				return response.error()
			end):expect().ok then
				callback(true)
			else
				callback2(graphQLError.new("Failed to update notification preferences"))
			end
		end)
	end
}
