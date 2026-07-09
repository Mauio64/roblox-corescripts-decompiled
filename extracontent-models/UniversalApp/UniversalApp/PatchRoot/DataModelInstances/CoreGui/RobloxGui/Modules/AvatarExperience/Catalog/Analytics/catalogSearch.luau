local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 17
	-- upvalues: ArgCheck (copy), HttpService (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "catalogSearch event expects eventContext")
	ArgCheck.isType(p3, "string", "catalogSearch event expects keyword")
	ArgCheck.isType(p4, "table", "catalogSearch event expects assetsReturned")
	ArgCheck.isType(p5, "number", "catalogSearch event expects pageNumber")
	ArgCheck.isTypeOrNil(p6, "string", "catalogSearch event expects sortType")
	ArgCheck.isTypeOrNil(p7, "table", "catalogSearch event expects filters")

	local v13 = table.concat(p4, ",")
	local v14 = p7 and HttpService:JSONEncode(p7)

	p1:sendTelemetryEvent(p2, "catalogSearch", {
		feature = Constants.AnalyticsTag,
		keyword = p3,
		page = p5,
		sort = p6,
		filters = v14,
		assetsReturned = v13
	})
end
