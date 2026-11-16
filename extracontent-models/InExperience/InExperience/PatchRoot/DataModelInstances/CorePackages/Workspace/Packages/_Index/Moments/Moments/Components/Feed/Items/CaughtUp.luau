local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

require(Moments.Components.Feed.FeedTypes)
local CaughtUpItem = require(script.CaughtUpItem)

return {
	{
		kind = "caughtUp",
		getKey = function(_): string
			return "__feed_caught_up__"
		end,
		getAttribution = function(_): nil
			return nil
		end,
		render = function(_, _: number)
			return React.createElement(CaughtUpItem)
		end
	}
}
