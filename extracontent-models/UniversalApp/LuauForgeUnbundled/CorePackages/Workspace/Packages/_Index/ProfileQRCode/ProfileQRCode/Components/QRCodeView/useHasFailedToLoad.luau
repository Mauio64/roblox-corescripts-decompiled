local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")
local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.useEffectOnce
require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")

return function(p2, p3)
	useEffectOnce(function()
		p2.fireEvent(EventNames.QRPageLoadFailed)
	end, p3)
end
