local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2) -- line: 7
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "clickNavigationTab event expects eventContext")
	p1:sendTelemetryEvent(p2, "catalogNavButtonClick", {
		feature = Constants.AnalyticsTag
	})
end
