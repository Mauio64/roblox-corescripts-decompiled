local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Object = require(scriptParentParentParent.LuauPolyfill).Object
local SwitchRouter = require(scriptParent.SwitchRouter)
local BackBehavior = require(scriptParentParent.BackBehavior)

return function(p1, p2) -- line: 11
	-- upvalues: BackBehavior (copy), Object (copy), SwitchRouter (copy)
	local t1 = {
		resetOnBlur = false,
		backBehavior = BackBehavior.InitialRoute
	}

	if p2 then
		t1 = Object.assign(t1, p2)
	end

	return SwitchRouter(p1, t1)
end
