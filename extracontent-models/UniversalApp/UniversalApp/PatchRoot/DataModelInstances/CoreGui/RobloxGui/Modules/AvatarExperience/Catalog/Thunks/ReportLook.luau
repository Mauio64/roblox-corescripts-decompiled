local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local AbuseVector = require(CorePackages.Workspace.Packages.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(CorePackages.Workspace.Packages.GenericAbuseReporting.OpenDynamicAbuseReport)
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local Promise = require(CorePackages.Packages.Promise)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local FFlagEnableAbuseReportRevampFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAbuseReportRevampFlow
local v18 = game:DefineFastFlag("EnableAbuseReportRevampLooks", false)
local t1 = {
	toastMessage = "Feature.Catalog.Response.ReportSubmitted",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmitFailure",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1) -- line: 41
	-- upvalues: PerformFetch (copy), WidgetConstants (copy), Cryo (copy), Promise (copy), UserInputService (copy), IsVRAppBuild (copy), FFlagEnableAbuseReportRevampFlow (copy), v18 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), WebApi (copy), SetCurrentToastMessage (copy), t1 (copy), Logging (copy), t2 (copy)
	return PerformFetch.Single("reportLookKey", function(p2) -- line: 42
		-- upvalues: WidgetConstants (copy), Cryo (copy), Promise (copy), UserInputService (copy), IsVRAppBuild (copy), FFlagEnableAbuseReportRevampFlow (copy), v18 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), WebApi (copy), p1 (copy), SetCurrentToastMessage (copy), t1 (copy), Logging (copy), t2 (copy)
		local v23 = p2:getState()
		local LocalUserId = v23.LocalUserId
		local LookId = v23.AvatarExperience.AvatarScene.OutfitTryOn.LookId
		local v26 = v23.AvatarExperience.Common.Widgets.HydratedWidgetData[WidgetConstants.ContentType.Look]
		local v27 = if not v26 or not LookId then nil else v26[LookId]
		local v28 = if not v27 then nil else Cryo.List.map(v27.assets, function(p3) -- line: 49
			return (tostring(p3.id))
		end)

		if not LookId then
			return Promise.reject("Attempt to report a look, but no look is currently displayed")
		end

		local Platform = UserInputService:GetPlatform()
		local s1 = "unknown"

		if IsVRAppBuild() then
			s1 = "vr"
		elseif Platform == Enum.Platform.Windows or Platform == Enum.Platform.OSX then
			s1 = "desktop"
		elseif Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android or Platform == Enum.Platform.UWP then
			s1 = "mobile"
		elseif Platform == Enum.Platform.XBox360 or Platform == Enum.Platform.XBoxOne or Platform == Enum.Platform.PS3 or Platform == Enum.Platform.PS4 or Platform == Enum.Platform.PS5 or Platform == Enum.Platform.WiiU then
			s1 = "console"
		end

		local v31 = v27 and (v27.curator and v27.curator.id ~= 1)
		local v32 = not v31 and "LOOKS" or "COMMUNITY_LOOKS"
		local t3 = {
			REPORTED_ABUSE_CATEGORY = "ABUSE_CATEGORY_OTHER",
			REPORTER_COMMENT = "",
			ENTRY_POINT = s1,
			REPORTED_ABUSE_VECTOR = v32,
			SUBMITTER_USER_ID = LocalUserId,
			REPORT_TARGET_LOOK_ID = LookId,
			REPORT_TARGET_LOOK_INCLUDED_ASSET_ID = v28
		}

		if FFlagEnableAbuseReportRevampFlow and v18 then
			p2:dispatch(OpenDynamicAbuseReport({
				abuseVector = if not v31 then AbuseVector.Looks else AbuseVector.CommunityLooks,
				targetId = {
					lookId = LookId,
					lookAssetsIds = v28
				},
				onClose = function() -- line: 96
					-- upvalues: p2 (copy), CloseCentralOverlay (copy)
					p2:dispatch(CloseCentralOverlay())
				end
			}))

			return Promise.resolve()
		end

		return WebApi.AbuseReport(p1, t3):andThen(function(_) -- line: 103
			-- upvalues: p2 (copy), SetCurrentToastMessage (copy), t1 (copy)
			p2:dispatch(SetCurrentToastMessage(t1))
		end, function(p5) -- line: 105
			-- upvalues: Logging (copy), p2 (copy), SetCurrentToastMessage (copy), t2 (copy)
			Logging.warn("WebApi failure in AbuseReport: " .. tostring(p5))
			p2:dispatch(SetCurrentToastMessage(t2))
		end)
	end)
end
