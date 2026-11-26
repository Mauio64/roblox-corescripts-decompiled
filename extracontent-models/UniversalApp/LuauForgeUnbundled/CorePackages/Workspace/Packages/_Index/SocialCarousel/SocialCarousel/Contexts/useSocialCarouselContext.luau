local SocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/SocialCarouselContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

return function()
	return React.useContext(SocialCarouselContext)
end
