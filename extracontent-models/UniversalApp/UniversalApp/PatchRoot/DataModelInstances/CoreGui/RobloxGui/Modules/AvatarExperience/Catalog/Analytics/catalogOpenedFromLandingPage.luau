local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2) -- line: 6
	-- upvalues: Constants (copy)
	p1:sendTelemetryEvent(p2, "catalogOpenedFromLandingPage", {
		feature = Constants.AnalyticsTag
	})
end
