local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FeedMessageView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedMessageView")

local useTokens = Foundation.Hooks.useTokens

local function MomentsTimeLimitView(p2)
	local v5 = useTokens()

	return React.createElement(FeedMessageView, {
		iconName = BuilderIcons.Icon.LockClosed,
		iconSize = v5.Size.Size_1600,
		tilted = true,
		frameRadiusTag = "radius-small",
		title = p2.title,
		description = p2.description,
		testId = "moments-time-limit"
	})
end

return MomentsTimeLimitView
