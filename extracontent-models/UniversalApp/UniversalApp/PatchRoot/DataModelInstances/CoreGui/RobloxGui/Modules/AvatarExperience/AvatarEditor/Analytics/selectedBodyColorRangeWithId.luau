local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, s1: string, s2: string, s3: string) -- line: 10
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(s1, "string", "selectedBodyColorRangeWithId event expects userId to be a string")
	ArgCheck.isType(s2, "string", "selectedBodyColorRangeWithId event expects browserTrackerId to be a string")
	ArgCheck.isType(s3, "string", "selectedBodyColorRangeWithId event expects rangeId to be a string")
	p1:sendTelemetryEvent("avatarEditor", "selectedBodyColorRangeWithId", {
		feature = Constants.AnalyticsTag,
		uid = s1,
		btid = s2,
		rangeId = s3
	})
end
