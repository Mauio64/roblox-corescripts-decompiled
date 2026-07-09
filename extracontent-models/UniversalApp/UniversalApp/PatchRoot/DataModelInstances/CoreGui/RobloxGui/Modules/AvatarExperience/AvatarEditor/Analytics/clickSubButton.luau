local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function analyticsImpl(p1, s1: string, s2: string, s3: string, s4: string) -- line: 8
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(s1, "string", "clickSubButton event expects eventContext to be a string")
	ArgCheck.isType(s2, "string", "clickSubButton event expects categoryName to be a string")
	ArgCheck.isType(s3, "string", "clickSubButton event expects subCategoryName to be a string")
	ArgCheck.isType(s4, "string", "clickSubButton event expects subButtonName to be a string")
	p1:sendTelemetryEvent(s1, "avatarEditorSubButtonClick", {
		feature = Constants.AnalyticsTag,
		nav = s2,
		subNav = s3,
		subButton = s4
	})
end

return analyticsImpl
