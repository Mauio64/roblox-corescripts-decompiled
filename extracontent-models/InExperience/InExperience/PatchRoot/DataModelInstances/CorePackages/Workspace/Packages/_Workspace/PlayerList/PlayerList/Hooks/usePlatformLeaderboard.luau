local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local PlatformLeaderboardStoreContext = require(ParentParent.Common.PlatformLeaderboardStoreContext)

local function usePlatformLeaderboard() -- line: 8
	-- upvalues: React (copy), PlatformLeaderboardStoreContext (copy)
	return (React.useContext(PlatformLeaderboardStoreContext))
end

return usePlatformLeaderboard
