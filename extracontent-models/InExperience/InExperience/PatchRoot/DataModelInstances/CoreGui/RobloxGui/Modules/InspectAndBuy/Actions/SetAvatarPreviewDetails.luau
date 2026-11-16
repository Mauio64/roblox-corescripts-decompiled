local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

return makeActionCreator(script.Name, function(options)
	return {
		avatarPreviewDetails = options or {}
	}
end)
