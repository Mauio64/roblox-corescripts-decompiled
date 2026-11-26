local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")
local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.useEffectOnce
local useShareLinkId = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Rodux/useShareLinkId")
require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")

return function(p2, p3)
	local v5 = useShareLinkId()
	useEffectOnce(function()
		p2.fireEvent(EventNames.QRPageLoad, { shareLinkId = v5 })
	end, p3)
end
