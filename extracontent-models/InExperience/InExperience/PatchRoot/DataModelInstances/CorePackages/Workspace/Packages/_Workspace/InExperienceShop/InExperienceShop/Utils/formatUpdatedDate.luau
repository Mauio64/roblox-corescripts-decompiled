local LocalizationService = game:GetService("LocalizationService")

local function formatUpdatedDate(s1: string?) -- line: 12
	-- upvalues: LocalizationService (copy)
	if s1 == nil or s1 == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s1)

	if dateTime == nil then
		return s1
	end

	return dateTime:FormatLocalTime("ll", LocalizationService.RobloxLocaleId)
end

return formatUpdatedDate
