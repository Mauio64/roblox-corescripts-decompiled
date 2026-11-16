require(script.Parent.Types)
local builders = require(script.Parent.builders)

local function createMomentScene(p, p2)
	local v = (p2 or builders)[p.type]

	if v == nil then
		error(`createMomentScene: unknown scene type '{p.type}'`)
	end

	return v(p.args)
end

return createMomentScene
