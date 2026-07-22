local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local View = Foundation.View
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Feed = require(Moments.Components.Feed)
local Constants = require(Moments.Constants)
local Feed2 = Feed.Feed

local function MomentsFeedSurface(t1: {[any]: any}) -- line: 49
	-- upvalues: React (copy), Feed2 (copy), View (copy), Constants (copy), FoundationProvider (copy), Theme (copy)
	local v13 = t1.bottomInset or 0
	local v14 = React.createElement(Feed2, {
		source = t1.source,
		active = t1.active,
		playbackActive = t1.playbackActive,
		telemetry = t1.telemetry,
		controllerRef = t1.controllerRef,
		initialIndex = t1.initialIndex,
		trackSurfaceLoad = t1.trackSurfaceLoad
	})
	local renderFeedContainer = t1.renderFeedContainer
	local v16 = if renderFeedContainer == nil then React.createElement(View, {
		tag = "size-full",
		padding = if not (v13 > 0) then nil else {
			bottom = UDim.new(0, v13)
		},
		ZIndex = Constants.DisplayOrder.Feed
	}, {
		Feed = v14
	}) else renderFeedContainer(v14)

	return React.createElement(View, {
		tag = "size-full bg-surface-0"
	}, {
		FoundationContainer = React.createElement(View, {
			tag = "size-full"
		}, {
			OnVideoUI = React.createElement(FoundationProvider, {
				theme = Theme.Dark
			}, {
				FeedContainer = v16,
				Header = t1.header
			})
		})
	})
end

return MomentsFeedSurface
