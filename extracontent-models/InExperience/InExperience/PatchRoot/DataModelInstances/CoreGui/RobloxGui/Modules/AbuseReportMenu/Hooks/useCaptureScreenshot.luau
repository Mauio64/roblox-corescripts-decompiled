local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require(AbuseReportMenu.Components.Types)
local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)

local TnSScreenshot = require(CorePackages.Workspace.Packages.TnSScreenshot)
local ScreenshotManager = TnSScreenshot.ScreenshotManager

local AvatarIdentification = TnSAvatarIdentification.AvatarIdentification
local AdIdentification = TnSAdIdentification.AdIdentification

return function(callback, callback2, callback3)
	return React.useCallback(function()
		ScreenshotManager:TakeScreenshotWithCallback(callback2, callback)
		local visibleAvatars, avatarIDStats = AvatarIdentification.getVisibleAvatars()
		local visibleAds, adIDStats = AdIdentification.getVisibleAds()

		callback3({
			identifiedAvatars = visibleAvatars,
			identifiedAds = visibleAds,
			avatarIDStats = avatarIDStats,
			adIDStats = adIDStats
		})
	end, { callback2, callback, callback3 })
end
