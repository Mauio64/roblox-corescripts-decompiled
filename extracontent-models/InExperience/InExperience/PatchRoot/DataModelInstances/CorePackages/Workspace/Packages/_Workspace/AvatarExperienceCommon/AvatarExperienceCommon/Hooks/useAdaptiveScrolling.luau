local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local AdaptiveScrollingContext = require(script.Parent.AdaptiveScrollingContext)

local function useAdaptiveScrolling()
	return React.useContext(AdaptiveScrollingContext)
end

return useAdaptiveScrolling
