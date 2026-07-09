local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local t1 = {
	toastMessage = "Feature.Catalog.Response.ReportSubmitted",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmitFailure",
	isLocalized = false,
	toastType = ToastType.NetworkingError
}

return function(p1, p2, p3, p4) -- line: 25
	-- upvalues: PerformFetch (copy), IsVRAppBuild (copy), WebApi (copy), SetCurrentToastMessage (copy), t1 (copy), Logging (copy), t2 (copy)
	return PerformFetch.Single("reportBundleKey", function(p5) -- line: 26
		-- upvalues: IsVRAppBuild (copy), p3 (copy), WebApi (copy), p1 (copy), p2 (copy), p4 (copy), SetCurrentToastMessage (copy), t1 (copy), Logging (copy), t2 (copy)
		local LocalUserId = p5:getState().LocalUserId
		local s1 = "unknown"

		if IsVRAppBuild() then
			s1 = "vr"
		elseif p3 == Enum.Platform.Windows or p3 == Enum.Platform.OSX or p3 == Enum.Platform.UWP then
			s1 = "desktop"
		elseif p3 == Enum.Platform.IOS or p3 == Enum.Platform.Android then
			s1 = "mobile"
		elseif p3 == Enum.Platform.XBox360 or p3 == Enum.Platform.XBoxOne or p3 == Enum.Platform.PS3 or p3 == Enum.Platform.PS4 or p3 == Enum.Platform.PS5 or p3 == Enum.Platform.WiiU then
			s1 = "console"
		end

		return WebApi.AbuseReportBundle(p1, LocalUserId, p2, s1, p4):andThen(function(_) -- line: 49
			-- upvalues: p5 (copy), SetCurrentToastMessage (copy), t1 (copy)
			p5:dispatch(SetCurrentToastMessage(t1))
		end, function(p7) -- line: 51
			-- upvalues: Logging (copy), p5 (copy), SetCurrentToastMessage (copy), t2 (copy)
			Logging.warn("WebApi failure in AbuseReportBundle: " .. tostring(p7))
			p5:dispatch(SetCurrentToastMessage(t2))
		end)
	end)
end
