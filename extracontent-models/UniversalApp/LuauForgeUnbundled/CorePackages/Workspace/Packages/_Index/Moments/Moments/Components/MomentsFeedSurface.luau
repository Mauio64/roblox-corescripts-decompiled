local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local view = Foundation.View
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

local feed = module3.Feed

local function MomentsFeedSurface(props)
	local bottomInset = props.bottomInset or 0

	local v5 = fFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil

	local element = React.createElement(feed, {
		source = props.source,
		active = props.active,
		playbackActive = props.playbackActive,
		telemetry = props.telemetry,
		inactiveDestination = props.inactiveDestination,
		controllerRef = props.controllerRef,
		initialIndex = props.initialIndex,
		trackSurfaceLoad = props.trackSurfaceLoad,
		emptyState = props.emptyState,
		caughtUpState = props.caughtUpState
	})

	local renderFeedContainer = props.renderFeedContainer
	local v6

	if renderFeedContainer == nil then
		v6 = React.createElement(view, {
			backgroundStyle = v5,
			tag = "size-full",
			padding = bottomInset > 0 and { bottom = UDim.new(0, bottomInset) } or nil,
			ZIndex = Constants.DisplayOrder.Feed
		}, { Feed = element })
	else
		v6 = renderFeedContainer(element)
	end

	return React.createElement(view, {
		backgroundStyle = v5,
		tag = {
			["size-full"] = fFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not fFlagMomentsRenderAvatarPostsInFeed
		}
	}, {
		FoundationContainer = React.createElement(view, {
			backgroundStyle = v5,
			tag = "size-full"
		}, {
			OnVideoUI = React.createElement(foundationProvider, {
				colorMode = colorMode.Dark
			}, {
				FeedContainer = v6,
				Header = props.header
			})
		})
	})
end

return MomentsFeedSurface
