local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)

local defineFastFlag = game:DefineFastFlag("UpdateAbuseReportRevampItemAbuseVector", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableReportBadge = SharedFlags.FFlagLuaAppEnableReportBadge
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableReportingFlowForDevSubs = SharedFlags2.FFlagEnableReportingFlowForDevSubs

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableReportingFlowForExperienceShop = SharedFlags3.FFlagEnableReportingFlowForExperienceShop

return function(data)
	local v = {}

	if data.abuseVector == AbuseVector.Looks then
		local targetId = data.targetId
		v.REPORT_TARGET_LOOK_ID = targetId.lookId
		v.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId.lookAssetsIds
	elseif data.abuseVector == AbuseVector.UgcBundle then
		v.UGC_BUNDLE_ID = data.targetId
	elseif data.abuseVector == AbuseVector.ContentPostScreenshot then
		v.CONTENT_POST_ID = data.targetId
	elseif data.abuseVector == AbuseVector.UserProfile then
		v.REPORT_TARGET_USER_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Accessory then
		v.REPORT_TARGET_ASSET_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Place then
		v.REPORT_TARGET_ASSET_ID = data.targetId
	elseif FFlagEnableReportingFlowForDevSubs and data.abuseVector == AbuseVector.Subscription then
		local targetId = data.targetId
		v.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId.subscriptionTargetKey
		v.REPORT_TARGET_ASSET_ID = targetId.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.DeveloperProduct then
		v.REPORT_TARGET_DEVELOPER_PRODUCT_ID = data.targetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.GamePass then
		v.REPORT_TARGET_GAME_PASS_ID = data.targetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.InExperienceShop then
		v.PLACE_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Group then
		v.REPORT_TARGET_GROUP_ID = data.targetId
	elseif data.abuseVector == AbuseVector.Notifications then
		v.NOTIFICATION_ID = data.targetId
	elseif FFlagLuaAppEnableReportBadge and data.abuseVector == AbuseVector.Badge then
		v.REPORT_TARGET_BADGE_ID = data.targetId
	end

	v.ENTRY_POINT = "in-app"
	v.SUBMITTER_USER_ID = data.submitterId
	v.REPORTED_ABUSE_CATEGORY = data.abuseCategory
	v.REPORTER_COMMENT = data.comment or ""

	if defineFastFlag and data.abuseVector == AbuseVector.Accessory then
		v.REPORTED_ABUSE_VECTOR = data.custom and data.custom.assetTypeName or AbuseVector.Accessory

		if v.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			v.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory
			return v
		end
	else
		v.REPORTED_ABUSE_VECTOR = data.abuseVector
	end

	return v
end
