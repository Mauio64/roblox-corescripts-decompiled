local parent = script.Parent.Parent
local Shared = require(parent.Shared)
local console = Shared.console

local set = {}

local function warnOnce(p: string, p2: string)
	if not set[p] then
		console.warn("The legacy Roact API '%s' is deprecated, and will be removed in a future release.\n\n%s", p, p2)
	end

	set[p] = true
end

return warnOnce
