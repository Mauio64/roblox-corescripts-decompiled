local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local AbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseCategory")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local ValueToAbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/ValueToAbuseCategory")

local fFlagLuaAppEnableReportBadge = SharedFlags.FFlagLuaAppEnableReportBadge
local fFlagEnableReportingFlowForDevSubs = SharedFlags.FFlagEnableReportingFlowForDevSubs
local fFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
local FFlagGenericAbuseReportingUnifyReportTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagGenericAbuseReportingUnifyReportTags")

local function fn(p2)
	local v5 = {}
	v5.ENTRY_POINT = "in-app"
	v5.SUBMITTER_USER_ID = p2.localPlayerUserId

	if FFlagGenericAbuseReportingUnifyReportTags then
		v5.REPORTED_ABUSE_CATEGORY = ValueToAbuseCategory[p2.formData.legacy_abuse_category]
			or p2.formData.abuse_category
			or AbuseCategory.ABUSE_CATEGORY_INVALID
	else
		v5.REPORTED_ABUSE_CATEGORY = p2.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID
	end

	v5.REPORTER_COMMENT = p2.formData.free_comment or ""

	return v5
end

local function fn2(data)
	local copy = Dash.copy(data.tags)

	local targetId = data.targetId

	if data.abuseVector == AbuseVector.Looks or data.abuseVector == AbuseVector.CommunityLooks then
		local targetId2 = data.targetId
		copy.REPORT_TARGET_LOOK_ID = targetId2.lookId
		copy.REPORT_TARGET_LOOK_INCLUDED_ASSET_IDS = targetId2.lookAssetsIds
	elseif data.abuseVector == AbuseVector.UgcBundle then
		copy.UGC_BUNDLE_ID = targetId
	elseif data.abuseVector == AbuseVector.ContentPostScreenshot then
		copy.CONTENT_POST_ID = targetId
	elseif data.abuseVector == AbuseVector.UserProfile then
		copy.REPORT_TARGET_USER_ID = targetId
	elseif data.abuseVector == AbuseVector.Accessory then
		copy.REPORT_TARGET_ASSET_ID = targetId
	elseif data.abuseVector == AbuseVector.Place then
		copy.REPORT_TARGET_ASSET_ID = targetId
	elseif fFlagEnableReportingFlowForDevSubs and data.abuseVector == AbuseVector.Subscription then
		local targetId2 = data.targetId
		copy.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId2.subscriptionTargetKey
		copy.REPORT_TARGET_ASSET_ID = targetId2.imageAssetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.DeveloperProduct then
		copy.REPORT_TARGET_DEVELOPER_PRODUCT_ID = targetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.GamePass then
		copy.REPORT_TARGET_GAME_PASS_ID = targetId
	elseif fFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.InExperienceShop then
		copy.PLACE_ID = targetId
	elseif data.abuseVector == AbuseVector.Group then
		copy.REPORT_TARGET_GROUP_ID = targetId
	elseif data.abuseVector == AbuseVector.Notifications then
		copy.NOTIFICATION_ID = targetId
	elseif data.abuseVector == AbuseVector.AdV2 then
		copy.AD_ID = targetId
	elseif fFlagLuaAppEnableReportBadge and data.abuseVector == AbuseVector.Badge then
		copy.REPORT_TARGET_BADGE_ID = targetId
	end

	if data.abuseVector == AbuseVector.Accessory then
		copy.REPORTED_ABUSE_VECTOR = data.custom and data.custom.assetTypeName or AbuseVector.Accessory

		if copy.REPORTED_ABUSE_VECTOR == "EmoteAnimation" then
			copy.REPORTED_ABUSE_VECTOR = AbuseVector.Accessory
			return copy
		end
	else
		copy.REPORTED_ABUSE_VECTOR = data.abuseVector
	end

	return copy
end

return function(data)
	local v5 = fn({
		formData = data.formData,
		localPlayerUserId = data.localPlayerUserId
	})

	local v6 = fn2({
		abuseVector = data.abuseVector,
		custom = data.custom,
		targetId = data.targetId,
		tags = v5
	})

	Dash.forEach(data.additionalReportTags or {}, function(p2)
		if not p2.tagKey or p2.tagKey == "" or not p2.tagValue or p2.tagValue == "" then
			return
		end

		if v6[p2.tagKey] == nil then
			v6[p2.tagKey] = p2.tagValue

			return
		end

		local v7 = v6[p2.tagKey]
		v6[p2.tagKey] = v7 .. "," .. p2.tagValue
	end)

	return v6
end
