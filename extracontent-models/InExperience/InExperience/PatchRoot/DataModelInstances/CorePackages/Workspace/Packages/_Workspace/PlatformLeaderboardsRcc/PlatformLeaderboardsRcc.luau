local PlatformLeaderboardTypes = require(script.PlatformLeaderboardTypes)

local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagPlatformLeaderboardRccEnabled = SharedFlags.FFlagPlatformLeaderboardRccEnabled
local PlatformLeaderboardFetcher

if FFlagPlatformLeaderboardRccEnabled then
	PlatformLeaderboardFetcher = require(script.PlatformLeaderboardFetcher)
end

local PlatformLeaderboardConfigService

if FFlagPlatformLeaderboardRccEnabled then
	PlatformLeaderboardConfigService = require(script.PlatformLeaderboardConfigService)
end

local PlatformLeaderboardCache

if FFlagPlatformLeaderboardRccEnabled then
	PlatformLeaderboardCache = require(script.PlatformLeaderboardCache)
end

local platformLeaderboardController

if FFlagPlatformLeaderboardRccEnabled then
	platformLeaderboardController = require(script.PlatformLeaderboardController)
end

return {
	["jest.config"] = script["jest.config"],
	PlatformLeaderboardTypes = PlatformLeaderboardTypes,
	PlatformLeaderboardFetcher = PlatformLeaderboardFetcher,
	PlatformLeaderboardConfigService = PlatformLeaderboardConfigService,
	PlatformLeaderboardCache = PlatformLeaderboardCache,
	PlatformLeaderboardController = platformLeaderboardController
}
