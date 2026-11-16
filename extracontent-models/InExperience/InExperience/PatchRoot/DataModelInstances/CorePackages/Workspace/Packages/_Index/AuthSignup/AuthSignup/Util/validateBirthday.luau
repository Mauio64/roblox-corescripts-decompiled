local parent = script:FindFirstAncestor("AuthSignup").Parent

local AuthCommon = require(parent.AuthCommon)
local Birthday = AuthCommon.Models.Birthday
local Time = require(parent.Time)
local DateHelper = Time.DateHelper

return function(month, day, year, p)
	local v, _ = DateHelper:isValidDate(month, day, year)
	return not (Birthday.new({ Month = month, Day = day, Year = year }):GetAgeInYears() < p) and v
end
