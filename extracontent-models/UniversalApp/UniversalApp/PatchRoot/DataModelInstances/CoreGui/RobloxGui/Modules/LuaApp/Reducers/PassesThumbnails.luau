local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetPassesThumbnails = require(Modules.LuaApp.Actions.SetPassesThumbnails)

return function(p1, p2) -- line: 6
	-- upvalues: SetPassesThumbnails (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetPassesThumbnails.name then
		v7 = Cryo.Dictionary.join(v7, p2.passesThumbnails)
	end

	return v7
end
