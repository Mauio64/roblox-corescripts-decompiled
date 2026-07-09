local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetDeveloperProductsThumbnails = require(Modules.LuaApp.Actions.DeveloperProduct.SetDeveloperProductsThumbnails)

return function(p1, p2) -- line: 6
	-- upvalues: SetDeveloperProductsThumbnails (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetDeveloperProductsThumbnails.name then
		v7 = Cryo.Dictionary.join(v7, p2.developerProductsThumbnails)
	end

	return v7
end
