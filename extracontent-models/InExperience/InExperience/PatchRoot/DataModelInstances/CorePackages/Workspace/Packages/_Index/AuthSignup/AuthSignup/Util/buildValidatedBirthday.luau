local parent = script:FindFirstAncestor("AuthSignup").Parent

local AuthCommon = require(parent.AuthCommon)
local Birthday = AuthCommon.Models.Birthday
local validateBirthday = require(script.Parent.validateBirthday)

local function buildValidatedBirthday(month: number?, day: number?, year: number?, p: number)
	if month == nil or day == nil or year == nil then
		return nil
	end

	if validateBirthday(month, day, year, p) then
		return Birthday.new({ Month = month, Day = day, Year = year })
	end

	return nil
end

return buildValidatedBirthday
