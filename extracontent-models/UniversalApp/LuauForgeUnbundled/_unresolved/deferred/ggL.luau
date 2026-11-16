local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module2 = require("@luauforge/bundled/dwB")
local module3 = require("@luauforge/bundled/dCh")

local v5 = {
	toastMessage = "Feature.Catalog.Response.ReportSubmitted",
	isLocalized = false,
	toastType = module2.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.ReportAbuse.Message.ErrorSubmitFailure",
	isLocalized = false,
	toastType = module2.NetworkingError
}

return function(p2, p3, p4, p5)
	return performFetch.Single("reportBundleKey", function(object)
		local localUserId = object:getState().LocalUserId
		local v7

		if isVRAppBuild() then
			v7 = "vr"
		elseif p4 == Enum.Platform.Windows or p4 == Enum.Platform.OSX or p4 == Enum.Platform.UWP then
			v7 = "desktop"
		elseif p4 == Enum.Platform.IOS or p4 == Enum.Platform.Android then
			v7 = "mobile"
		elseif
			p4 == Enum.Platform.XBox360
			or p4 == Enum.Platform.XBoxOne
			or p4 == Enum.Platform.PS3
			or p4 == Enum.Platform.PS4
			or p4 == Enum.Platform.PS5
			or p4 == Enum.Platform.WiiU
		then
			v7 = "console"
		else
			v7 = "unknown"
		end

		return GetExperienceSourceLanguage.AbuseReportBundle(p2, localUserId, p3, v7, p5):andThen(function(p6)
			object:dispatch(module3(v5))
		end, function(p6)
			logging.warn("WebApi failure in AbuseReportBundle: " .. tostring(p6))
			object:dispatch(module3(v6))
		end)
	end)
end
