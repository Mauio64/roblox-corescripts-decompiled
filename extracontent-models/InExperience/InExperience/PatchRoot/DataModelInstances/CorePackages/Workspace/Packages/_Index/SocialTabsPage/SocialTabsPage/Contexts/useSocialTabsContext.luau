local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local React = require(Parent.React)
local SocialTabsContext = require(script.Parent.SocialTabsContext)

local function useSocialTabsContext() -- line: 7
	-- upvalues: React (copy), SocialTabsContext (copy)
	local v5 = React.useContext(SocialTabsContext)

	assert(v5 ~= nil, "useSocialTabsContext must be used within a SocialTabsContext.Provider")

	return v5
end

return useSocialTabsContext
