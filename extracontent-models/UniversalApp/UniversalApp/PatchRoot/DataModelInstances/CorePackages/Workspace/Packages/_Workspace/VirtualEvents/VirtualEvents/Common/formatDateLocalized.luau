local LocalizationService = game:GetService("LocalizationService")

local function formatDate(s1: string, p1) -- line: 3
	-- upvalues: LocalizationService (copy)
	local dateTime = DateTime.now()
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return s1:gsub("{date}", p1:FormatLocalTime(not (p1:ToLocalTime().Year > dateTime:ToLocalTime().Year) and "ddd, MMM DD" or "ll", RobloxLocaleId)):gsub("{time}", p1:FormatLocalTime("LT", RobloxLocaleId))
end

return formatDate
