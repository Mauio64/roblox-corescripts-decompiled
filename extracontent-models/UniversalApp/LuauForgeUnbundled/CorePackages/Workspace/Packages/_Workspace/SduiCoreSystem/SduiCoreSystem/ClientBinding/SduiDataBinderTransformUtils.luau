local LocalizationService = game:GetService("LocalizationService")

return {
	snakeToCamel = function(value)
		return value:gsub("_(%l)", function(value2)
			return value2:upper()
		end)
	end,
	protobufTimestampToLocalTimeString = function(p2)
		if p2 == nil then
			return nil
		end

		if p2.seconds then
			return DateTime.fromUnixTimestamp(p2.seconds):FormatLocalTime(
				"ll",
				LocalizationService.RobloxLocaleId
			)
		end

		return (tostring(p2))
	end
}
