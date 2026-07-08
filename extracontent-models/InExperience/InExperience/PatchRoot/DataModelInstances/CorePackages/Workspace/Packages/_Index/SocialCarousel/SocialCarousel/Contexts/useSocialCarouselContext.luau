local Parent = script:FindFirstAncestor("SocialCarousel").Parent
local SocialCarouselContext = require(script.Parent.SocialCarouselContext)
local React = require(Parent.React)

return function() -- line: 6
	-- upvalues: React (copy), SocialCarouselContext (copy)
	return React.useContext(SocialCarouselContext)
end
