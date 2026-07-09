local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3, p4) -- line: 10
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p3, "string", "expandItemDetailPage event expects itemId")
	ArgCheck.isType(p4, "string", "expandItemDetailPage event expects itemType")
	p1:sendTelemetryEvent(p2, "swipeUpItemDetailPage", {
		feature = Constants.AnalyticsTag,
		itemID = p3,
		itemType = p4
	})
end
