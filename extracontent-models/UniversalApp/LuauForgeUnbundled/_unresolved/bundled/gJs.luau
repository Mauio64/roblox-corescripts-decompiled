local module = require("@luauforge/bundled/gJt")
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.state")

return function(p2, p3)
	if p3 == nil then
		p3 = logger.active[logger.Levels.Trace]
	end

	if not p3 then
		return function(p4, p5, p6) end
	end

	local v5 = nil

	return function(p4, p5, p6)
		local v6 = module(p5)

		print(string.format("[%s] action: %s\n%s", p2, tostring(p6.type), v6 == v5 and "" or v6))

		v5 = v6
	end
end
