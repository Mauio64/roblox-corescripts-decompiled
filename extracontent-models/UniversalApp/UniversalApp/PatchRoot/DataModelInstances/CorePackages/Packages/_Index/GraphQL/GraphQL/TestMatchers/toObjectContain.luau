local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local deepContains = require(script.Parent.Parent.luaUtils.deepContains)

local function toObjectContain(p, p2)
	local pass = deepContains(p, p2)

	return {
		pass = pass,
		message = pass and "" or "received tbl: " .. inspect(p2) .. " expected item to be in table: " .. inspect(p)
	}
end

return toObjectContain
