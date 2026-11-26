local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local useFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeed
local MomentsEndStateView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/EndState/MomentsEndStateView")

local signal = Signals.createSignal(true)

local function MomentsEndStateItem(p2)
	local v5 = useFeed()

	local v6 = SignalsReact.useSignalState(v5.getCanLoadMoreBeyondLimit or signal)

	local loadMoreBeyondLimit = v5.loadMoreBeyondLimit
	local v7 = React.useCallback(function()
		if loadMoreBeyondLimit ~= nil then
			loadMoreBeyondLimit()
		end
	end, { loadMoreBeyondLimit })

	return React.createElement(MomentsEndStateView, {
		LayoutOrder = p2.LayoutOrder,
		onLoadMore = v7,
		showLoadMore = v6
	})
end

return MomentsEndStateItem
