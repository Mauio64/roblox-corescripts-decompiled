local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2) -- line: 8
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "moreMenuToCatalogButton event expects eventContext")
	p1:sendTelemetryEvent(p2, "moreMenuToCatalogButton", {
		feature = Constants.AnalyticsTag
	})
end
