local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function analyticsImpl(p1, p2, p3, p4) -- line: 9
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "clickShopForMore event expects eventContext to be a string")
	ArgCheck.isType(p3, "string", "clickShopForMore event expects categoryName to be a string")
	ArgCheck.isType(p4, "string", "clickShopForMore event expects subCategoryName to be a string")
	p1:sendTelemetryEvent(p2, "clickShopForMore", {
		feature = Constants.AnalyticsTag,
		nav = p3,
		subNav = p4
	})
end

return analyticsImpl
