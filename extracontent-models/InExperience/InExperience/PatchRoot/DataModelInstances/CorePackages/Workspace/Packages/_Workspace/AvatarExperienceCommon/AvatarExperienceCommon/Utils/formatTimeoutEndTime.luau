local LocalizationService = game:GetService("LocalizationService")

local function formatTimeoutEndTime(p: string?, value: string?)
	if not p or p == "" then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(p)
	end)

	if success and result then
		return result:FormatLocalTime(value or "M/D, LT", LocalizationService.RobloxLocaleId)
	end

	return nil
end

return formatTimeoutEndTime
