local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

require(Moments.Components.Feed.FeedTypes)
local MomentUnavailableItem = require(script.MomentUnavailableItem)

return {
	{
		kind = "unavailableMoment",
		getKey = function(p)
			return "__unavailable_moment__:" .. p.targetId
		end,
		getAttribution = function(_): nil
			return nil
		end,
		render = function(p, _: number)
			return React.createElement(MomentUnavailableItem, { isModerated = p.isModerated })
		end
	}
}
