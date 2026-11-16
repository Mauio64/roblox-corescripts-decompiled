local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Dash = require(parent.Dash)
local React = require(parent.React)
local AdaptiveScrollingContext = require(script.Parent.AdaptiveScrollingContext)
require(parent.AppCommonLib)

local function withAdaptiveScrolling(p)
	return function(p2)
		return React.createElement(AdaptiveScrollingContext.Consumer, {
			render = function(adaptiveScrolling)
				return React.createElement(p, Dash.join(p2, {
					adaptiveScrolling = adaptiveScrolling
				}))
			end
		})
	end
end

return withAdaptiveScrolling
