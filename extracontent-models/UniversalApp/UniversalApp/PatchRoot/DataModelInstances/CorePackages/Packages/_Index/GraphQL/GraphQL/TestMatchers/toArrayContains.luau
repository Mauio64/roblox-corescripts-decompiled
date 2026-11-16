local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local arrayContains = require(parent.luaUtils.arrayContains)

local function toArrayContains(p, p2, p3)
	local pass = arrayContains(p, p2, p3)

	return {
		pass = pass,
		message = pass and "" or "received tbl: " .. inspect(p2) .. " expected item to be in table: " .. inspect(p)
	}
end

return toArrayContains
