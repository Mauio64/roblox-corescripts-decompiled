local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local AdaptiveScrollingContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/AdaptiveScrollingContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AppCommonLib")

local function withAdaptiveScrolling(p2)
	return function(p3)
		return React.createElement(AdaptiveScrollingContext.Consumer, {
			render = function(p4)
				return React.createElement(p2, Dash.join(p3, {
					adaptiveScrolling = p4
				}))
			end
		})
	end
end

return withAdaptiveScrolling
