local parent = script.Parent.Parent
local Symbol = require(parent.Symbols.Symbol)
local strict = require(parent.strict)

local function createEnum(value: string, list)
	assert(typeof(value) == "string", "Bad argument #1, expected string")
	assert(typeof(list) == "table", "Bad argument #2, expected list of values")

	local nameds = {}

	for _, item in ipairs(list) do
		assert(item ~= "isMember", "Shadowing 'isMember' function is not allowed")
		assert(typeof(item) == "string", "Only string names are supported for enum types")

		local named = Symbol.named(item)
		local formatted = ("%s.%s"):format(value, item)
		getmetatable(named).__tostring = function()
			return formatted
		end

		nameds[item] = named
	end

	function nameds.isMember(p): boolean
		if typeof(p) ~= "userdata" then
			return false
		end

		for _, v in pairs(nameds) do
			if p == v then
				return true
			end
		end

		return false
	end

	getmetatable((newproxy(true))).__index = nameds

	return strict(nameds, value)
end

return createEnum
