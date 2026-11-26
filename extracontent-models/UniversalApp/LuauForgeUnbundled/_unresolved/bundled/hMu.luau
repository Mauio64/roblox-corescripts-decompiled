local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday
local dateHelper = require("@luauforge/bundled/geM").DateHelper
local LinkStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")

local function invalidBirthday()
	return { birthday = nil, birthdayValid = LinkStatus.Invalid }
end

local function birthdayResult(data)
	if dateHelper:isValidDate(data.Month, data.Day, data.Year) then
		return { birthday = data, birthdayValid = LinkStatus.Valid }
	end

	return { birthday = nil, birthdayValid = LinkStatus.Invalid }
end

local function isValidAge(p2): boolean
	return p2 ~= nil and p2 >= 1 and p2 <= 99
end

return {
	buildBirthdayFromAge = function(p2, data)
		local v5 = not (p2 == nil or not (p2 >= 1)) and p2 <= 99

		if not v5 then
			return { birthday = nil, birthdayValid = LinkStatus.Invalid }
		end

		local v6 = birthday.new({
			Year = data.Year - p2,
			Month = data.Month,
			Day = data.Day
		})

		if v6.Month == 2 and v6.Day == 29 and not dateHelper:isLeapYear(v6.Year) then
			v6.Day = 28
		end

		if dateHelper:isValidDate(v6.Month, v6.Day, v6.Year) then
			return { birthday = v6, birthdayValid = LinkStatus.Valid }
		end

		return { birthday = nil, birthdayValid = LinkStatus.Invalid }
	end,
	buildBirthdayFromAgeMonth = function(p2, p3, p4)
		local v5 = not (p2 == nil or not (p2 >= 1)) and p2 <= 99

		if not v5 then
			return { birthday = nil, birthdayValid = LinkStatus.Invalid }
		end

		local v6 = p4.Year - p2
		local v7 = birthday.new({
			Year = v6,
			Month = p3,
			Day = dateHelper:getLastDayOfTheMonthInYear(p3, v6)
		})

		if dateHelper:isValidDate(v7.Month, v7.Day, v7.Year) then
			return { birthday = v7, birthdayValid = LinkStatus.Valid }
		end

		return { birthday = nil, birthdayValid = LinkStatus.Invalid }
	end,
	buildBirthdayFromMonthYear = function(p2, p3, p4)
		if p3 == nil or p3 < p4.Year - 100 or p4.Year < p3 then
			return { birthday = nil, birthdayValid = LinkStatus.Invalid }
		end

		local v5 = birthday.new({
			Year = p3,
			Month = p2,
			Day = dateHelper:getLastDayOfTheMonthInYear(p2, p3)
		})

		if dateHelper:isValidDate(v5.Month, v5.Day, v5.Year) then
			return { birthday = v5, birthdayValid = LinkStatus.Valid }
		end

		return { birthday = nil, birthdayValid = LinkStatus.Invalid }
	end
}
