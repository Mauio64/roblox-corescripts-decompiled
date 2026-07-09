local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetSearchTime = require(Modules.LuaApp.Actions.SetSearchTime)

return function(t1: {[any]: any}?, p1) -- line: 16
	-- upvalues: SetSearchTime (copy), Cryo (copy)
	local v7 = t1 or {}

	if p1.type == SetSearchTime.name then
		v7 = Cryo.Dictionary.join(v7, {
			[p1.searchUuid] = p1.searchTime
		})
	end

	return v7
end
