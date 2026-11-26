require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

local defineFastFlag = game:DefineFastFlag("UpdateAbuseReportRevampItemAbuseVector", false)
local fFlagLuaAppEnableReportBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagLuaAppEnableReportBadge
local fFlagEnableReportingFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagEnableReportingFlowForDevSubs

local fFlagEnableReportingFlowForExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagEnableReportingFlowForExperienceShop

return function(data)
	local v5 = {}

	if data.abuseVector == AbuseVector.Looks then
		local targetId = data.targetId
		v5.REPORT_TARGET_LOOK_ID = targetId.lookId
		v5.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId.lookAssetsIds
	elseif data.abuseVector == AbuseVector.UgcBundle then
		v5.UGC_BUNDLE_ID = data.targetId
	elseif data.abuseVector == AbuseVector.ContentPostScreenshot then
		v5.CONTENT_POST_ID = data.targetId
	elseif data.abuseVector == AbuseVector.UserProfile then
		v5.REPORT_TARGET_USER_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Accessory then
		v5.REPORT_TARGET_ASSET_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Place then
		v5.REPORT_TARGET_ASSET_ID = data.targetId
	elseif fFlagEnableReportingFlowForDevSubs and data.abuseVector == AbuseVector.Subscription then
		local targetId = data.targetId
		v5.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId.subscriptionTargetKey
		v5.REPORT_TARGET_ASSET_ID = targetId.imageAssetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.DeveloperProduct then
		v5.REPORT_TARGET_DEVELOPER_PRODUCT_ID = data.targetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.GamePass then
		v5.REPORT_TARGET_GAME_PASS_ID = data.targetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.InExperienceShop then
		v5.PLACE_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Group then
		v5.REPORT_TARGET_GROUP_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Notifications then
		v5.NOTIFICATION_ID = data.targetId
	elseif fFlagLuaAppEnableReportBadge and data.abuseVector == AbuseVector.Badge then
		v5.REPORT_TARGET_BADGE_ID = data.targetId
	end

	v5.ENTRY_POINT = "in-app"
	v5.SUBMITTER_USER_ID = data.submitterId
	v5.REPORTED_ABUSE_CATEGORY = data.abuseCategory
	v5.REPORTER_COMMENT = data.comment or ""

	if defineFastFlag and data.abuseVector == AbuseVector.Accessory then
		v5.REPORTED_ABUSE_VECTOR = data.custom and data.custom.assetTypeName or AbuseVector.Accessory

		if v5.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			v5.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory
			return v5
		end
	else
		v5.REPORTED_ABUSE_VECTOR = data.abuseVector
	end

	return v5
end
