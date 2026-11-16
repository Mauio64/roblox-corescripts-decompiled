local module = require("@luauforge/deferred/ejR")
local module2 = require("@luauforge/deferred/ekk")

local useLocalization = module2.Hooks.useLocalization
local robloxLocaleIdKey = module2.RobloxLocaleIdKey

local v5 = {
	now = "Feature.FriendsActivityFeed.Timestamp.Now",
	oneMinute = "Feature.FriendsActivityFeed.Timestamp.OneMinuteAbbreviated",
	minutes = "Feature.FriendsActivityFeed.Timestamp.MinutesAbbreviatedPlural",
	oneHour = "Feature.FriendsActivityFeed.Timestamp.OneHourAbbreviated",
	hours = "Feature.FriendsActivityFeed.Timestamp.HoursAbbreviatedPlural",
	oneDay = "Feature.FriendsActivityFeed.Timestamp.OneDayAbbreviated",
	days = "Feature.FriendsActivityFeed.Timestamp.DaysAbbreviatedPlural",
	oneWeek = "Feature.FriendsActivityFeed.Timestamp.OneWeekAbbreviated",
	weeks = "Feature.FriendsActivityFeed.Timestamp.WeeksAbbreviatedPlural"
}

local function getAgeMilliseconds(p2, p3)
	return (math.max(p3 - p2, 0))
end

local function getLocalizationDescriptor(p2, state)
	if p2 == nil or p2 <= 0 then
		return nil
	end

	local v6 = math.max(state - p2, 0)

	if v6 < 60000 then
		return "Feature.FriendsActivityFeed.Timestamp.Now"
	end

	if v6 < 3600000 then
		local v7 = math.floor(v6 / 60000)

		if v7 == 1 then
			return "Feature.FriendsActivityFeed.Timestamp.OneMinuteAbbreviated"
		end

		return {
			"Feature.FriendsActivityFeed.Timestamp.MinutesAbbreviatedPlural",
			num_minutes = v7
		}
	elseif v6 < 86400000 then
		local v7 = math.floor(v6 / 3600000)

		if v7 == 1 then
			return "Feature.FriendsActivityFeed.Timestamp.OneHourAbbreviated"
		end

		return {
			"Feature.FriendsActivityFeed.Timestamp.HoursAbbreviatedPlural",
			num_hours = v7
		}
	elseif v6 < 604800000 then
		local v7 = math.floor(v6 / 86400000)

		if v7 == 1 then
			return "Feature.FriendsActivityFeed.Timestamp.OneDayAbbreviated"
		end

		return {
			"Feature.FriendsActivityFeed.Timestamp.DaysAbbreviatedPlural",
			num_days = v7
		}
	else
		if not (v6 < 2592000000) then
			return nil
		end

		local v7 = math.floor(v6 / 604800000)

		if v7 == 1 then
			return "Feature.FriendsActivityFeed.Timestamp.OneWeekAbbreviated"
		end

		return {
			"Feature.FriendsActivityFeed.Timestamp.WeeksAbbreviatedPlural",
			num_weeks = v7
		}
	end
end

local function getDelayUntilNextBoundarySeconds(p2, p3, p4)
	return math.min(p3 - p2 % p3, p4 - p2) / 1000
end

local function getNextUpdateDelaySeconds(p2, unixTimestampMillis)
	if p2 == nil or p2 <= 0 then
		return nil
	end

	local v6 = math.max(unixTimestampMillis - p2, 0)

	if v6 < 60000 then
		return (math.min(30, (60000 - v6) / 1000))
	end

	if v6 < 3600000 then
		return math.min(60000 - v6 % 60000, 3600000 - v6) / 1000
	end

	if v6 < 86400000 then
		return math.min(3600000 - v6 % 3600000, 86400000 - v6) / 1000
	end

	if v6 < 604800000 then
		return math.min(86400000 - v6 % 86400000, 604800000 - v6) / 1000
	end

	if v6 < 2592000000 then
		return math.min(604800000 - v6 % 604800000, 2592000000 - v6) / 1000
	end

	return nil
end

local function useRelativeTimestamp(p2)
	local state, setState = module.useState(function()
		return DateTime.now().UnixTimestampMillis
	end)

	local localizationDescriptor = getLocalizationDescriptor(p2, state)
	local v6 = useLocalization({ timestamp = localizationDescriptor })

	module.useEffect(function()
		setState(DateTime.now().UnixTimestampMillis)

		if p2 == nil or p2 <= 0 then
			return
		end

		local flag = false
		local thread = nil
		local function scheduleUpdate()
			local nextUpdateDelaySeconds = getNextUpdateDelaySeconds(p2, DateTime.now().UnixTimestampMillis)

			if nextUpdateDelaySeconds == nil then
				thread = nil
			else
				thread = task.delay(nextUpdateDelaySeconds, function()
					thread = nil

					if flag then
						return
					end

					setState(DateTime.now().UnixTimestampMillis)
					scheduleUpdate()
				end)
			end
		end

		scheduleUpdate()

		return function()
			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { p2 })

	if p2 == nil or p2 <= 0 then
		return nil
	end

	if localizationDescriptor == nil then
		return DateTime.fromUnixTimestampMillis(p2):FormatLocalTime("ll", v6[robloxLocaleIdKey])
	end

	return v6.timestamp
end

return useRelativeTimestamp
