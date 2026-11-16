local defineFastFlag = game:DefineFastFlag("DebugLuaArgCheck", false)
local RunService = game:GetService("RunService")
local isStudio = RunService:IsStudio()

local ArgCheck = {}

function ArgCheck.isEnabled()
	return defineFastFlag or _G.__TESTEZ_RUNNING_TEST__ or isStudio
end

local function assert_(p, p2) -- 10 equivalent calls inferred from this helper
	if ArgCheck.isEnabled() then
		assert(p, p2)
	end
end

local function stubArgCheckFunction(): boolean
	return true
end

function ArgCheck.wrap(p)
	return if ArgCheck.isEnabled() then p else stubArgCheckFunction
end

function ArgCheck.isNonNegativeNumber(value, p)
	assert_(typeof(value) == "number" and value >= 0, string.format("expects %s to be a non-negative number!", p)) -- inferred equivalent call

	return value
end

function ArgCheck.isType(p, p2, p3)
	assert_(typeof(p) == p2, string.format("expects %s to be a %s! it was: %s", p3, p2, (typeof(p)))) -- inferred equivalent call

	return p
end

function ArgCheck.isInTypes(p, list, p2)
	for _, item in ipairs(list) do
		if typeof(p) == item then
			return p
		end
	end

	assert_(false, string.format("expects %s to be one of expectedTypes! it was: %s", p2, (typeof(p)))) -- inferred equivalent call

	return p
end

function ArgCheck.isTypeOrNil(p, p2, p3)
	assert_(p == nil or typeof(p) == p2, string.format("expects %s to be a %s! it was: %s", p3, p2, (typeof(p)))) -- inferred equivalent call

	return p
end

function ArgCheck.isNotNil(p, p2)
	assert_(p ~= nil, string.format("expects %s to be not nil!", p2)) -- inferred equivalent call

	return p
end

function ArgCheck.isNonEmptyString(value, p)
	assert_(typeof(value) == "string" and value ~= "", string.format("expects %s to be a non-empty string!", p)) -- inferred equivalent call

	return value
end

function ArgCheck.isEqual(p, p2, p3)
	assert_(p == p2, string.format("expects %s to equal %s! it was: %s", p3, tostring(p2), (tostring(p)))) -- inferred equivalent call

	return p
end

function ArgCheck.representsInteger(p, p2)
	local v = tonumber(p)
	assert_(v ~= nil, string.format("expects %s to represent a number!", p2)) -- inferred equivalent call
	assert_(v % 1 == 0, string.format("expects %s to represent an integer!", p2)) -- inferred equivalent call

	return p
end

function ArgCheck.matchesInterface(list, value, p, p2)
	if not ArgCheck.isEnabled() then
		return list
	end

	local v = { integer = ArgCheck.representsInteger, nonEmptyString = ArgCheck.isNonEmptyString }

	if type(value) == "string" then
		if p2 and p2[value] then
			ArgCheck.matchesInterface(list, p2[value], p, p2)
			return list
		end

		local v2 = v[value]

		if type(v2) == "function" then
			v2(list, p)
			return list
		end

		ArgCheck.isType(list, value, p)
		return list
	end

	ArgCheck.isType(list, "table", p)

	if value[1] == nil then
		for k, v2 in pairs(value) do
			if string.sub(k, 1, 1) == "_" then
				continue
			end

			local v3 = p .. "." .. k
			local item = list[k]

			if value._required and value._required[k] or item ~= nil then
				ArgCheck.matchesInterface(item, v2, v3, p2)
			end
		end
	else
		for i, item in ipairs(list) do
			ArgCheck.matchesInterface(item, value[1], p .. "[" .. i .. "]", p2)
		end

		return list
	end

	return list
end

function ArgCheck.assert(...)
	assert_(...) -- inferred equivalent call
end

return ArgCheck
