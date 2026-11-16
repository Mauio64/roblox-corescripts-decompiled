local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

if not SharedFlags.FFlagPlatformLeaderboardRccEnabled then
	return
end

local PlatformLeaderboardsRcc = require(CorePackages.Workspace.Packages.PlatformLeaderboardsRcc)
local v = assert(PlatformLeaderboardsRcc.PlatformLeaderboardFetcher)
local v2 = assert(PlatformLeaderboardsRcc.PlatformLeaderboardConfigService)
local v3 = assert(PlatformLeaderboardsRcc.PlatformLeaderboardController)

local v4 = v2.new(v)
v3.new(v4, v):initialize()
