local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local FFlagLuaAppEnableSponsoredReportAd = require(GenericAbuseReportingParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppEnableReportBadge = require(GenericAbuseReportingParent.SharedFlags).FFlagLuaAppEnableReportBadge
local FFlagEnableReportingFlowForDevSubs = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForDevSubs
local FFlagEnableReportingFlowForExperienceShop = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForExperienceShop

local function v10(t1: {[any]: any}) -- line: 53
	-- upvalues: Dash (copy), AbuseVector (copy), FFlagEnableReportingFlowForDevSubs (copy), FFlagEnableReportingFlowForExperienceShop (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppEnableReportBadge (copy)
	local v13 = Dash.copy(t1.tags)
	local targetId = t1.targetId

	if t1.abuseVector == AbuseVector.Looks or t1.abuseVector == AbuseVector.CommunityLooks then
		local targetId2 = t1.targetId

		v13.REPORT_TARGET_LOOK_ID = targetId2.lookId
		v13.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId2.lookAssetsIds
	elseif t1.abuseVector == AbuseVector.UgcBundle then
		v13.UGC_BUNDLE_ID = targetId
	elseif t1.abuseVector == AbuseVector.ContentPostScreenshot then
		v13.CONTENT_POST_ID = targetId
	elseif t1.abuseVector == AbuseVector.UserProfile then
		v13.REPORT_TARGET_USER_ID = targetId
	elseif t1.abuseVector == AbuseVector.Accessory then
		v13.REPORT_TARGET_ASSET_ID = targetId
	elseif t1.abuseVector == AbuseVector.Place then
		v13.REPORT_TARGET_ASSET_ID = targetId
	elseif FFlagEnableReportingFlowForDevSubs and t1.abuseVector == AbuseVector.Subscription then
		local targetId3 = t1.targetId

		v13.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId3.subscriptionTargetKey
		v13.REPORT_TARGET_ASSET_ID = targetId3.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.DeveloperProduct then
		v13.REPORT_TARGET_DEVELOPER_PRODUCT_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.GamePass then
		v13.REPORT_TARGET_GAME_PASS_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t1.abuseVector == AbuseVector.InExperienceShop then
		v13.PLACE_ID = targetId
	elseif t1.abuseVector == AbuseVector.Group then
		v13.REPORT_TARGET_GROUP_ID = targetId
	elseif t1.abuseVector == AbuseVector.Notifications then
		v13.NOTIFICATION_ID = targetId
	elseif FFlagLuaAppEnableSponsoredReportAd and t1.abuseVector == AbuseVector.AdV2 then
		v13.AD_ID = targetId
	elseif FFlagLuaAppEnableReportBadge and t1.abuseVector == AbuseVector.Badge then
		v13.REPORT_TARGET_BADGE_ID = targetId
	end

	if t1.abuseVector == AbuseVector.Accessory then
		v13.REPORTED_ABUSE_VECTOR = t1.custom and t1.custom.assetTypeName or AbuseVector.Accessory

		if v13.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			v13.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory

			return v13
		end
	else
		v13.REPORTED_ABUSE_VECTOR = t1.abuseVector
	end

	return v13
end

return function(t2: {[any]: any}) -- line: 113
	-- upvalues: AbuseCategory (copy), v10 (copy), Dash (copy)
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
	local u20 = v10({
		abuseVector = t2.abuseVector,
		custom = t2.custom,
		targetId = t2.targetId,
		tags = t4
	})

	Dash.forEach(t2.additionalReportTags or {}, function(p1) -- line: 127
		-- upvalues: u20 (ref)
		if not p1.tagKey or (p1.tagKey == "" or not p1.tagValue or p1.tagValue == "") then
			return
		end

		if u20[p1.tagKey] ~= nil then
			local v22 = u20[p1.tagKey]

			u20[p1.tagKey] = v22 .. "," .. p1.tagValue

			return
		end

		u20[p1.tagKey] = p1.tagValue
	end)

	return u20
end
