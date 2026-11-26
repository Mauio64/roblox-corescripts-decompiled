local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local createCurrentTimeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsUtils").createCurrentTimeSignal

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local ExperienceEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/ExperienceEventTypes")

local defineFastInt = game:DefineFastInt("EventStatusCheckIntervalSec", 30)

local function parseIsoDateTime(p2)
	if not p2 then
		return nil
	end

	local success, result = pcall(DateTime.fromIsoDate, p2)

	if success and result ~= nil then
		return result
	end

	return nil
end

local function deriveFormattedStartDate(p2, object)
	local eventStart = p2.eventStart
	local result

	if eventStart then
		local success
		success, result = pcall(DateTime.fromIsoDate, eventStart)

		if not success or result == nil then
			result = nil
		end
	end

	if not result then
		return nil
	end

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local now = DateTime.now()
	local localTime = result:ToLocalTime()
	local localTime2 = now:ToLocalTime()
	local formatLocalTime = result:FormatLocalTime(
		localTime.Year == localTime2.Year and "ddd, MMM DD" or "ll",
		robloxLocaleId
	)
	local formatLocalTime2 = result:FormatLocalTime("LT", robloxLocaleId)

	return object:Format("Feature.VirtualEvents.Label.DateAtTime"):gsub("{date}", formatLocalTime):gsub(
		"{time}",
		formatLocalTime2
	)
end

local eventStatus = ExperienceEventTypes.EventStatus

local function deriveFormattedRelativeTime(p2, p3, object)
	local eventStartTimestamp = p2.eventStartTimestamp
	local eventEndTimestamp = p2.eventEndTimestamp

	if not (eventStartTimestamp or eventEndTimestamp) then
		return nil
	end

	local v5 = createCurrentTimeSignal(defineFastInt)(p3)

	if eventStartTimestamp and v5 < eventStartTimestamp then
		local v6 = eventStartTimestamp - v5

		if v6 >= 604800 then
			return deriveFormattedStartDate(p2, object)
		end

		local v7 = math.floor(v6 / 86400)

		if v7 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.InDays"):gsub("{number}", (tostring(v7)))
		end

		if v7 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneDay")
		end

		local v8 = math.floor(v6 / 3600)

		if v8 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.StartsInHours"):gsub(
				"{number}",
				(tostring(v8))
			)
		end

		if v8 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneHour")
		end

		local v9 = math.floor(v6 / 60)

		if v9 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.StartsInMinutes"):gsub(
				"{number}",
				(tostring(v9))
			)
		end

		if v9 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneMin")
		end

		return object:Format("Feature.VirtualEvents.Label.StartsNow")
	elseif eventEndTimestamp and eventEndTimestamp <= v5 then
		return object:Format("Feature.VirtualEvents.Label.Ended")
	else
		return object:Format("Feature.VirtualEvents.Label.HappeningNow")
	end
end

local function deriveEventStatus(p2, p3)
	local eventStartTimestamp = p2.eventStartTimestamp

	if not eventStartTimestamp then
		return eventStatus.Upcoming
	end

	local eventEndTimestamp = p2.eventEndTimestamp
	local v5 = createCurrentTimeSignal(defineFastInt)(p3)

	if v5 < eventStartTimestamp then
		if eventStartTimestamp - v5 <= 14400 then
			return eventStatus.UpcomingImminent
		end

		return eventStatus.Upcoming
	end

	if eventEndTimestamp and eventEndTimestamp <= v5 then
		return eventStatus.Elapsed
	end

	if eventEndTimestamp and eventEndTimestamp - v5 <= 14400 then
		return eventStatus.ElapsedImminent
	end

	return eventStatus.Ongoing
end

local function deriveIsActive(p2, p3): boolean
	local v5 = deriveEventStatus(p2, p3)
	return v5 == eventStatus.Ongoing or v5 == eventStatus.ElapsedImminent
end

local function deriveShareUrl(p2)
	local id = p2.id

	if id then
		return urlBuilder.virtualevents.appsflyer({ eventId = tostring(id) })
	end

	return nil
end

return {
	enrichWithTimestamps = function(state)
		local eventStart = state.eventStart
		local result

		if eventStart then
			local success
			success, result = pcall(DateTime.fromIsoDate, eventStart)

			if not success or result == nil then
				result = nil
			end
		end

		local eventEnd = state.eventEnd
		local result2

		if eventEnd then
			local success
			success, result2 = pcall(DateTime.fromIsoDate, eventEnd)

			if not success or result2 == nil then
				result2 = nil
			end
		end

		local v5 = if result then result.UnixTimestamp else nil
		state.eventStartTimestamp = v5
		local v6 = if result2 then result2.UnixTimestamp else nil
		state.eventEndTimestamp = v6
		return state
	end,
	calculateDerivedField = function(p2, p3, p4, p5)
		if not p3 then
			return nil
		end

		if p2 == "formattedStartDate" then
			return deriveFormattedStartDate(p3, p5)
		elseif p2 == "eventStatus" then
			return deriveEventStatus(p3, p4)
		elseif p2 == "isActive" then
			local v5 = deriveEventStatus(p3, p4)
			return v5 == eventStatus.Ongoing or v5 == eventStatus.ElapsedImminent
		elseif p2 == "formattedRelativeTime" then
			return deriveFormattedRelativeTime(p3, p4, p5)
		elseif p2 == "shareUrl" then
			return deriveShareUrl(p3)
		end

		return nil
	end
}
