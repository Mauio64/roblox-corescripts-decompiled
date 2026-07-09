local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 13
	-- upvalues: ArgCheck (copy), Constants (copy), RbxAnalyticsService (copy)
	ArgCheck.isType(p2, "string", "purchaseAsset event expects eventContext")
	ArgCheck.isType(p3, "string", "purchaseAsset event expects itemId")
	ArgCheck.isType(p4, "string", "purchaseAsset event expects itemSubType")
	ArgCheck.isTypeOrNil(p5, "number", "purchaseAsset event expects priceInRobux")
	ArgCheck.isTypeOrNil(p6, "boolean", "purchaseAsset event expects fromProfile")
	ArgCheck.isTypeOrNil(p8, "boolean", "purchaseAsset event expects fromContentFeed")

	local AnalyticsTag = Constants.AnalyticsTag

	if p6 then
		AnalyticsTag = Constants.ProfileAnalyticsTag
	elseif p8 then
		AnalyticsTag = Constants.ContentFeedAnalyticsTag
	end

	p1:sendTelemetryEvent(p2, p2, {
		feature = AnalyticsTag,
		itemID = p3,
		itemSubType = p4,
		priceInRobux = p5
	})

	if p7 then
		p1:sendTelemetryEvent(p2, "purchaseAssetHasAccessoryAdjustment", {
			feature = AnalyticsTag,
			itemID = p3,
			itemSubType = p4,
			priceInRobux = p5,
			refineSessionId = RbxAnalyticsService:GetSessionId()
		})
	end
end
