local PlayerContextualMenuAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Analytics/PlayerContextualMenuAnalyticsContext")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/setupFireEvent")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")

return {
	Context = PlayerContextualMenuAnalyticsContext,
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames"),
	setupFireEvent = module2,
	useAnalytics = module3
}
