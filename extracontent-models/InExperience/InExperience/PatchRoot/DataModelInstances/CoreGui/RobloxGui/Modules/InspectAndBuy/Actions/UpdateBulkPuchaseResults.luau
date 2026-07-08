local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

return makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		result = p1 or {}
	}
end)
