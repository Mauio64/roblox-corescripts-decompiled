local parent = script:FindFirstAncestor("InterventionShared").Parent

local LocalizationService = game:GetService("LocalizationService")
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)

local v = {
	{
		threshold = 86400,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.Plural",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Day",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Days",
		descriptionActiveFormatFunction = function(p: number)
			return (tostring((math.ceil(p / 86400))))
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Day.Expired",
		unitInSeconds = 86400
	},
	{
		threshold = 3600,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiHour",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Hour",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Hours",
		descriptionActiveFormatFunction = function(p: number)
			return DateTime.fromUnixTimestamp(p):FormatUniversalTime("HH:mm", LocalizationService.RobloxLocaleId)
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Hour.Expired",
		unitInSeconds = 3600
	},
	{
		threshold = 1,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiMinute",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Minute",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Minutes",
		descriptionActiveFormatFunction = function(p: number)
			return DateTime.fromUnixTimestamp(p):FormatUniversalTime("mm:ss", LocalizationService.RobloxLocaleId)
		end,
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Minute.Expired",
		unitInSeconds = 60
	}
}

local function fn(p: number, flag: boolean)
	if flag then
		return localization:Format("Feature.InExperienceIntervention.Heading.ChatSuspension.Expired")
	end

	for _, v2 in v do
		if p == v2.unitInSeconds then
			return (localization:Format(v2.headingSingle))
		end

		if v2.threshold < p then
			local number = math.ceil(p / v2.unitInSeconds)
			return (localization:Format(v2.headingPlural, { number = number }))
		end
	end

	return ""
end

return function(p, p2: number?)
	if p == nil or p2 == nil then
		return 0, "", ""
	end

	local now = DateTime.now()
	local v2 = math.max(p.UnixTimestamp - now.UnixTimestamp, 0)
	local v3 = p2 / 1000000000
	local v4 = v2 <= 0

	local v5 = fn(v3, v4)
	local v6 = ""

	for _, v7 in v do
		if v4 then
			if v7.threshold <= v3 then
				v6 = localization:Format(v7.descriptionExpired, {
					number = math.ceil(v3 / v7.unitInSeconds)
				})
				break
			end
		elseif v7.threshold <= v2 then
			v6 = localization:Format(v7.descriptionActive, {
				number = v7.descriptionActiveFormatFunction(v2)
			})
			break
		end
	end

	return v2, v5, v6
end
