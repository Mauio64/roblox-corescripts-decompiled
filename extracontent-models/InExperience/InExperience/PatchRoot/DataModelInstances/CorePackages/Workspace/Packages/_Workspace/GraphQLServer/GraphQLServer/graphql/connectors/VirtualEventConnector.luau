local GraphQLServer = script:FindFirstAncestor("GraphQLServer")

local HttpService = game:GetService("HttpService")

require(GraphQLServer.Parent.LuauPolyfill)

require(GraphQLServer.graphql.generatedTypes)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch

local Response = Fetch.Response
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local v = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")
local v2 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")
local v3 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps/counters")
local v4 = urlBuilder.fromString("apis:virtual-events/v1/universes/{id}/virtual-events?cursor={cursor}&limit={limit}&fromUtc={fromUtc}")

local v5 = urlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")
local v6 = urlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")
local VirtualEventConnector = {}

function VirtualEventConnector.findVirtualEventById(id: string, p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v({ id = id }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find VirtualEvent matching id: %s.", id)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for VirtualEvent matching id: %s.",
				id
			)))
		end
	end)
end

function VirtualEventConnector.findVirtualEventsByUniverseId(id: number, data, p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v4({
			id = id,
			cursor = not (data and data.cursor) and "" or data.cursor,
			limit = not (data and data.limit) and 25 or data.limit,
			fromUtc = not (data and data.fromUtc) and "" or data.fromUtc
		}), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find experience matching universeId: %i", id)))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({ cursor = expect2.nextPageCursor, virtualEvents = expect2.data })
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for experience matching universeId: %i",
				id
			)))
		end
	end)
end

function VirtualEventConnector.findRsvpsByVirtualEventId(id: string, p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v2({ id = id }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find RSVPs matching VirtualEvent id: %s.", id)))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.data)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for RSVPs matching VirtualEvent id: %s.",
				id
			)))
		end
	end)
end

function VirtualEventConnector.findRsvpCountersByVirtualEventId(id: string, p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v3({ id = id }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to find RSVP counters matching VirtualEvent id: %s.", id)))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2.counters)
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for RSVP counters matching VirtualEvent id: %s.",
				id
			)))
		end
	end)
end

function VirtualEventConnector.updateRsvpStatus(id: string, rsvpStatus, p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v2({ id = id }), {
			method = "POST",
			body = HttpService:JSONEncode({ rsvpStatus = rsvpStatus }),
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback2(GraphQLError.new(string.format("Failed to set RSVP status matching VirtualEvent id: %s.", id)))

			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({
				shouldSeeNotificationsUpsellModal = expect2.shouldSeeNotificationsUpsellModal,
				virtualEvent = { id = id, userRsvpStatus = expect2.rsvpStatus }
			})
		else
			callback2(GraphQLError.new(string.format(
				"Failed to decode HTTP response as JSON for RSVP status matching VirtualEvent id: %s.",
				id
			)))
		end
	end)
end

function VirtualEventConnector.neverShowNotificationModalAgain(p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		if v7(v5(), { method = "POST" }):catch(function()
			return Response.error()
		end):expect().ok then
			callback(true)
		else
			callback2(GraphQLError.new("Failed to update modal history"))
		end
	end)
end

function VirtualEventConnector.enablePushNotifications(p)
	local v7 = p or fetch
	return Promise.new(function(callback, callback2)
		if v7(v6(), {
			method = "POST",
			body = HttpService:JSONEncode({ isEnabled = true }),
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function()
			return Response.error()
		end):expect().ok then
			callback(true)
		else
			callback2(GraphQLError.new("Failed to update notification preferences"))
		end
	end)
end

return VirtualEventConnector
