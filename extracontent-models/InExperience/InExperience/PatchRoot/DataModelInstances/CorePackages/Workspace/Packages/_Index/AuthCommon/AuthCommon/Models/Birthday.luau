local Parent = script:FindFirstAncestor("AuthCommon").Parent
local ArgCheck = require(Parent.ArgCheck)
local DateTime = require(Parent.Time).DateTime
local t1 = {}
local t2 = {}

t1[t2] = true

function t1.new(p1) -- line: 20
	-- upvalues: ArgCheck (copy), t1 (copy)
	local t3 = {
		Month = 1,
		Day = 1,
		Year = 1970
	}

	if p1 then
		t3.Month = p1.Month or t3.Month
		t3.Day = p1.Day or t3.Day
		t3.Year = p1.Year or t3.Year
		ArgCheck.isNonNegativeNumber(t3.Month, "month in Birthday constructor")
		ArgCheck.isNonNegativeNumber(t3.Day, "day in Birthday constructor")
		ArgCheck.isNonNegativeNumber(t3.Year, "year in Birthday constructor")
	end

	setmetatable(t3, t1)

	return t3
end
function t1.IsUnder13(p2) -- line: 41
	-- upvalues: t1 (copy), DateTime (copy)
	local v9 = t1.new(DateTime.now():GetValues())

	if v9.Year - 13 < p2.Year then
		return true
	end

	if v9.Year - 13 > p2.Year then
		return false
	end

	return v9.Month < p2.Month or v9.Month == p2.Month and v9.Day < p2.Day
end
function t1.GetAgeInYears(p3, p4) -- line: 52
	-- upvalues: DateTime (copy), t1 (copy)
	local v12 = p4 or DateTime.now():GetValues()
	local v13 = t1.new(v12)

	if v13.Month < p3.Month or v13.Month == p3.Month and v13.Day < p3.Day then
		return v13.Year - p3.Year - 1
	end

	return v13.Year - p3.Year
end
function t1.FormatForEndpoint(p5) -- line: 63
	return p5.Year .. "-" .. p5.Month .. "-" .. p5.Day .. "T12:00:00.000Z"
end
function t1.ToString(p6, p7) -- line: 67
	local v17 = p7 or " "

	return p6.Month .. v17 .. p6.Day .. v17 .. p6.Year
end
function t1.is(p8) -- line: 73
	-- upvalues: t2 (copy)
	if type(p8) ~= "table" then
		return false
	end

	return p8[t2] == true
end

t1.__index = t1

return t1
