local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)

return function(t1: {[any]: any}?, p1) -- line: 15
	-- upvalues: SetSearchParameters (copy), Immutable (copy)
	local v6 = t1 or {}

	assert(v6, "")

	if p1.type == SetSearchParameters.name then
		v6 = Immutable.Set(v6, p1.searchUuid, p1.parameters)
	end

	return v6
end
