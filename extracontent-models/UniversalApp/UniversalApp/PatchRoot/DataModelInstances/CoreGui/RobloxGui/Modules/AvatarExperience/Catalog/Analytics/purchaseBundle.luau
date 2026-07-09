local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 11
	-- upvalues: ArgCheck (copy), Constants (copy)
	ArgCheck.isType(p2, "string", "purchaseBundle event expects eventContext")
	ArgCheck.isType(p3, "string", "purchaseBundle event expects itemId")
	ArgCheck.isType(p4, "string", "purchaseBundle event expects itemSubType")
	ArgCheck.isTypeOrNil(p5, "number", "purchaseBundle event expects priceInRobux")
	ArgCheck.isTypeOrNil(p6, "boolean", "purchaseAsset event expects fromProfile")
	ArgCheck.isTypeOrNil(p7, "boolean", "purchaseAsset event expects fromContentFeed")

	local AnalyticsTag = Constants.AnalyticsTag

	if p6 then
		AnalyticsTag = Constants.ProfileAnalyticsTag
	elseif p7 then
		AnalyticsTag = Constants.ContentFeedAnalyticsTag
	end

	p1:sendTelemetryEvent(p2, p2, {
		feature = AnalyticsTag,
		itemID = p3,
		itemSubType = p4,
		priceInRobux = p5
	})
end
