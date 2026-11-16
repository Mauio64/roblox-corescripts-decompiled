local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local ExperienceEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/ExperienceEventTypes")
local ExperienceEventDerivedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/ExperienceEventDerivedFields")
local ExperienceEventsUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/ExperienceEventsUrlBuilder")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local logResponseError = DiscoveryUtils.logResponseError

local updateEventRsvp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/updateEventRsvp")

local function createExperienceEventInfoStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	local function updateExperienceEventInfos(items)
		for k, item in items do
			items[k] = ExperienceEventDerivedFields.enrichWithTimestamps(item)
		end

		v5.updateItems(items)
	end

	local function patchRsvpStatus(p2, p3)
		local data = v6.getCachedItem(p2).data()

		local v7 = if p3 then ExperienceEventTypes.EventRsvpTypes.Going else ExperienceEventTypes.EventRsvpTypes.NotGoing

		return (updateEventRsvp(p2, v7):andThen(function(p4)
			if data then
				local rsvpCount = data.rsvpCount or 0
				local v8 = {
					id = data.id,
					title = data.title,
					subtitle = data.subtitle,
					eventStart = data.eventStart,
					eventEnd = data.eventEnd,
					userRsvp = p3,
					mediaAssetId = data.mediaAssetId,
					description = data.description,
					rsvpCount = rsvpCount + (p3 and 1 or -1)
				}

				v5.updateItem(p2, v8)
			end

			return p4 and p4.responseBody
		end):catch(function(value)
			if data then
				v5.updateItem(p2, data)
			end

			local statusCode = if type(value) == "table" and value.StatusCode then value.StatusCode else nil

			if type(value) == "table" and value.StatusMessage then
				value = value.StatusMessage
			elseif type(value) ~= "string" then
				value = nil
			end

			logResponseError(ExperienceEventsUrlBuilder.RSVP_UPDATE_URL, { StatusCode = statusCode })

			discoveryEventErrorLogger.reportError("patchRsvpStatus", "Error updating event RSVP", {
				eventId = p2,
				isRsvpGoing = p3,
				statusCode = statusCode,
				statusMessage = value
			})
		end))
	end

	return {
		getExperienceEventInfo = v6.getCachedItem,
		getExperienceEventInfos = v6.getCachedItems,
		updateExperienceEventInfo = v5.updateItem,
		updateExperienceEventInfos = updateExperienceEventInfos,
		calculateDerivedField = ExperienceEventDerivedFields.calculateDerivedField,
		patchRsvpStatus = patchRsvpStatus,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createExperienceEventInfoStore
