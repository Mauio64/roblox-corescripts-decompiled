local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local AdaptiveScrollingContext = require(script.Parent.AdaptiveScrollingContext)

require(Parent.AppCommonLib)

local function withAdaptiveScrolling(p1) -- line: 26
	-- upvalues: React (copy), AdaptiveScrollingContext (copy), Dash (copy)
	return function(p2) -- line: 27
		-- upvalues: React (copy), AdaptiveScrollingContext (copy), p1 (copy), Dash (copy)
		return React.createElement(AdaptiveScrollingContext.Consumer, {
			render = function(p3) -- line: 29
				-- upvalues: React (copy), p1 (copy), Dash (copy), p2 (copy)
				return React.createElement(p1, Dash.join(p2, {
					adaptiveScrolling = p3
				}))
			end
		})
	end
end

return withAdaptiveScrolling
