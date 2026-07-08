local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local inspect = require(ParentParentParent.LuauPolyfill).util.inspect
local arrayContains = require(ParentParent.luaUtils.arrayContains)

local function toArrayContains(p1, p2, p3) -- line: 20
	-- upvalues: arrayContains (copy), inspect (copy)
	local v9 = arrayContains(p1, p2, p3)
	local s1 = ""

	if not v9 then
		s1 = "received tbl: " .. inspect(p2) .. " expected item to be in table: " .. inspect(p1)
	end

	return {
		pass = v9,
		message = s1
	}
end

return toArrayContains
