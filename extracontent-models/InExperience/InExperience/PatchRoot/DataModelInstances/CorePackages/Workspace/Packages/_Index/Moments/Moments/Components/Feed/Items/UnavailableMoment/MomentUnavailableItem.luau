local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeed = FeedContext.useFeed
local MomentOverlayInsetContext = require(Moments.Components.Feed.Items.Moment.MomentOverlayInsetContext)
local MomentUnavailableView = require(script.Parent.MomentUnavailableView)
local VerticalPager = require(Moments.Components.VerticalPager)
local useIsPagerItemActive = VerticalPager.useIsPagerItemActive
local FFlagMomentsFeedAboveNavBar = require(Moments.Flags.FFlagMomentsFeedAboveNavBar)

local usePreferences = Foundation.Hooks.usePreferences

local function MomentUnavailableItem(p)
	local v = useFeed()
	local reducedMotion = usePreferences().reducedMotion
	local v2 = MomentOverlayInsetContext.useMomentOverlayInset()

	local v3 = useIsPagerItemActive()

	local scrollToNext = v.scrollToNext
	local onNext = React.useCallback(function()
		if scrollToNext ~= nil then
			scrollToNext()
		end
	end, { scrollToNext })

	return React.createElement(MomentUnavailableView, {
		LayoutOrder = p.LayoutOrder,
		isModerated = p.isModerated,
		onNext = onNext,
		animate = v.isActiveFeed and v.isPlaybackActive and v3 and not reducedMotion,
		bottomInset = FFlagMomentsFeedAboveNavBar and 0 or v2
	})
end

return MomentUnavailableItem
