local defineFastFlag = game:DefineFastFlag("DebugLuaArgCheck", false)
local RunService = game:GetService("RunService")
local isStudio = RunService:IsStudio()

local v5 = {}

function v5.isEnabled()
	return defineFastFlag or _G.__TESTEZ_RUNNING_TEST__ or isStudio
end

local function assert_(p2, p3)
	if v5.isEnabled() then
		assert(p2, p3)
	end
end

local function stubArgCheckFunction(): boolean
	return true
end

function v5.wrap(p2)
	if v5.isEnabled() then
		return p2
	end

	return stubArgCheckFunction
end

function v5.isNonNegativeNumber(value, p2)
	local v6 = typeof(value) == "number" and value >= 0
	local v7 = string.format("expects %s to be a non-negative number!", p2)

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return value
end

function v5.isType(p2, p3, p4)
	local v6 = typeof(p2) == p3
	local v7 = string.format("expects %s to be a %s! it was: %s", p4, p3, (typeof(p2)))

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return p2
end

function v5.isInTypes(p2, list, p3)
	for i, item in ipairs(list) do
		if typeof(p2) == item then
			return p2
		end
	end

	local v6 = string.format("expects %s to be one of expectedTypes! it was: %s", p3, (typeof(p2)))

	if v5.isEnabled() then
		assert(false, v6)
	end

	return p2
end

function v5.isTypeOrNil(p2, p3, p4)
	local v6 = p2 == nil or typeof(p2) == p3
	local v7 = string.format("expects %s to be a %s! it was: %s", p4, p3, (typeof(p2)))

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return p2
end

function v5.isNotNil(p2, p3)
	local v6 = p2 ~= nil
	local v7 = string.format("expects %s to be not nil!", p3)

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return p2
end

function v5.isNonEmptyString(value, p2)
	local v6 = typeof(value) == "string" and value ~= ""
	local v7 = string.format("expects %s to be a non-empty string!", p2)

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return value
end

function v5.isEqual(p2, p3, p4)
	local v6 = p2 == p3
	local v7 = string.format("expects %s to equal %s! it was: %s", p4, tostring(p3), (tostring(p2)))

	if v5.isEnabled() then
		assert(v6, v7)
	end

	return p2
end

function v5.representsInteger(p2, p3)
	local v6 = tonumber(p2)
	local v7 = v6 ~= nil
	local v8 = string.format("expects %s to represent a number!", p3)

	if v5.isEnabled() then
		assert(v7, v8)
	end

	local v9 = v6 % 1 == 0
	local v10 = string.format("expects %s to represent an integer!", p3)

	if v5.isEnabled() then
		assert(v9, v10)
	end

	return p2
end

function v5.matchesInterface(list, value, p2, p3)
	if not v5.isEnabled() then
		return list
	end

	local v6 = { integer = v5.representsInteger, nonEmptyString = v5.isNonEmptyString }

	if type(value) == "string" then
		if p3 and p3[value] then
			v5.matchesInterface(list, p3[value], p2, p3)
			return list
		end

		local v7 = v6[value]

		if type(v7) == "function" then
			v7(list, p2)
			return list
		end

		v5.isType(list, value, p2)
		return list
	end

	v5.isType(list, "table", p2)

	if value[1] == nil then
		for k, v7 in pairs(value) do
			if string.sub(k, 1, 1) == "_" then
				continue
			end

			local v8 = p2 .. "." .. k
			local item = list[k]

			if value._required and value._required[k] or item ~= nil then
				v5.matchesInterface(item, v7, v8, p3)
			end
		end
	else
		for i, item in ipairs(list) do
			v5.matchesInterface(item, value[1], p2 .. "[" .. i .. "]", p3)
		end

		return list
	end

	return list
end

function v5.assert(...)
	local v6, v7 = ...

	if v5.isEnabled() then
		assert(v6, v7)
	end
end

return v5
