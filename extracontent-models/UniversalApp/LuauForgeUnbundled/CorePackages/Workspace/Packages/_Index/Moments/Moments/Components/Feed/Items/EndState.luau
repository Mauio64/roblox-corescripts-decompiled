local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local MomentsEndStateItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/EndState/MomentsEndStateItem")

return {
	{
		kind = "endState",
		getKey = function(p2): string
			return "__feed_end_state__"
		end,
		getAttribution = function(p2): nil
			return nil
		end,
		render = function(p2, p3)
			return React.createElement(MomentsEndStateItem)
		end
	}
}
