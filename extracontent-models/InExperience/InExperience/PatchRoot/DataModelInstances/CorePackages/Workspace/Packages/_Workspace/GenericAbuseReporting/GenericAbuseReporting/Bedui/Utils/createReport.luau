local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local v4 = game:DefineFastFlag("UpdateAbuseReportRevampItemAbuseVector", false)
local FFlagFixNotificationReportsMobile = require(GenericAbuseReportingParent.SharedFlags).FFlagFixNotificationReportsMobile
local FFlagLuaAppEnableReportBadge = require(GenericAbuseReportingParent.SharedFlags).FFlagLuaAppEnableReportBadge
local FFlagEnableReportingFlowForDevSubs = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForDevSubs
local FFlagEnableReportingFlowForExperienceShop = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForExperienceShop

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: AbuseVector (copy), FFlagEnableReportingFlowForDevSubs (copy), FFlagEnableReportingFlowForExperienceShop (copy), FFlagFixNotificationReportsMobile (copy), FFlagLuaAppEnableReportBadge (copy), v4 (copy)
	local t2 = {}

	if t1.abuseVector == AbuseVector.Looks then
		local targetId = t1.targetId

		t2.REPORT_TARGET_LOOK_ID = targetId.lookId
		t2.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId.lookAssetsIds
	elseif t1.abuseVector == AbuseVector.UgcBundle then
		t2.UGC_BUNDLE_ID = t1.targetId
	elseif t1.abuseVector == AbuseVector.ContentPostScreenshot then
		t2.CONTENT_POST_ID = t1.targetId
	elseif t1.abuseVector == AbuseVector.UserProfile then
		t2.REPORT_TARGET_USER_ID = t1.targetId
	elseif t1.abuseVector == AbuseVector.Accessory then
		t2.REPORT_TARGET_ASSET_ID = t1.targetId
	elseif t1.abuseVector == AbuseVector.Place then
		t2.REPORT_TARGET_ASSET_ID = t1.targetId
	elseif FFlagEnableReportingFlowForDevSubs and t1.abuseVector == AbuseVector.Subscription then
		local targetId = t1.targetId

		t2.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId.subscriptionTargetKey
		t2.REPORT_TARGET_ASSET_ID = targetId.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.DeveloperProduct then
		t2.REPORT_TARGET_DEVELOPER_PRODUCT_ID = t1.targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.GamePass then
		t2.REPORT_TARGET_GAME_PASS_ID = t1.targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.InExperienceShop then
		t2.PLACE_ID = t1.targetId
	elseif t1.abuseVector == AbuseVector.Group then
		t2.REPORT_TARGET_GROUP_ID = t1.targetId
	elseif FFlagFixNotificationReportsMobile and t1.abuseVector == AbuseVector.Notifications then
		t2.NOTIFICATION_ID = t1.targetId
	elseif FFlagLuaAppEnableReportBadge and t1.abuseVector == AbuseVector.Badge then
		t2.REPORT_TARGET_BADGE_ID = t1.targetId
	end

	t2.ENTRY_POINT = "in-app"
	t2.SUBMITTER_USER_ID = t1.submitterId
	t2.REPORTED_ABUSE_CATEGORY = t1.abuseCategory
	t2.REPORTER_COMMENT = t1.comment or ""

	if v4 and t1.abuseVector == AbuseVector.Accessory then
		t2.REPORTED_ABUSE_VECTOR = t1.custom and t1.custom.assetTypeName or AbuseVector.Accessory

		if t2.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			t2.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory

			return t2
		end
	else
		t2.REPORTED_ABUSE_VECTOR = t1.abuseVector
	end

	return t2
end
