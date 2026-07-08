local LocalizationService = game:GetService("LocalizationService")

return {
	snakeToCamel = function(s1: string) -- line: 16
		return s1:gsub("_(%l)", function(p1) -- line: 17
			return p1:upper()
		end)
	end,
	protobufTimestampToLocalTimeString = function(t1: {[any]: any}?) -- line: 25
		-- upvalues: LocalizationService (copy)
		if t1 == nil then
			return nil
		end

		if t1.seconds then
			return DateTime.fromUnixTimestamp(t1.seconds):FormatLocalTime("ll", LocalizationService.RobloxLocaleId)
		end

		return (tostring(t1))
	end
}
