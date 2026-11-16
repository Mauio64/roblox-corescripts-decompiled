local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object

local SwitchRouter = require(parent.SwitchRouter)
local BackBehavior = require(parent2.BackBehavior)

return function(p, p2)
	local v = { resetOnBlur = false, backBehavior = BackBehavior.InitialRoute }

	if p2 then
		v = Object.assign(v, p2)
	end

	return SwitchRouter(p, v)
end
