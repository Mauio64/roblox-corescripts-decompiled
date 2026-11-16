require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

return {
	RerenderTimingStat = {
		eventName = "PurchasePromptAppRerenderTiming",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2025, 8, 4 },
		throttlingPercentage = 1000,
		description = "Stat for tracking re-render timing in PurchasePromptApp to detect performance issues",
		links = "https://roblox.atlassian.net/browse/APPEXP-2951"
	}
}
