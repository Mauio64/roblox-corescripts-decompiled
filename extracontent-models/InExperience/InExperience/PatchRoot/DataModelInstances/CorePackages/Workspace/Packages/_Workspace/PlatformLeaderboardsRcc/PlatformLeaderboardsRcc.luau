local PlatformLeaderboardTypes = require(script.PlatformLeaderboardTypes)
local scriptParent = script.Parent
local FFlagPlatformLeaderboardRccEnabled = require(scriptParent.SharedFlags).FFlagPlatformLeaderboardRccEnabled
local v4 = if not FFlagPlatformLeaderboardRccEnabled then nil else require(script.PlatformLeaderboardFetcher)
local v5 = if not FFlagPlatformLeaderboardRccEnabled then nil else require(script.PlatformLeaderboardConfigService)
local v6 = if not FFlagPlatformLeaderboardRccEnabled then nil else require(script.PlatformLeaderboardCache)
local v7 = if not FFlagPlatformLeaderboardRccEnabled then nil else require(script.PlatformLeaderboardController)

return {
	["jest.config"] = script["jest.config"],
	PlatformLeaderboardTypes = PlatformLeaderboardTypes,
	PlatformLeaderboardFetcher = v4,
	PlatformLeaderboardConfigService = v5,
	PlatformLeaderboardCache = v6,
	PlatformLeaderboardController = v7
}
