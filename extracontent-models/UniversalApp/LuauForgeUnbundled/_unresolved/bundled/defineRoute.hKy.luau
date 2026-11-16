require("@luauforge/bundled/hKp")

require("@luauforge/bundled/hKr")

local function defineRoute(p2, p3, p4)
	return table.freeze({ name = p2.name, content = p3, options = p4 })
end

return defineRoute
