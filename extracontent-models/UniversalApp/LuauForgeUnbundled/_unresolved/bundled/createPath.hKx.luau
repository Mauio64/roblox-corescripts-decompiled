require("@luauforge/bundled/hKp")

local function createPath(p2)
	return table.freeze({ name = p2, [""] = nil })
end

return createPath
