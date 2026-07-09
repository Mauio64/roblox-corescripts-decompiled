local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Birthday = require(CorePackages.Workspace.Packages.AuthCommon).Models.Birthday
local DateHelper = require(CorePackages.Workspace.Packages.Time).DateHelper
local InputValidity = require(Modules.LuaApp.Components.Authentication.Enum.InputValidity)

local function invalidBirthday() -- line: 19
	-- upvalues: InputValidity (copy)
	return {
		birthday = nil,
		birthdayValid = InputValidity.Invalid
	}
end
local function birthdayResult(p1) -- line: 26
	-- upvalues: DateHelper (copy), InputValidity (copy)
	if DateHelper:isValidDate(p1.Month, p1.Day, p1.Year) then
		return {
			birthday = p1,
			birthdayValid = InputValidity.Valid
		}
	end

	return {
		birthday = nil,
		birthdayValid = InputValidity.Invalid
	}
end
local function isValidAge(n1: number?) -- line: 37
	return n1 ~= nil and (n1 >= 1 and n1 <= 99)
end

return {
	buildBirthdayFromAge = function(n2: number?, t1: {[any]: any}) -- line: 41
		-- upvalues: InputValidity (copy), Birthday (copy), DateHelper (copy)
		if n2 == nil or (not (n2 >= 1) or not (n2 <= 99)) then
			return {
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			}
		end

		local v13 = Birthday.new({
			Year = t1.Year - n2,
			Month = t1.Month,
			Day = t1.Day
		})

		if v13.Month == 2 and v13.Day == 29 and not DateHelper:isLeapYear(v13.Year) then
			v13.Day = 28
		end

		if DateHelper:isValidDate(v13.Month, v13.Day, v13.Year) then
			return {
				birthday = v13,
				birthdayValid = InputValidity.Valid
			}
		end

		return {
			birthday = nil,
			birthdayValid = InputValidity.Invalid
		}
	end,
	buildBirthdayFromAgeMonth = function(n3: number?, n4: number, t2: {[any]: any}) -- line: 58
		-- upvalues: InputValidity (copy), Birthday (copy), DateHelper (copy)
		if n3 == nil or (not (n3 >= 1) or not (n3 <= 99)) then
			return {
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			}
		end

		local v17 = t2.Year - n3
		local v18 = Birthday.new({
			Year = v17,
			Month = n4,
			Day = DateHelper:getLastDayOfTheMonthInYear(n4, v17)
		})

		if DateHelper:isValidDate(v18.Month, v18.Day, v18.Year) then
			return {
				birthday = v18,
				birthdayValid = InputValidity.Valid
			}
		end

		return {
			birthday = nil,
			birthdayValid = InputValidity.Invalid
		}
	end,
	buildBirthdayFromMonthYear = function(n5: number, n6: number?, t3: {[any]: any}) -- line: 73
		-- upvalues: InputValidity (copy), Birthday (copy), DateHelper (copy)
		if n6 == nil or (n6 < t3.Year - 100 or n6 > t3.Year) then
			return {
				birthday = nil,
				birthdayValid = InputValidity.Invalid
			}
		end

		local v22 = Birthday.new({
			Year = n6,
			Month = n5,
			Day = DateHelper:getLastDayOfTheMonthInYear(n5, n6)
		})

		if DateHelper:isValidDate(v22.Month, v22.Day, v22.Year) then
			return {
				birthday = v22,
				birthdayValid = InputValidity.Valid
			}
		end

		return {
			birthday = nil,
			birthdayValid = InputValidity.Invalid
		}
	end
}
