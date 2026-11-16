local LocalizationService = game:GetService("LocalizationService")
local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createCurrentTimeSignal = SignalsUtils.createCurrentTimeSignal

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local ExperienceEventTypes = require(script.Parent.ExperienceEventTypes)

local defineFastInt = game:DefineFastInt("EventStatusCheckIntervalSec", 30)

local function parseIsoDateTime(p: string?)
	if not p then
		return nil
	end

	local success, result = pcall(DateTime.fromIsoDate, p)
	return if success and result ~= nil then result else nil
end

local function deriveFormattedStartDate(p, object)
	local eventStart = p.eventStart
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

local EventStatus = ExperienceEventTypes.EventStatus

local function deriveFormattedRelativeTime(p, p2, object)
	local eventStartTimestamp = p.eventStartTimestamp
	local eventEndTimestamp = p.eventEndTimestamp

	if not (eventStartTimestamp or eventEndTimestamp) then
		return nil
	end

	local v = createCurrentTimeSignal(defineFastInt)(p2)

	if eventStartTimestamp and v < eventStartTimestamp then
		local v2 = eventStartTimestamp - v

		if v2 >= 604800 then
			return deriveFormattedStartDate(p, object)
		end

		local v3 = math.floor(v2 / 86400)

		if v3 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.InDays"):gsub("{number}", (tostring(v3)))
		end

		if v3 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneDay")
		end

		local v4 = math.floor(v2 / 3600)

		if v4 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.StartsInHours"):gsub("{number}", (tostring(v4)))
		end

		if v4 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneHour")
		end

		local v5 = math.floor(v2 / 60)

		if v5 >= 2 then
			return object:Format("Feature.VirtualEvents.Label.StartsInMinutes"):gsub("{number}", (tostring(v5)))
		end

		if v5 == 1 then
			return object:Format("Feature.VirtualEvents.Label.StartsInOneMin")
		end

		return object:Format("Feature.VirtualEvents.Label.StartsNow")
	elseif eventEndTimestamp and eventEndTimestamp <= v then
		return object:Format("Feature.VirtualEvents.Label.Ended")
	else
		return object:Format("Feature.VirtualEvents.Label.HappeningNow")
	end
end

local function deriveEventStatus(p, p2)
	local eventStartTimestamp = p.eventStartTimestamp

	if not eventStartTimestamp then
		return EventStatus.Upcoming
	end

	local eventEndTimestamp = p.eventEndTimestamp
	local v = createCurrentTimeSignal(defineFastInt)(p2)

	if v < eventStartTimestamp then
		if eventStartTimestamp - v <= 14400 then
			return EventStatus.UpcomingImminent
		end

		return EventStatus.Upcoming
	end

	if eventEndTimestamp and eventEndTimestamp <= v then
		return EventStatus.Elapsed
	end

	if eventEndTimestamp and eventEndTimestamp - v <= 14400 then
		return EventStatus.ElapsedImminent
	end

	return EventStatus.Ongoing
end

local function deriveIsActive(p, p2): boolean -- 1 equivalent call inferred from this helper
	local v = deriveEventStatus(p, p2)
	return v == EventStatus.Ongoing or v == EventStatus.ElapsedImminent
end

local function deriveShareUrl(p)
	local id = p.id

	if id then
		return urlBuilder.virtualevents.appsflyer({ eventId = tostring(id) })
	end

	return nil
end

local ExperienceEventDerivedFields = {}

function ExperienceEventDerivedFields.enrichWithTimestamps(state)
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

	local eventStartTimestamp

	if result then
		eventStartTimestamp = result.UnixTimestamp
	end

	state.eventStartTimestamp = eventStartTimestamp
	local eventEndTimestamp

	if result2 then
		eventEndTimestamp = result2.UnixTimestamp
	end

	state.eventEndTimestamp = eventEndTimestamp
	return state
end

function ExperienceEventDerivedFields.calculateDerivedField(p: string, p2, p3, p4)
	if not p2 then
		return nil
	end

	if p == "formattedStartDate" then
		return deriveFormattedStartDate(p2, p4)
	elseif p == "eventStatus" then
		return deriveEventStatus(p2, p3)
	elseif p == "isActive" then
		return deriveIsActive(p2, p3) -- inferred equivalent call
	elseif p == "formattedRelativeTime" then
		return deriveFormattedRelativeTime(p2, p3, p4)
	elseif p == "shareUrl" then
		return deriveShareUrl(p2)
	end

	return nil
end

return ExperienceEventDerivedFields
