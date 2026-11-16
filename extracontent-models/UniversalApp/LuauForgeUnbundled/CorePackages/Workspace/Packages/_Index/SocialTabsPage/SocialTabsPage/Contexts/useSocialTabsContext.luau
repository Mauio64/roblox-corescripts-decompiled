local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local SocialTabsContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Contexts/SocialTabsContext")

local function useSocialTabsContext()
	local v5 = React.useContext(SocialTabsContext)
	assert(v5 ~= nil, "useSocialTabsContext must be used within a SocialTabsContext.Provider")
	return v5
end

return useSocialTabsContext
