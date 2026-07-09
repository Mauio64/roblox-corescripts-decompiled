local LocalizationService = game:GetService("LocalizationService")

return {
	formatDate = function(s1: string, s2: string?) -- line: 26
		-- upvalues: LocalizationService (copy)
		local dateTime = DateTime.fromIsoDate(s1)

		return dateTime and dateTime:FormatLocalTime(s2 or "ll", LocalizationService.RobloxLocaleId) or ""
	end,
	formatDuration = function(n1: number) -- line: 3
		if n1 <= 0 then
			return "00:00"
		end

		local v3 = math.floor(n1 / 3600)
		local v4 = math.floor(n1 % 3600 / 60)
		local v5 = n1 % 60
		local v6 = string.format("%02d", v3)
		local v7 = string.format("%02d", v4)
		local v8 = string.format("%02d", v5)

		if v3 > 0 then
			return v6 .. ":" .. v7 .. ":" .. v8
		end

		return v7 .. ":" .. v8
	end
}
