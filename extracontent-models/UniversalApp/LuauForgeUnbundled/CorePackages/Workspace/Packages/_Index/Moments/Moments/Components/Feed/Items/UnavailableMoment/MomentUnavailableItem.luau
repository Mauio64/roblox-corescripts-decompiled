local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeed
local MomentOverlayInsetContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentOverlayInsetContext")
local MomentUnavailableView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/UnavailableMoment/MomentUnavailableView")
local useIsPagerItemActive = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager").useIsPagerItemActive
local FFlagMomentsFeedAboveNavBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedAboveNavBar")

local usePreferences = Foundation.Hooks.usePreferences

local function MomentUnavailableItem(p2)
	local v5 = useFeed()
	local reducedMotion = usePreferences().reducedMotion
	local v6 = MomentOverlayInsetContext.useMomentOverlayInset()

	local v8 = useIsPagerItemActive()

	local scrollToNext = v5.scrollToNext
	local v9 = React.useCallback(function()
		if scrollToNext ~= nil then
			scrollToNext()
		end
	end, { scrollToNext })

	return React.createElement(MomentUnavailableView, {
		LayoutOrder = p2.LayoutOrder,
		isModerated = p2.isModerated,
		onNext = v9,
		animate = v5.isActiveFeed and v5.isPlaybackActive and v8 and not reducedMotion,
		bottomInset = FFlagMomentsFeedAboveNavBar and 0 or v6
	})
end

return MomentUnavailableItem
