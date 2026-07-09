local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3, p4, p5) -- line: 11
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "equippedEmote event expects userId to be a string")
	ArgCheck.isType(p3, "string", "equippedEmote event expects browserTrackerId to be a string")
	ArgCheck.isType(p4, "string", "equippedEmote event expects assetId to be a string")
	ArgCheck.isType(p5, "number", "equippedEmote event expects slot to be a string")
	p1:sendTelemetryEvent("avatarEditor", "equippedEmote", {
		feature = Constants.AnalyticsTag,
		uid = p2,
		btid = p3,
		slot = p5,
		assetID = p4
	})
end
