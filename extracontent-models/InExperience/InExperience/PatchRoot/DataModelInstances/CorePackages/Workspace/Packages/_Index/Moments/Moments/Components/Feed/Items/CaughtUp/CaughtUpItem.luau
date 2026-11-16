local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeed = FeedContext.useFeed

local View = Foundation.View

local function CaughtUpItem(p)
	local v = useFeed()

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "col align-x-center align-y-center size-full padding-xlarge clip bg-surface-0",
			testId = "--moments-feed-caught-up-page"
		},
		{ Content = v.caughtUpState }
	)
end

return CaughtUpItem
