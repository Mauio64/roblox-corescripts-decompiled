local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local v5 = LuauPolyfill.Map.new(nil)
local t2 = {
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

local function uuid() -- line: 59
	-- upvalues: t2 (copy)
	local s1 = ""

	for _ = 1, 11 do
		s1 ..= t2[math.random(1, 36)]
	end

	return s1
end

t1.uuid = uuid

function t1.makeUniqueId(s2: string) -- line: 68
	-- upvalues: uuid (copy), Boolean (copy), v5 (copy)
	local v11 = uuid()
	local v12 = Boolean.toJSBoolean(v5:get(s2)) and v5:get(s2) or 1

	v5:set(s2, v12 + 1)

	return ("%s:%s:%s"):format(s2, tostring(v12), v11)
end

return t1
