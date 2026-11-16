local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local CaughtUpItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/CaughtUp/CaughtUpItem")

return {
	{
		kind = "caughtUp",
		getKey = function(p2): string
			return "__feed_caught_up__"
		end,
		getAttribution = function(p2): nil
			return nil
		end,
		render = function(p2, p3)
			return React.createElement(CaughtUpItem)
		end
	}
}
