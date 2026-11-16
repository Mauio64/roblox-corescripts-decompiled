local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
local ExperienceEventTypes = require(script.Parent.ExperienceEventTypes)
local ExperienceEventDerivedFields = require(script.Parent.ExperienceEventDerivedFields)
local ExperienceEventsUrlBuilder = require(script.Parent.ExperienceEventsUrlBuilder)
local createDataResolver = require(DataHydration.createDataResolver)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local logResponseError = DiscoveryUtils.logResponseError

local updateEventRsvp = require(script.Parent.updateEventRsvp)

local function createExperienceEventInfoStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	local function updateExperienceEventInfos(items)
		for k, item in items do
			items[k] = ExperienceEventDerivedFields.enrichWithTimestamps(item)
		end

		dataCache.updateItems(items)
	end

	local function patchRsvpStatus(eventId: string, flag: boolean)
		local data = dataResolver.getCachedItem(eventId).data()
		local v

		if flag then
			v = ExperienceEventTypes.EventRsvpTypes.Going
		else
			v = ExperienceEventTypes.EventRsvpTypes.NotGoing
		end

		return (updateEventRsvp(eventId, v):andThen(function(p)
			if data then
				local rsvpCount = data.rsvpCount or 0
				local v2 = {
					id = data.id,
					title = data.title,
					subtitle = data.subtitle,
					eventStart = data.eventStart,
					eventEnd = data.eventEnd,
					userRsvp = flag,
					mediaAssetId = data.mediaAssetId,
					description = data.description,
					rsvpCount = rsvpCount + (flag and 1 or -1)
				}

				dataCache.updateItem(eventId, v2)
			end

			return p and p.responseBody
		end):catch(function(statusMessage)
			if data then
				dataCache.updateItem(eventId, data)
			end

			local statusCode

			if type(statusMessage) == "table" and statusMessage.StatusCode then
				statusCode = statusMessage.StatusCode
			end

			if type(statusMessage) == "table" and statusMessage.StatusMessage then
				statusMessage = statusMessage.StatusMessage
			elseif type(statusMessage) ~= "string" then
				statusMessage = nil
			end

			logResponseError(ExperienceEventsUrlBuilder.RSVP_UPDATE_URL, { StatusCode = statusCode })

			DiscoveryEventErrorLogger.reportError("patchRsvpStatus", "Error updating event RSVP", {
				eventId = eventId,
				isRsvpGoing = flag,
				statusCode = statusCode,
				statusMessage = statusMessage
			})
		end))
	end

	return {
		getExperienceEventInfo = dataResolver.getCachedItem,
		getExperienceEventInfos = dataResolver.getCachedItems,
		updateExperienceEventInfo = dataCache.updateItem,
		updateExperienceEventInfos = updateExperienceEventInfos,
		calculateDerivedField = ExperienceEventDerivedFields.calculateDerivedField,
		patchRsvpStatus = patchRsvpStatus,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createExperienceEventInfoStore
