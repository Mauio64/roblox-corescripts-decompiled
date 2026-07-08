local CorePackages = game:GetService("CorePackages")

if not require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlatformLeaderboardRccEnabled then
	return
end

local PlatformLeaderboardsRcc = require(CorePackages.Workspace.Packages.PlatformLeaderboardsRcc)
local v3 = assert(PlatformLeaderboardsRcc.PlatformLeaderboardFetcher)
local v4 = assert(PlatformLeaderboardsRcc.PlatformLeaderboardConfigService)
local v5 = assert(PlatformLeaderboardsRcc.PlatformLeaderboardController)
local v6 = v4.new(v3)

v5.new(v6, v3):initialize()
