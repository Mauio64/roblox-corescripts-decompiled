local SocialTab = script:FindFirstAncestor("SocialTab")
local Roact = require(SocialTab.dependencies).Roact
local UserCarouselContainer = require(script.Components.UserCarouselContainer)

return {
	render = function(p1) -- line: 8
		-- upvalues: Roact (copy), UserCarouselContainer (copy)
		return Roact.createElement(UserCarouselContainer, p1)
	end
}
