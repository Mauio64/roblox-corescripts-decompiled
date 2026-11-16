local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.FeedTypes)
local NavigationBar = require(script.Parent.NavigationBar)

local function FeedNavigationBar(props)
	local v = SignalsReact.useSignalState(props.pager.getItems)
	local v2 = SignalsReact.useSignalState(props.pager.getCurrentIndex)

	local count = #v
	local v3 = v[count]

	if v3 ~= nil and v3.kind == "skeleton" then
		count -= 1
	end

	local currentIndex = math.min(v2, (math.max(count, 1)))

	return React.createElement(NavigationBar, {
		active = props.active,
		currentIndex = currentIndex,
		numItems = count,
		onScrollToNext = props.onScrollToNext,
		onScrollToPrevious = props.onScrollToPrevious,
		zIndex = props.zIndex
	})
end

return FeedNavigationBar
