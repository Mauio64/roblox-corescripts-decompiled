local infoNames = require("@luauforge/bundled/hZg").SystemInfoProtocol.InfoNames

return {
	ISSUE_CHANNEL = "internal-in-app",
	SCREENSHOT_BUCKET = "InternalInAppBugReporting",
	SCREENSHOT_URN_PREFIX = "urn:roblox:moderationscreenshot:InternalInAppBugReporting",
	SCREEN_SUMMARY_KEY = "screen",
	DEVICE_SUMMARY_ORDERED_KEYS = {
		infoNames.APP_VERSION,
		infoNames.DEVICE_NAME,
		infoNames.SYSTEM_VERSION,
		"screen"
	}
}
