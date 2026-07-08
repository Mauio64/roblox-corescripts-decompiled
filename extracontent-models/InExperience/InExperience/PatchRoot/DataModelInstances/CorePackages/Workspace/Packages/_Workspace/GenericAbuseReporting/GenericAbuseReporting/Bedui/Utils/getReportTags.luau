local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local FFlagFixNotificationReportsMobile = require(GenericAbuseReportingParent.SharedFlags).FFlagFixNotificationReportsMobile
local FFlagLuaAppEnableSponsoredReportAd = require(GenericAbuseReportingParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppEnableReportBadge = require(GenericAbuseReportingParent.SharedFlags).FFlagLuaAppEnableReportBadge
local FFlagEnableReportingFlowForDevSubs = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForDevSubs
local FFlagEnableReportingFlowForExperienceShop = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForExperienceShop

local function v11(t1: {[any]: any}) -- line: 55
	-- upvalues: Dash (copy), AbuseVector (copy), FFlagEnableReportingFlowForDevSubs (copy), FFlagEnableReportingFlowForExperienceShop (copy), FFlagFixNotificationReportsMobile (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppEnableReportBadge (copy)
	local v14 = Dash.copy(t1.tags)
	local targetId = t1.targetId

	if t1.abuseVector == AbuseVector.Looks or t1.abuseVector == AbuseVector.CommunityLooks then
		local targetId2 = t1.targetId

		v14.REPORT_TARGET_LOOK_ID = targetId2.lookId
		v14.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId2.lookAssetsIds
	elseif t1.abuseVector == AbuseVector.UgcBundle then
		v14.UGC_BUNDLE_ID = targetId
	elseif t1.abuseVector == AbuseVector.ContentPostScreenshot then
		v14.CONTENT_POST_ID = targetId
	elseif t1.abuseVector == AbuseVector.UserProfile then
		v14.REPORT_TARGET_USER_ID = targetId
	elseif t1.abuseVector == AbuseVector.Accessory then
		v14.REPORT_TARGET_ASSET_ID = targetId
	elseif t1.abuseVector == AbuseVector.Place then
		v14.REPORT_TARGET_ASSET_ID = targetId
	elseif FFlagEnableReportingFlowForDevSubs and t1.abuseVector == AbuseVector.Subscription then
		local targetId3 = t1.targetId

		v14.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId3.subscriptionTargetKey
		v14.REPORT_TARGET_ASSET_ID = targetId3.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.DeveloperProduct then
		v14.REPORT_TARGET_DEVELOPER_PRODUCT_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.GamePass then
		v14.REPORT_TARGET_GAME_PASS_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.InExperienceShop then
		v14.PLACE_ID = targetId
	elseif t1.abuseVector == AbuseVector.Group then
		v14.REPORT_TARGET_GROUP_ID = targetId
	elseif FFlagFixNotificationReportsMobile and t1.abuseVector == AbuseVector.Notifications then
		v14.NOTIFICATION_ID = targetId
	elseif FFlagLuaAppEnableSponsoredReportAd and t1.abuseVector == AbuseVector.AdV2 then
		v14.AD_ID = targetId
	elseif FFlagLuaAppEnableReportBadge and t1.abuseVector == AbuseVector.Badge then
		v14.REPORT_TARGET_BADGE_ID = targetId
	end

	if t1.abuseVector == AbuseVector.Accessory then
		v14.REPORTED_ABUSE_VECTOR = t1.custom and t1.custom.assetTypeName or AbuseVector.Accessory

		if v14.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			v14.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory

			return v14
		end
	else
		v14.REPORTED_ABUSE_VECTOR = t1.abuseVector
	end

	return v14
end

return function(t2: {[any]: any}) -- line: 115
	-- upvalues: AbuseCategory (copy), v11 (copy), Dash (copy)
	local t3 = {
		formData = t2.formData,
		localPlayerUserId = t2.localPlayerUserId
	}
	local t4 = {
		ENTRY_POINT = "in-app",
		SUBMITTER_USER_ID = t3.localPlayerUserId,
		REPORTED_ABUSE_CATEGORY = t3.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
		REPORTER_COMMENT = t3.formData.free_comment or ""
	}
	local u21 = v11({
		abuseVector = t2.abuseVector,
		custom = t2.custom,
		targetId = t2.targetId,
		tags = t4
	})

	Dash.forEach(t2.additionalReportTags or {}, function(p1) -- line: 129
		-- upvalues: u21 (ref)
		if not p1.tagKey or (p1.tagKey == "" or not p1.tagValue or p1.tagValue == "") then
			return
		end

		if u21[p1.tagKey] ~= nil then
			local v23 = u21[p1.tagKey]

			u21[p1.tagKey] = v23 .. "," .. p1.tagValue

			return
		end

		u21[p1.tagKey] = p1.tagValue
	end)

	return u21
end
