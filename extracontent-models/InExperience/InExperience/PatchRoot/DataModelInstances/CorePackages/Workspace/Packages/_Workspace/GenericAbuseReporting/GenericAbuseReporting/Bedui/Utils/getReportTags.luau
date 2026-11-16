local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local SharedFlags = require(parent.SharedFlags)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local ValueToAbuseCategory = require(GenericAbuseReporting.Enums.ValueToAbuseCategory)

local FFlagLuaAppEnableReportBadge = SharedFlags.FFlagLuaAppEnableReportBadge
local FFlagEnableReportingFlowForDevSubs = SharedFlags.FFlagEnableReportingFlowForDevSubs
local FFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
local FFlagGenericAbuseReportingUnifyReportTags = require(GenericAbuseReporting.Flags.FFlagGenericAbuseReportingUnifyReportTags)

local function fn(p)
	local v = {}
	v.ENTRY_POINT = "in-app"
	v.SUBMITTER_USER_ID = p.localPlayerUserId

	if FFlagGenericAbuseReportingUnifyReportTags then
		v.REPORTED_ABUSE_CATEGORY = ValueToAbuseCategory[p.formData.legacy_abuse_category]
			or p.formData.abuse_category
			or AbuseCategory.ABUSE_CATEGORY_INVALID
	else
		v.REPORTED_ABUSE_CATEGORY = p.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID
	end

	v.REPORTER_COMMENT = p.formData.free_comment or ""

	return v
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
	elseif FFlagEnableReportingFlowForDevSubs and data.abuseVector == AbuseVector.Subscription then
		local targetId2 = data.targetId
		copy.REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = targetId2.subscriptionTargetKey
		copy.REPORT_TARGET_ASSET_ID = targetId2.imageAssetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.DeveloperProduct then
		copy.REPORT_TARGET_DEVELOPER_PRODUCT_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.GamePass then
		copy.REPORT_TARGET_GAME_PASS_ID = targetId
	elseif FFlagEnableReportingFlowForExperienceShop and data.abuseVector == AbuseVector.InExperienceShop then
		copy.PLACE_ID = targetId
	elseif data.abuseVector == AbuseVector.Group then
		copy.REPORT_TARGET_GROUP_ID = targetId
	elseif data.abuseVector == AbuseVector.Notifications then
		copy.NOTIFICATION_ID = targetId
	elseif data.abuseVector == AbuseVector.AdV2 then
		copy.AD_ID = targetId
	elseif FFlagLuaAppEnableReportBadge and data.abuseVector == AbuseVector.Badge then
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
	local tags = fn({ formData = data.formData, localPlayerUserId = data.localPlayerUserId })

	local v = fn2({
		abuseVector = data.abuseVector,
		custom = data.custom,
		targetId = data.targetId,
		tags = tags
	})

	Dash.forEach(data.additionalReportTags or {}, function(p)
		if not p.tagKey or p.tagKey == "" or not p.tagValue or p.tagValue == "" then
			return
		end

		if v[p.tagKey] == nil then
			v[p.tagKey] = p.tagValue

			return
		end

		local v2 = v[p.tagKey]
		v[p.tagKey] = v2 .. "," .. p.tagValue
	end)

	return v
end
