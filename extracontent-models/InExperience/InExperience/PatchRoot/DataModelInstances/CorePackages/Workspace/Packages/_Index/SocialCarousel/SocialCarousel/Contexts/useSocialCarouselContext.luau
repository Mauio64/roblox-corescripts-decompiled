local parent = script:FindFirstAncestor("SocialCarousel").Parent
local SocialCarouselContext = require(script.Parent.SocialCarouselContext)
local React = require(parent.React)

return function()
	return React.useContext(SocialCarouselContext)
end
