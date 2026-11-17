local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FeedMessageView = require(Moments.Components.Feed.FeedMessageView)

local useTokens = Foundation.Hooks.useTokens

local function MomentsTimeLimitView(p)
	local v = useTokens()

	return React.createElement(FeedMessageView, {
		iconName = BuilderIcons.Icon.LockClosed,
		iconSize = v.Size.Size_1600,
		tilted = true,
		frameRadiusTag = "radius-small",
		title = p.title,
		description = p.description,
		testId = "moments-time-limit"
	})
end

return MomentsTimeLimitView
