local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.LoggingProtocol)

return {
	RerenderTimingStat = {
		eventName = "PurchasePromptAppRerenderTiming",
		throttlingPercentage = 1000,
		description = "Stat for tracking re-render timing in PurchasePromptApp to detect performance issues",
		links = "https://roblox.atlassian.net/browse/APPEXP-2951",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			8,
			4
		}
	}
}
