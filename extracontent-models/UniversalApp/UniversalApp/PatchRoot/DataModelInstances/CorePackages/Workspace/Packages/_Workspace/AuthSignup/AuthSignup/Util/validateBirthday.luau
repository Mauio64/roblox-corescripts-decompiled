local Parent = script:FindFirstAncestor("AuthSignup").Parent
local Birthday = require(Parent.AuthCommon).Models.Birthday
local DateHelper = require(Parent.Time).DateHelper

return function(p1, p2, p3, p4) -- line: 8
	-- upvalues: DateHelper (copy), Birthday (copy)
	local v8, _ = DateHelper:isValidDate(p1, p2, p3)

	if p4 > Birthday.new({
		Month = p1,
		Day = p2,
		Year = p3
	}):GetAgeInYears() then
		v8 = false
	end

	return v8
end
