require("@luauforge/bundled/hUX")

local function createPath(p2)
	return table.freeze({ name = p2, [""] = nil })
end

return createPath
