local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local PlatformLeaderboardStoreContext = require(parent.Common.PlatformLeaderboardStoreContext)

local function usePlatformLeaderboard()
	return (React.useContext(PlatformLeaderboardStoreContext))
end

return usePlatformLeaderboard
