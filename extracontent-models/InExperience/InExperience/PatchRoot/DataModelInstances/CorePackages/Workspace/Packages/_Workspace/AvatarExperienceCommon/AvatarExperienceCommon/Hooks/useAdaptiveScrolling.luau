local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local AdaptiveScrollingContext = require(script.Parent.AdaptiveScrollingContext)

local function useAdaptiveScrolling() -- line: 15
	-- upvalues: React (copy), AdaptiveScrollingContext (copy)
	return React.useContext(AdaptiveScrollingContext)
end

return useAdaptiveScrolling
