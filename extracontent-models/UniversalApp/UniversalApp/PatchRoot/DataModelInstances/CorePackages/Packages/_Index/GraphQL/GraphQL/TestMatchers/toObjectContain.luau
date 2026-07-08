local ParentParent = script.Parent.Parent.Parent
local inspect = require(ParentParent.LuauPolyfill).util.inspect
local deepContains = require(script.Parent.Parent.luaUtils.deepContains)

local function toObjectContain(p1, p2) -- line: 20
	-- upvalues: deepContains (copy), inspect (copy)
	local v7 = deepContains(p1, p2)
	local s1 = ""

	if not v7 then
		s1 = "received tbl: " .. inspect(p2) .. " expected item to be in table: " .. inspect(p1)
	end

	return {
		pass = v7,
		message = s1
	}
end

return toObjectContain
