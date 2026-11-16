local LocalizationService = game:GetService("LocalizationService")

local function formatTimeoutEndTime(p2, value)
	if not p2 or p2 == "" then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(p2)
	end)

	if success and result then
		return result:FormatLocalTime(value or "M/D, LT", LocalizationService.RobloxLocaleId)
	end

	return nil
end

return formatTimeoutEndTime
