local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact").useSignalState

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/createPostInsightsPageStore")
local getPostInsightsPageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore")
local PostInsightsPageView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/PostInsightsPageView")
local usePostInsightsPageViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/usePostInsightsPageViewModel")

local function PostInsightsPage(p2)
	local v5 = usePostInsightsPageViewModel(p2.context, p2.onBack)
	return React.createElement(PostInsightsPageView, v5)
end

local function PostInsightsPageContainer()
	local v5 = getPostInsightsPageStore(false)
	local v6 = useSignalState(v5.getIsOpen)
	local v7 = useSignalState(v5.getContext)

	if v6 and v7 ~= nil then
		return React.createElement(PostInsightsPage, {
			key = v7.moment.momentId,
			context = v7,
			onBack = v5.close
		})
	end

	return nil
end

return React.memo(PostInsightsPageContainer)
