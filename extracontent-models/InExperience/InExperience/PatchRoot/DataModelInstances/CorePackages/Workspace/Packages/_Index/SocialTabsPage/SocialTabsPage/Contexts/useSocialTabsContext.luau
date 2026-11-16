local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)
local SocialTabsContext = require(script.Parent.SocialTabsContext)

local function useSocialTabsContext()
	local v = React.useContext(SocialTabsContext)
	assert(v ~= nil, "useSocialTabsContext must be used within a SocialTabsContext.Provider")
	return v
end

return useSocialTabsContext
