local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)

require(script.Parent.FeedTypes)

local NavigationBar = require(script.Parent.NavigationBar)

local function FeedNavigationBar(t1: {[any]: any}) -- line: 35
	-- upvalues: SignalsReact (copy), React (copy), NavigationBar (copy)
	local v7 = SignalsReact.useSignalState(t1.pager.getItems)
	local v8 = SignalsReact.useSignalState(t1.pager.getCurrentIndex)
	local v9 = #v7
	local v10 = v7[v9]
	local v11 = if v10 == nil or v10.kind ~= "skeleton" then v9 else v9 - 1
	local v12 = math.min(v8, (math.max(v11, 1)))

	return React.createElement(NavigationBar, {
		active = t1.active,
		currentIndex = v12,
		numItems = v11,
		onScrollToNext = t1.onScrollToNext,
		onScrollToPrevious = t1.onScrollToPrevious,
		zIndex = t1.zIndex
	})
end

return FeedNavigationBar
