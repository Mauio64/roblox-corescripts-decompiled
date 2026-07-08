local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(AbuseReportMenu.Components.Types)

local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)
local ScreenshotManager = require(CorePackages.Workspace.Packages.TnSScreenshot).ScreenshotManager
local AvatarIdentification = TnSAvatarIdentification.AvatarIdentification
local AdIdentification = TnSAdIdentification.AdIdentification

return function(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 18
	-- upvalues: React (copy), ScreenshotManager (copy), AvatarIdentification (copy), AdIdentification (copy)
	return React.useCallback(function() -- line: 23
		-- upvalues: ScreenshotManager (copy), p2 (copy), p1 (copy), AvatarIdentification (copy), AdIdentification (copy), p3 (copy)
		ScreenshotManager:TakeScreenshotWithCallback(p2, p1)

		local v12, v13 = AvatarIdentification.getVisibleAvatars()
		local v14, v15 = AdIdentification.getVisibleAds()

		p3({
			identifiedAvatars = v12,
			identifiedAds = v14,
			avatarIDStats = v13,
			adIDStats = v15
		})
	end, {
		p2,
		p1,
		p3
	})
end
