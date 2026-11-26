local Symbol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Symbols/Symbol")
local strict = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/strict")

local function createEnum(value, list)
	assert(typeof(value) == "string", "Bad argument #1, expected string")
	assert(typeof(list) == "table", "Bad argument #2, expected list of values")

	local nameds = {}

	for i, item in ipairs(list) do
		assert(item ~= "isMember", "Shadowing 'isMember' function is not allowed")
		assert(typeof(item) == "string", "Only string names are supported for enum types")

		local named = Symbol.named(item)
		local formatted = ("%s.%s"):format(value, item)
		getmetatable(named).__tostring = function()
			return formatted
		end

		nameds[item] = named
	end

	function nameds.isMember(p2): boolean
		if typeof(p2) ~= "userdata" then
			return false
		end

		for k, v5 in pairs(nameds) do
			if p2 == v5 then
				return true
			end
		end

		return false
	end

	getmetatable((newproxy(true))).__index = nameds

	return strict(nameds, value)
end

return createEnum
