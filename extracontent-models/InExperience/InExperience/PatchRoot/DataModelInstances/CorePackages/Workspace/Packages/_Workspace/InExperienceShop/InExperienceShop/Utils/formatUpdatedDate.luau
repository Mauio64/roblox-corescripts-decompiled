local LocalizationService = game:GetService("LocalizationService")

local function formatUpdatedDate(p: string?)
	if p == nil or p == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(p)

	if dateTime == nil then
		return p
	end

	return dateTime:FormatLocalTime("ll", LocalizationService.RobloxLocaleId)
end

return formatUpdatedDate
