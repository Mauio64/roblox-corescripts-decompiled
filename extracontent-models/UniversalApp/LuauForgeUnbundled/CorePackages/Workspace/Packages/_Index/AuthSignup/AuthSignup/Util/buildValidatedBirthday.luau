local birthday = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon").Models.Birthday
local validateBirthday = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Util/validateBirthday")

local function buildValidatedBirthday(p2, p3, p4, p5)
	if p2 == nil or p3 == nil or p4 == nil then
		return nil
	end

	if validateBirthday(p2, p3, p4, p5) then
		return birthday.new({ Month = p2, Day = p3, Year = p4 })
	end

	return nil
end

return buildValidatedBirthday
