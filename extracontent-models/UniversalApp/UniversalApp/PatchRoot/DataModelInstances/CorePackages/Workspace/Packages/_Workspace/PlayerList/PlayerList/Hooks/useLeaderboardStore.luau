local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local LeaderboardStoreContext = require(ParentParent.Common.LeaderboardStoreContext)

local function useLeaderboardStore() -- line: 8
	-- upvalues: React (copy), LeaderboardStoreContext (copy)
	return (React.useContext(LeaderboardStoreContext))
end

return useLeaderboardStore
