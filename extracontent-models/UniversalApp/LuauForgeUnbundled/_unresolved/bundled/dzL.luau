local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("RefreshSiteAlertInfo", function(options)
	return Cryo.Dictionary.join({ updateRequested = true }, options or {})
end)
