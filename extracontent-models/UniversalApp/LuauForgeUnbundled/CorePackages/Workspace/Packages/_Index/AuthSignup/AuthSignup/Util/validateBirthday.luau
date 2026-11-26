local birthday = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon").Models.Birthday
local dateHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Time").DateHelper

return function(p2, p3, p4, p5)
	local v5, v6 = dateHelper:isValidDate(p2, p3, p4)

	if birthday.new({ Month = p2, Day = p3, Year = p4 }):GetAgeInYears() < p5 then
		v5 = false
	end

	return v5
end
