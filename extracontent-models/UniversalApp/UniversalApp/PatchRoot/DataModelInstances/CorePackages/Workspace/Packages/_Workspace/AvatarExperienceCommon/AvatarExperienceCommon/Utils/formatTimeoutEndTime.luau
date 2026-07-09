local LocalizationService = game:GetService("LocalizationService")

local function formatTimeoutEndTime(s1: string?, s2: string?) -- line: 13
	-- upvalues: LocalizationService (copy)
	if not s1 or s1 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 18
		-- upvalues: s1 (copy)
		return DateTime.fromIsoDate(s1)
	end)

	if not ok or not result then
		return nil
	end

	return result:FormatLocalTime(s2 or "M/D, LT", LocalizationService.RobloxLocaleId)
end

return formatTimeoutEndTime
