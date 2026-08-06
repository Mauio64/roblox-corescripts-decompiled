local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local ValueToAbuseCategory = require(GenericAbuseReporting.Enums.ValueToAbuseCategory)
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppEnableReportBadge = SharedFlags.FFlagLuaAppEnableReportBadge
local FFlagEnableReportingFlowForDevSubs = SharedFlags.FFlagEnableReportingFlowForDevSubs
local FFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
local FFlagGenericAbuseReportingUnifyReportTags = require(GenericAbuseReporting.Flags.FFlagGenericAbuseReportingUnifyReportTags)

local function v13(t1: {[any]: any}) -- line: 39
	-- upvalues: FFlagGenericAbuseReportingUnifyReportTags (copy), ValueToAbuseCategory (copy), AbuseCategory (copy)
	local t2 = {
		ENTRY_POINT = "in-app",
		SUBMITTER_USER_ID = t1.localPlayerUserId
	}

	if FFlagGenericAbuseReportingUnifyReportTags then
		t2.REPORTED_ABUSE_CATEGORY = ValueToAbuseCategory[t1.formData.legacy_abuse_category] or (t1.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID)
	else
		t2.REPORTED_ABUSE_CATEGORY = t1.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID
	end

	t2.REPORTER_COMMENT = t1.formData.free_comment or ""

	return t2
end
local function v14(t3: {[any]: any}) -- line: 62
	-- upvalues: Dash (copy), AbuseVector (copy), FFlagEnableReportingFlowForDevSubs (copy), FFlagEnableReportingFlowForExperienceShop (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppEnableReportBadge (copy)
	local v18 = Dash.copy(t3.tags)
	local targetId = t3.targetId

	if t3.abuseVector == AbuseVector.Looks or t3.abuseVector == AbuseVector.CommunityLooks then
		local targetId2 = t3.targetId

		v18.REPORT_TARGET_LOOK_ID = targetId2.lookId
		v18.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId2.lookAssetsIds
	elseif t3.abuseVector == AbuseVector.UgcBundle then
		v18.UGC_BUNDLE_ID = targetId
	elseif t3.abuseVector == AbuseVector.ContentPostScreenshot then
		v18.CONTENT_POST_ID = targetId
	elseif t3.abuseVector == AbuseVector.UserProfile then
		v18.REPORT_TARGET_USER_ID = targetId
	elseif t3.abuseVector == AbuseVector.Accessory then
		v18.REPORT_TARGET_ASSET_ID = targetId
	elseif t3.abuseVector == AbuseVector.Place then
		v18.REPORT_TARGET_ASSET_ID = targetId
	elseif FFlagEnableReportingFlowForDevSubs and t3.abuseVector == AbuseVector.Subscription then
		local targetId3 = t3.targetId

		v18.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId3.subscriptionTargetKey
		v18.REPORT_TARGET_ASSET_ID = targetId3.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and t3.abuseVector == AbuseVector.DeveloperProduct then
		v18.REPORT_TARGET_DEVELOPER_PRODUCT_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t3.abuseVector == AbuseVector.GamePass then
		v18.REPORT_TARGET_GAME_PASS_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and t3.abuseVector == AbuseVector.InExperienceShop then
		v18.PLACE_ID = targetId
	elseif t3.abuseVector == AbuseVector.Group then
		v18.REPORT_TARGET_GROUP_ID = targetId
	elseif t3.abuseVector == AbuseVector.Notifications then
		v18.NOTIFICATION_ID = targetId
	elseif FFlagLuaAppEnableSponsoredReportAd and t3.abuseVector == AbuseVector.AdV2 then
		v18.AD_ID = targetId
	elseif FFlagLuaAppEnableReportBadge and t3.abuseVector == AbuseVector.Badge then
		v18.REPORT_TARGET_BADGE_ID = targetId
	end

	if t3.abuseVector == AbuseVector.Accessory then
		v18.REPORTED_ABUSE_VECTOR = t3.custom and t3.custom.assetTypeName or AbuseVector.Accessory

		if v18.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			v18.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory

			return v18
		end
	else
		v18.REPORTED_ABUSE_VECTOR = t3.abuseVector
	end

	return v18
end

return function(t4: {[any]: any}) -- line: 122
	-- upvalues: v13 (copy), v14 (copy), Dash (copy)
	local v23 = v13({
		formData = t4.formData,
		localPlayerUserId = t4.localPlayerUserId
	})
	local u24 = v14({
		abuseVector = t4.abuseVector,
		custom = t4.custom,
		targetId = t4.targetId,
		tags = v23
	})

	Dash.forEach(t4.additionalReportTags or {}, function(p1) -- line: 136
		-- upvalues: u24 (ref)
		if not p1.tagKey or (p1.tagKey == "" or not p1.tagValue or p1.tagValue == "") then
			return
		end

		if u24[p1.tagKey] ~= nil then
			local v26 = u24[p1.tagKey]

			u24[p1.tagKey] = v26 .. "," .. p1.tagValue

			return
		end

		u24[p1.tagKey] = p1.tagValue
	end)

	return u24
end
