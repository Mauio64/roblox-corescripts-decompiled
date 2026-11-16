local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeed = FeedContext.useFeed
local MomentsEndStateView = require(script.Parent.MomentsEndStateView)

local signal = Signals.createSignal(true)

local function MomentsEndStateItem(p)
	local v = useFeed()

	local showLoadMore = SignalsReact.useSignalState(v.getCanLoadMoreBeyondLimit or signal)

	local loadMoreBeyondLimit = v.loadMoreBeyondLimit
	local onLoadMore = React.useCallback(function()
		if loadMoreBeyondLimit ~= nil then
			loadMoreBeyondLimit()
		end
	end, { loadMoreBeyondLimit })

	return React.createElement(MomentsEndStateView, {
		LayoutOrder = p.LayoutOrder,
		onLoadMore = onLoadMore,
		showLoadMore = showLoadMore
	})
end

return MomentsEndStateItem
