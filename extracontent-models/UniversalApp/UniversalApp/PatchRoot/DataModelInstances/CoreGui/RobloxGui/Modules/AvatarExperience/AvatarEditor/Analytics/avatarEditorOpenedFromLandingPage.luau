local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2) -- line: 4
	-- upvalues: Constants (copy)
	p1:sendTelemetryEvent(p2, "avatarEditorOpenedFromLandingPage", {
		feature = Constants.AnalyticsTag
	})
end
