local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local View = require(NotApprovedPageParent.Foundation).View
local usePageAnalytics = require(NotApprovedPage.Contexts.PageAnalyticsContext).usePageAnalytics
local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch

local function CtaButtonsContainer(t1: {[any]: any}) -- line: 28
	-- upvalues: usePageNavigation (copy), usePageAnalytics (copy), useDispatch (copy), React (copy), View (copy)
	local v10 = usePageNavigation()
	local v11 = usePageAnalytics()
	local v12 = useDispatch()
	local CurrentCtaComponent = v10.CurrentCtaComponent

	if not CurrentCtaComponent then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium padding-x-xxlarge padding-bottom-xxlarge padding-top-medium"
	}, React.createElement(CurrentCtaComponent, {
		key = v10.currentPageName,
		moderationDetail = t1.moderationDetail,
		dispatch = v12,
		LogoutThunk = t1.LogoutThunk,
		goToNextPage = v10.goToNextPage,
		sendPageEvent = v11.sendPageEvent,
		hasNavigatedForward = v10.hasNavigatedForward
	}))
end

return React.memo(CtaButtonsContainer)
