local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3) -- line: 9
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "openedEmotesPage event expects userId to be a string")
	ArgCheck.isType(p3, "string", "openedEmotesPage event expects browserTrackerId to be a string")
	p1:sendTelemetryEvent("avatarEditor", "openedEmotesPage", {
		feature = Constants.AnalyticsTag,
		uid = p2,
		btid = p3
	})
end
