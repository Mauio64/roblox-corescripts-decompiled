local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeed

local view = Foundation.View

local function CaughtUpItem(p2)
	local v5 = useFeed()

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "col align-x-center align-y-center size-full padding-xlarge clip bg-surface-0",
			testId = "--moments-feed-caught-up-page"
		},
		{ Content = v5.caughtUpState }
	)
end

return CaughtUpItem
