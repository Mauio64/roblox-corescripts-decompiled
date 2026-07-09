local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetIsLocalUserSoothsayer = require(Modules.LuaApp.Actions.SetIsLocalUserSoothsayer)

return function(b1: boolean?, p1) -- line: 4
	-- upvalues: SetIsLocalUserSoothsayer (copy)
	local v5 = b1 or false

	if p1.type == SetIsLocalUserSoothsayer.name then
		return p1.isSoothsayer
	end

	return v5
end
