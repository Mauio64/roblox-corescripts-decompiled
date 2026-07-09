local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetGlobalContextMenuInset = require(Modules.LuaApp.Actions.SetGlobalContextMenuInset)

return function(t1: {[any]: any}?, p1) -- line: 11
	-- upvalues: SetGlobalContextMenuInset (copy)
	local v5 = t1 or {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	}

	assert(v5, "")

	if p1.type == SetGlobalContextMenuInset.name then
		return {
			left = p1.left,
			top = p1.top,
			right = p1.right,
			bottom = p1.bottom
		}
	end

	return v5
end
