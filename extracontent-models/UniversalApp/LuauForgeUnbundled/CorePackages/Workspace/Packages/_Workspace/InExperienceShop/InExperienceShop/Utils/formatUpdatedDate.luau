local LocalizationService = game:GetService("LocalizationService")

return {
	formatDate = function(p2, value)
		local dateTime = DateTime.fromIsoDate(p2)
		return dateTime and dateTime:FormatLocalTime(value or "ll", LocalizationService.RobloxLocaleId)
			or ""
	end,
	formatDuration = function(p2)
		if p2 <= 0 then
			return "00:00"
		end

		local v5 = math.floor(p2 / 3600)
		local v6 = math.floor(p2 % 3600 / 60)
		local v7 = p2 % 60

		local v8 = string.format("%02d", v5)
		local v9 = string.format("%02d", v6)
		local v10 = string.format("%02d", v7)

		if v5 > 0 then
			return v8 .. ":" .. v9 .. ":" .. v10
		end

		return v9 .. ":" .. v10
	end
}
