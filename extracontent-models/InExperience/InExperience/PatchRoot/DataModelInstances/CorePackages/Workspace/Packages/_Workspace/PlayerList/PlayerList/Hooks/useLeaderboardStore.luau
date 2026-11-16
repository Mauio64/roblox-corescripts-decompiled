local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local LeaderboardStoreContext = require(parent.Common.LeaderboardStoreContext)

local function useLeaderboardStore()
	return (React.useContext(LeaderboardStoreContext))
end

return useLeaderboardStore
