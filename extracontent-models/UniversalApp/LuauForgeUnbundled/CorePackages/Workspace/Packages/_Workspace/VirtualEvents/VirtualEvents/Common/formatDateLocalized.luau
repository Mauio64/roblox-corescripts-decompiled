local LocalizationService = game:GetService("LocalizationService")

local function formatDate(value, object)
	local now = DateTime.now()
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	return value:gsub(
		"{date}",
		object:FormatLocalTime(
			object:ToLocalTime().Year > now:ToLocalTime().Year and "ll" or "ddd, MMM DD",
			robloxLocaleId
		)
	):gsub(
		"{time}",
		object:FormatLocalTime("LT", robloxLocaleId)
	)
end

return formatDate
