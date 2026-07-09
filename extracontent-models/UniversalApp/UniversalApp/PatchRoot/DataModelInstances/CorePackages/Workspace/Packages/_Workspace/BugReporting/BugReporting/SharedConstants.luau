local Parent = script:FindFirstAncestor("BugReporting").Parent
local InfoNames = require(Parent.SystemInfoProtocol).SystemInfoProtocol.InfoNames
local t1 = {
	InfoNames.APP_VERSION,
	InfoNames.DEVICE_NAME,
	InfoNames.SYSTEM_VERSION,
	"screen"
}

return {
	ISSUE_CHANNEL = "internal-in-app",
	SCREENSHOT_BUCKET = "InternalInAppBugReporting",
	SCREENSHOT_URN_PREFIX = "urn:roblox:moderationscreenshot:InternalInAppBugReporting",
	SCREEN_SUMMARY_KEY = "screen",
	DEVICE_SUMMARY_ORDERED_KEYS = t1
}
