local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local NavigationBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/NavigationBar")

local function FeedNavigationBar(props)
	local v5 = SignalsReact.useSignalState(props.pager.getItems)
	local v6 = SignalsReact.useSignalState(props.pager.getCurrentIndex)

	local count = #v5
	local v7 = v5[count]

	if v7 ~= nil and v7.kind == "skeleton" then
		count -= 1
	end

	local v8 = math.min(v6, (math.max(count, 1)))

	return React.createElement(NavigationBar, {
		active = props.active,
		currentIndex = v8,
		numItems = count,
		onScrollToNext = props.onScrollToNext,
		onScrollToPrevious = props.onScrollToPrevious,
		zIndex = props.zIndex
	})
end

return FeedNavigationBar
