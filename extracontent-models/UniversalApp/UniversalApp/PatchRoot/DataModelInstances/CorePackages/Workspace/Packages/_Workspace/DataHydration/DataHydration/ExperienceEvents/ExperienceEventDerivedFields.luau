local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.Signals)

local createCurrentTimeSignal = require(Parent.SignalsUtils).createCurrentTimeSignal
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local ExperienceEventTypes = require(script.Parent.ExperienceEventTypes)
local v6 = game:DefineFastInt("EventStatusCheckIntervalSec", 30)

local function parseIsoDateTime(s1: string?) -- line: 21
	if not s1 then
		return nil
	end

	local ok, result = pcall(DateTime.fromIsoDate, s1)

	if not ok or result == nil then
		return nil
	end

	return result
end
local function deriveFormattedStartDate(p1, p2) -- line: 41
	-- upvalues: LocalizationService (copy)
	local eventStart = p1.eventStart
	local v29

	if not eventStart then
		v29 = nil
	else
		local ok, result = pcall(DateTime.fromIsoDate, eventStart)

		v29 = if not not ok and result ~= nil then result else nil
	end

	if not v29 then
		return nil
	end

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local dateTime = DateTime.now()
	local v34 = v29:ToLocalTime()
	local v35 = dateTime:ToLocalTime()
	local v36 = v29:FormatLocalTime(v34.Year == v35.Year and "ddd, MMM DD" or "ll", RobloxLocaleId)
	local v37 = v29:FormatLocalTime("LT", RobloxLocaleId)

	return p2:Format("Feature.VirtualEvents.Label.DateAtTime"):gsub("{date}", v36):gsub("{time}", v37)
end

local EventStatus = ExperienceEventTypes.EventStatus

local function deriveFormattedRelativeTime(p3, p4, p5) -- line: 69
	-- upvalues: createCurrentTimeSignal (copy), v6 (copy), deriveFormattedStartDate (copy)
	local eventStartTimestamp = p3.eventStartTimestamp
	local eventEndTimestamp = p3.eventEndTimestamp

	if not eventStartTimestamp and not eventEndTimestamp then
		return nil
	end

	local v43 = createCurrentTimeSignal(v6)(p4)

	if eventStartTimestamp and v43 < eventStartTimestamp then
		local v44 = eventStartTimestamp - v43

		if v44 >= 604800 then
			return deriveFormattedStartDate(p3, p5)
		end

		local v45 = math.floor(v44 / 86400)

		if v45 >= 2 then
			return p5:Format("Feature.VirtualEvents.Label.InDays"):gsub("{number}", (tostring(v45)))
		end

		if v45 == 1 then
			return p5:Format("Feature.VirtualEvents.Label.StartsInOneDay")
		end

		local v46 = math.floor(v44 / 3600)

		if v46 >= 2 then
			return p5:Format("Feature.VirtualEvents.Label.StartsInHours"):gsub("{number}", (tostring(v46)))
		end

		if v46 == 1 then
			return p5:Format("Feature.VirtualEvents.Label.StartsInOneHour")
		end

		local v47 = math.floor(v44 / 60)

		if v47 >= 2 then
			return p5:Format("Feature.VirtualEvents.Label.StartsInMinutes"):gsub("{number}", (tostring(v47)))
		end

		if v47 == 1 then
			return p5:Format("Feature.VirtualEvents.Label.StartsInOneMin")
		end

		return p5:Format("Feature.VirtualEvents.Label.StartsNow")
	end

	if eventEndTimestamp and eventEndTimestamp <= v43 then
		return p5:Format("Feature.VirtualEvents.Label.Ended")
	end

	return p5:Format("Feature.VirtualEvents.Label.HappeningNow")
end
local function deriveEventStatus(p6, p7) -- line: 122
	-- upvalues: EventStatus (copy), createCurrentTimeSignal (copy), v6 (copy)
	local eventStartTimestamp = p6.eventStartTimestamp

	if not eventStartTimestamp then
		return EventStatus.Upcoming
	end

	local eventEndTimestamp = p6.eventEndTimestamp
	local v52 = createCurrentTimeSignal(v6)(p7)

	if v52 < eventStartTimestamp then
		if eventStartTimestamp - v52 <= 14400 then
			return EventStatus.UpcomingImminent
		end

		return EventStatus.Upcoming
	end

	if eventEndTimestamp and eventEndTimestamp <= v52 then
		return EventStatus.Elapsed
	end

	if eventEndTimestamp and eventEndTimestamp - v52 <= 14400 then
		return EventStatus.ElapsedImminent
	end

	return EventStatus.Ongoing
end
local function deriveIsActive(p8, p9) -- line: 145
	-- upvalues: deriveEventStatus (copy), EventStatus (copy)
	local v55 = deriveEventStatus(p8, p9)

	return v55 == EventStatus.Ongoing or v55 == EventStatus.ElapsedImminent
end
local function deriveShareUrl(p10) -- line: 150
	-- upvalues: UrlBuilder (copy)
	local id = p10.id

	if not id then
		return nil
	end

	return UrlBuilder.virtualevents.appsflyer({
		eventId = tostring(id)
	})
end

return {
	enrichWithTimestamps = function(p11) -- line: 32
		local eventStart = p11.eventStart
		local v19

		if not eventStart then
			v19 = nil
		else
			local ok, result = pcall(DateTime.fromIsoDate, eventStart)

			v19 = if not not ok and result ~= nil then result else nil
		end

		local eventEnd = p11.eventEnd
		local v23

		if not eventEnd then
			v23 = nil
		else
			local ok, result = pcall(DateTime.fromIsoDate, eventEnd)

			v23 = if not not ok and result ~= nil then result else nil
		end

		p11.eventStartTimestamp = if not v19 then nil else v19.UnixTimestamp
		p11.eventEndTimestamp = if not v23 then nil else v23.UnixTimestamp

		return p11
	end,
	calculateDerivedField = function(s2: string, p12, p13, p14) -- line: 159
		-- upvalues: deriveFormattedStartDate (copy), deriveEventStatus (copy), EventStatus (copy), deriveFormattedRelativeTime (copy), deriveShareUrl (copy)
		if not p12 then
			return nil
		end

		if s2 == "formattedStartDate" then
			return deriveFormattedStartDate(p12, p14)
		end

		if s2 == "eventStatus" then
			return (deriveEventStatus(p12, p13))
		end

		if s2 == "isActive" then
			local v62 = deriveEventStatus(p12, p13)

			return v62 == EventStatus.Ongoing or v62 == EventStatus.ElapsedImminent
		end

		if s2 == "formattedRelativeTime" then
			return deriveFormattedRelativeTime(p12, p13, p14)
		end

		if s2 == "shareUrl" then
			return deriveShareUrl(p12)
		end

		return nil
	end
}
