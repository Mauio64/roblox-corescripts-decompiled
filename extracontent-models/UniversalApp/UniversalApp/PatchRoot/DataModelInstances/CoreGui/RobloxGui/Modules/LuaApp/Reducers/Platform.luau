local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetPlatform = require(Modules.LuaApp.Actions.SetPlatform)

return function(p1, p2) -- line: 6
	-- upvalues: SetPlatform (copy)
	local v5 = p1 or Enum.Platform.None

	assert(v5, "")

	if p2.type == SetPlatform.name then
		return p2.platform
	end

	return v5
end
