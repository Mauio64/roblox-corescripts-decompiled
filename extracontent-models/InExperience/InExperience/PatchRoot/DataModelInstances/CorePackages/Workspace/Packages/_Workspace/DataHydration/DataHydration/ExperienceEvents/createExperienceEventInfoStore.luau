local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)

local ExperienceEventTypes = require(script.Parent.ExperienceEventTypes)
local ExperienceEventDerivedFields = require(script.Parent.ExperienceEventDerivedFields)
local ExperienceEventsUrlBuilder = require(script.Parent.ExperienceEventsUrlBuilder)
local createDataResolver = require(DataHydration.createDataResolver)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local logResponseError = DiscoveryUtils.logResponseError
local updateEventRsvp = require(script.Parent.updateEventRsvp)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport

local function createExperienceEventInfoStore() -- line: 30
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), ExperienceEventDerivedFields (copy), ExperienceEventTypes (copy), updateEventRsvp (copy), logResponseError (copy), ExperienceEventsUrlBuilder (copy), DiscoveryEventErrorLogger (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
	local v17 = createDataCache()
	local v18 = createDataResolver({
		supportsMultiGet = false,
		cache = v17,
		fetchFn = function(_: {[any]: any}) -- line: 35
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	local function updateExperienceEventInfos(t2: {[any]: any}) -- line: 44
		-- upvalues: ExperienceEventDerivedFields (copy), v17 (copy)
		for v22, v23 in t2 do
			t2[v22] = ExperienceEventDerivedFields.enrichWithTimestamps(v23)
		end

		v17.updateItems(t2)
	end

	return {
		getExperienceEventInfo = v18.getCachedItem,
		getExperienceEventInfos = v18.getCachedItems,
		updateExperienceEventInfo = v17.updateItem,
		updateExperienceEventInfos = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then v17.updateItems else updateExperienceEventInfos,
		calculateDerivedField = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else ExperienceEventDerivedFields.calculateDerivedField,
		patchRsvpStatus = function(s1: string, b1: boolean) -- line: 51
			-- upvalues: v18 (copy), ExperienceEventTypes (copy), updateEventRsvp (copy), v17 (copy), logResponseError (copy), ExperienceEventsUrlBuilder (copy), DiscoveryEventErrorLogger (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
			local v26 = v18.getCachedItem(s1).data()
			local v27 = if not b1 then ExperienceEventTypes.EventRsvpTypes.NotGoing else ExperienceEventTypes.EventRsvpTypes.Going
			local v28 = updateEventRsvp(s1, v27):andThen(function(p1) -- line: 60
				-- upvalues: v26 (copy), b1 (copy), v17 (copy), s1 (copy)
				if v26 then
					local v30 = v26.rsvpCount or 0
					local t3 = {
						id = v26.id,
						title = v26.title,
						subtitle = v26.subtitle,
						eventStart = v26.eventStart,
						eventEnd = v26.eventEnd,
						userRsvp = b1,
						mediaAssetId = v26.mediaAssetId,
						description = v26.description,
						rsvpCount = v30 + (not b1 and -1 or 1)
					}

					v17.updateItem(s1, t3)
				end

				return p1 and p1.responseBody
			end):catch(function(p2) -- line: 78
				-- upvalues: v26 (copy), v17 (copy), s1 (copy), logResponseError (copy), ExperienceEventsUrlBuilder (copy), DiscoveryEventErrorLogger (copy), b1 (copy)
				if v26 then
					v17.updateItem(s1, v26)
				end

				local v33 = if type(p2) ~= "table" or not p2.StatusCode then nil else p2.StatusCode
				local v34 = if type(p2) ~= "table" or not p2.StatusMessage then if type(p2) ~= "string" then nil else p2 else p2.StatusMessage

				logResponseError(ExperienceEventsUrlBuilder.RSVP_UPDATE_URL, {
					StatusCode = v33
				})
				DiscoveryEventErrorLogger.reportError("patchRsvpStatus", "Error updating event RSVP", {
					eventId = s1,
					isRsvpGoing = b1,
					statusCode = v33,
					statusMessage = v34
				})
			end)

			if FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport then
				return v28
			end

			return nil
		end,
		clear = v18.clear,
		dispose = v18.dispose
	}
end

return createExperienceEventInfoStore
