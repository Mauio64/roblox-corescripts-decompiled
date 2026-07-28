local Parent = script:FindFirstAncestor("InterventionShared").Parent
local LocalizationService = game:GetService("LocalizationService")
local v3 = require(Parent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local t1 = {
	{
		threshold = 86400,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.Plural",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Day",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Days",
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Day.Expired",
		unitInSeconds = 86400,
		descriptionActiveFormatFunction = function(n1: number) -- line: 20
			return (tostring((math.ceil(n1 / 86400))))
		end
	},
	{
		threshold = 3600,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiHour",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Hour",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Hours",
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Hour.Expired",
		unitInSeconds = 3600,
		descriptionActiveFormatFunction = function(n2: number) -- line: 31
			-- upvalues: LocalizationService (copy)
			return DateTime.fromUnixTimestamp(n2):FormatUniversalTime("HH:mm", LocalizationService.RobloxLocaleId)
		end
	},
	{
		threshold = 1,
		headingPlural = "Feature.InExperienceIntervention.Heading.ChatSuspension.MultiMinute",
		headingSingle = "Feature.InExperienceIntervention.Heading.ChatSuspension.1Minute",
		descriptionActive = "Feature.InExperienceIntervention.Description.ChatSuspension.Minutes",
		descriptionExpired = "Feature.InExperienceIntervention.Description.ChatSuspension.Minute.Expired",
		unitInSeconds = 60,
		descriptionActiveFormatFunction = function(n3: number) -- line: 45
			-- upvalues: LocalizationService (copy)
			return DateTime.fromUnixTimestamp(n3):FormatUniversalTime("mm:ss", LocalizationService.RobloxLocaleId)
		end
	}
}

local function v5(n4: number, b1: boolean) -- line: 58
	-- upvalues: v3 (copy), t1 (copy)
	if b1 then
		return v3:Format("Feature.InExperienceIntervention.Heading.ChatSuspension.Expired")
	end

	for _, v12 in t1 do
		if n4 == v12.unitInSeconds then
			return (v3:Format(v12.headingSingle))
		end

		if n4 > v12.threshold then
			local v13 = math.ceil(n4 / v12.unitInSeconds)

			return (v3:Format(v12.headingPlural, {
				number = v13
			}))
		end
	end

	return ""
end

return function(p1, n5: number?) -- line: 83
	-- upvalues: v5 (copy), t1 (copy), v3 (copy)
	if p1 == nil or n5 == nil then
		return 0, "", ""
	end

	local dateTime = DateTime.now()
	local v17 = math.max(p1.UnixTimestamp - dateTime.UnixTimestamp, 0)
	local v18 = n5 / 1000000000
	local v19 = v17 <= 0
	local s1 = ""
	local v21 = v5(v18, v19)

	for _, v23 in t1 do
		if not v19 then
			if not (v17 >= v23.threshold) then
				continue
			end

			s1 = v3:Format(v23.descriptionActive, {
				number = v23.descriptionActiveFormatFunction(v17)
			})

			return v17, v21, s1
		end

		if v18 >= v23.threshold then
			s1 = v3:Format(v23.descriptionExpired, {
				number = math.ceil(v18 / v23.unitInSeconds)
			})

			return v17, v21, s1
		end
	end

	return v17, v21, s1
end
