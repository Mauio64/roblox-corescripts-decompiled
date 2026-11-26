require("@luauforge/deferred/gzP")

local module = require("@luauforge/deferred/gzS")

local view = require("@luauforge/deferred/gzT").View

local usePageAnalytics = require("@luauforge/deferred/gzU").usePageAnalytics
local usePageNavigation = require("@luauforge/deferred/gzY").usePageNavigation
local useDispatch = require("@luauforge/deferred/gAC").Hooks.RoactRodux.useDispatch

local function CtaButtonsContainer(p2)
	local v5 = usePageNavigation()
	local v6 = usePageAnalytics()
	local v7 = useDispatch()

	local currentCtaComponent = v5.CurrentCtaComponent

	if currentCtaComponent then
		return module.createElement(
			view,
			{
				tag = "size-full-0 auto-y col gap-medium padding-x-xxlarge padding-bottom-xxlarge padding-top-medium"
			},
			module.createElement(currentCtaComponent, {
				key = v5.currentPageName,
				moderationDetail = p2.moderationDetail,
				dispatch = v7,
				LogoutThunk = p2.LogoutThunk,
				goToNextPage = v5.goToNextPage,
				sendPageEvent = v6.sendPageEvent,
				hasNavigatedForward = v5.hasNavigatedForward
			})
		)
	end

	return nil
end

return module.memo(CtaButtonsContainer)
