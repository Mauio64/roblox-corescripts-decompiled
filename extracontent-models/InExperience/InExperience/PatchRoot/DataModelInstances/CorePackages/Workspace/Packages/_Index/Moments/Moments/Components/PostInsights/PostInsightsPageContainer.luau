local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useSignalState = SignalsReact.useSignalState

require(script.Parent.createPostInsightsPageStore)
local getPostInsightsPageStore = require(script.Parent.getPostInsightsPageStore)
local PostInsightsPageView = require(script.Parent.PostInsightsPageView)
local usePostInsightsPageViewModel = require(script.Parent.usePostInsightsPageViewModel)

local function PostInsightsPage(p)
	local v = usePostInsightsPageViewModel(p.context, p.onBack)
	return React.createElement(PostInsightsPageView, v)
end

local function PostInsightsPageContainer()
	local postInsightsPageStore = getPostInsightsPageStore(false)
	local v = useSignalState(postInsightsPageStore.getIsOpen)
	local context = useSignalState(postInsightsPageStore.getContext)

	if v and context ~= nil then
		return React.createElement(PostInsightsPage, {
			key = context.moment.momentId,
			context = context,
			onBack = postInsightsPageStore.close
		})
	end

	return nil
end

return React.memo(PostInsightsPageContainer)
