local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local map = LuauPolyfill.Map.new(nil)
local v = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z"
}

math.randomseed(os.clock())

local function uuid()
	local v2 = ""

	for _ = 1, 11 do
		v2 ..= v[math.random(1, 36)]
	end

	return v2
end

return {
	["uuid"] = uuid,
	makeUniqueId = function(p: string)
		local v2 = uuid()
		local v3 = Boolean.toJSBoolean(map:get(p)) and map:get(p) or 1
		map:set(p, v3 + 1)
		return ("%s:%s:%s"):format(p, tostring(v3), v2)
	end
}
