local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local module = require("@luauforge/deferred/gLo")
local module2 = require("@luauforge/deferred/gLp")

local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local Promise = require(CorePackages.Packages.Promise)
local module4 = require("@luauforge/bundled/dzE")
local module5 = require("@luauforge/bundled/dFm")

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAbuseReportRevampFlow
local defineFastFlag = game:DefineFastFlag("EnableAbuseReportRevampLooks", false)

local v5 = {
	toastMessage = "Feature.Catalog.Response.ReportSubmitted",
	isLocalized = false,
	toastType = module4.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmitFailure",
	isLocalized = false,
	toastType = module4.InformationMessage
}

return function(p2)
	return performFetch.Single("reportLookKey", function(object)
		local state = object:getState()
		local localUserId = state.LocalUserId
		local lookId = state.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local v7 = state.AvatarExperience.Common.Widgets.HydratedWidgetData[widgetConstants.ContentType.Look]
		local v8 = if v7 and lookId then v7[lookId] else nil
		local mapped

		if v8 then
			mapped = Cryo.List.map(v8.assets, function(p3)
				return (tostring(p3.id))
			end)
		end

		if not lookId then
			return Promise.reject("Attempt to report a look, but no look is currently displayed")
		end

		local platform = UserInputService:GetPlatform()
		local v9

		if isVRAppBuild() then
			v9 = "vr"
		elseif platform == Enum.Platform.Windows or platform == Enum.Platform.OSX then
			v9 = "desktop"
		elseif
			platform == Enum.Platform.IOS
			or platform == Enum.Platform.Android
			or platform == Enum.Platform.UWP
		then
			v9 = "mobile"
		elseif
			platform == Enum.Platform.XBox360
			or platform == Enum.Platform.XBoxOne
			or platform == Enum.Platform.PS3
			or platform == Enum.Platform.PS4
			or platform == Enum.Platform.PS5
			or platform == Enum.Platform.WiiU
		then
			v9 = "console"
		else
			v9 = "unknown"
		end

		local v10 = v8 and v8.curator and v8.curator.id ~= 1

		local v11 = {
			ENTRY_POINT = v9,
			REPORTED_ABUSE_CATEGORY = "ABUSE_CATEGORY_OTHER",
			REPORTED_ABUSE_VECTOR = v10 and "COMMUNITY_LOOKS" or "LOOKS",
			REPORTER_COMMENT = "",
			SUBMITTER_USER_ID = localUserId,
			REPORT_TARGET_LOOK_ID = lookId,
			REPORT_TARGET_LOOK_INCLUDED_ASSET_ID = mapped
		}

		if not (fFlagEnableAbuseReportRevampFlow and defineFastFlag) then
			return GetExperienceSourceLanguage.AbuseReport(p2, v11):andThen(function(p3)
				object:dispatch(module5(v5))
			end, function(p3)
				logging.warn("WebApi failure in AbuseReport: " .. tostring(p3))
				object:dispatch(module5(v6))
			end)
		end

		local v14 = if v10 then module.CommunityLooks else module.Looks
		object:dispatch(module2({
			abuseVector = v14,
			targetId = { lookId = lookId, lookAssetsIds = mapped },
			onClose = function()
				object:dispatch(closeCentralOverlay())
			end
		}))

		return Promise.resolve()
	end)
end
