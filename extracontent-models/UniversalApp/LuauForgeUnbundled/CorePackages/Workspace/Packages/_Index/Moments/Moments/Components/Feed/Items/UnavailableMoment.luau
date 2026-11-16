local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local MomentUnavailableItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/UnavailableMoment/MomentUnavailableItem")

return {
	{
		kind = "unavailableMoment",
		getKey = function(p2)
			return "__unavailable_moment__:" .. p2.targetId
		end,
		getAttribution = function(p2): nil
			return nil
		end,
		render = function(p2, p3)
			return React.createElement(MomentUnavailableItem, { isModerated = p2.isModerated })
		end
	}
}
