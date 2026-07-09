local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local LocalizationService = game:GetService("LocalizationService")
local DEFAULT_PADDING = require(ChallengeDialog.Common.Constants).DEFAULT_PADDING
local MAX_WIDTH = require(ChallengeDialog.Common.Constants).MAX_WIDTH

return {
	screenSizeSelector = function(p1) -- line: 7
		return p1.ScreenSize
	end,
	getMiddleContentWidth = function(n1: number) -- line: 11
		-- upvalues: MAX_WIDTH (copy), DEFAULT_PADDING (copy)
		return (n1 < MAX_WIDTH and n1 or MAX_WIDTH) - DEFAULT_PADDING * 2
	end,
	getAdjustedTitleToScreenString = function(s1: string, n2: number, p2) -- line: 19
		if s1 == nil then
			return s1
		end

		local v10 = math.floor(n2 / (p2.Font.Body.RelativeSize * p2.Font.BaseSize * 0.6) * 0.85)

		if v10 >= string.len(s1) then
			return s1
		end

		if s1:find(" ") == nil then
			return s1
		end

		local s2 = ""

		for i = 1, 2 do
			if not (v10 < string.len(s1)) then
				return s2 .. s1
			end

			local v13 = string.sub(s1, 1, v10)
			local v14 = v13:reverse():find(" ")

			if v14 ~= nil then
				local v15 = string.len(v13) - v14

				s1 = string.sub(s1, v15 + 2)
				s2 ..= string.sub(v13, 0, v15)
			else
				s2 ..= v13
				s1 = string.sub(s1, v10 + 1)
			end

			if i ~= 2 then
				s2 ..= "\n"
			end
		end

		return s2
	end,
	getFormattedDeviceType = function(s3: string?, s4: string?, p3) -- line: 90
		if s3 == "unknown" or s3 == nil then
			return p3.unknownDeviceType
		end

		if s4 == "unknown" or s4 == nil then
			return s3
		end

		return s3 .. " (" .. s4 .. ")"
	end,
	getFormattedRegionalLocation = function(s5: string?, s6: string?, s7: string?, p4) -- line: 99
		if (s5 == "unknown" or s5 == nil) and ((s6 == "unknown" or s6 == nil) and (s7 == "unknown" or s7 == nil)) then
			return p4.unknownLocation
		end

		if (s5 == "unknown" or s5 == nil) and (s6 == "unknown" or s6 == nil) then
			return s7
		end

		if (s6 == "unknown" or s6 == nil) and (s7 == "unknown" or s7 == nil) then
			return s5
		end

		if (s5 == "unknown" or s5 == nil) and (s7 == "unknown" or s7 == nil) then
			return s6
		end

		if s5 == "unknown" or s5 == nil then
			return p4.locationWithoutCity
		end

		if s6 == "unknown" or s6 == nil then
			return p4.locationWithoutSubdivision
		end

		if s7 == "unknown" or s7 == nil then
			return p4.locationWithoutCountry
		end

		return p4.location
	end,
	getFormattedIPAddress = function(s8: string?, p5) -- line: 123
		if s8 == "unknown" or s8 == nil then
			return p5.unknownIPAddress
		end

		return s8
	end,
	getFormattedDateTime = function(n3: number) -- line: 129
		-- upvalues: LocalizationService (copy)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		return DateTime.fromUnixTimestamp(n3):FormatLocalTime("lll", RobloxLocaleId)
	end
}
