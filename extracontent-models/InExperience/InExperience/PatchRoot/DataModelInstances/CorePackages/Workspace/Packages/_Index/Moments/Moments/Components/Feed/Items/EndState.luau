local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

require(Moments.Components.Feed.FeedTypes)
local MomentsEndStateItem = require(script.MomentsEndStateItem)

return {
	{
		kind = "endState",
		getKey = function(_): string
			return "__feed_end_state__"
		end,
		getAttribution = function(_): nil
			return nil
		end,
		render = function(_, _: number)
			return React.createElement(MomentsEndStateItem)
		end
	}
}
