local LocalizationService = game:GetService("LocalizationService")

local DEFAULT_PADDING = require("@luauforge/bundled/dGz").DEFAULT_PADDING
local MAX_WIDTH = require("@luauforge/bundled/dGz").MAX_WIDTH

return {
	screenSizeSelector = function(p2)
		return p2.ScreenSize
	end,
	getMiddleContentWidth = function(p2)
		return (p2 < MAX_WIDTH and p2 or MAX_WIDTH) - 2 * DEFAULT_PADDING
	end,
	getAdjustedTitleToScreenString = function(value, p2, p3)
		if value == nil then
			return nil
		end

		local v5 = math.floor(0.85 * (p2 / (p3.Font.Body.RelativeSize * p3.Font.BaseSize * 0.6)))

		if string.len(value) <= v5 or value:find(" ") == nil then
			return value
		end

		local v6 = ""

		for i = 1, 2 do
			if not (v5 < string.len(value)) then
				return v6 .. value
			end

			local v7 = string.sub(value, 1, v5)
			local v8 = v7:reverse():find(" ")

			if v8 == nil then
				v6 ..= v7

				value = string.sub(value, v5 + 1)
			else
				local v9 = string.len(v7) - v8

				value = string.sub(value, v9 + 2)

				v6 ..= string.sub(v7, 0, v9)
			end

			if i ~= 2 then
				v6 ..= "\n"
			end
		end

		return v6
	end,
	getFormattedDeviceType = function(p2, p3, p4)
		if p2 == "unknown" or p2 == nil then
			return p4.unknownDeviceType
		end

		if p3 == "unknown" or p3 == nil then
			return p2
		end

		return p2 .. " (" .. p3 .. ")"
	end,
	getFormattedRegionalLocation = function(p2, p3, p4, data)
		if
			(p2 == "unknown" or p2 == nil)
			and (p3 == "unknown" or p3 == nil)
			and (p4 == "unknown" or p4 == nil)
		then
			return data.unknownLocation
		end

		if (p2 == "unknown" or p2 == nil) and (p3 == "unknown" or p3 == nil) then
			return p4
		end

		if (p3 == "unknown" or p3 == nil) and (p4 == "unknown" or p4 == nil) then
			return p2
		end

		if (p2 == "unknown" or p2 == nil) and (p4 == "unknown" or p4 == nil) then
			return p3
		end

		if p2 == "unknown" or p2 == nil then
			return data.locationWithoutCity
		end

		if p3 == "unknown" or p3 == nil then
			return data.locationWithoutSubdivision
		end

		if p4 == "unknown" or p4 == nil then
			return data.locationWithoutCountry
		end

		return data.location
	end,
	getFormattedIPAddress = function(p2, p3)
		if p2 == "unknown" or p2 == nil then
			return p3.unknownIPAddress
		end

		return p2
	end,
	getFormattedDateTime = function(p2)
		local robloxLocaleId = LocalizationService.RobloxLocaleId
		return DateTime.fromUnixTimestamp(p2):FormatLocalTime("lll", robloxLocaleId)
	end
}
