local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return (Rodux.makeActionCreator(script.Name, function(p1) -- line: 19
	return {
		wearTimeFilter = p1
	}
end))
