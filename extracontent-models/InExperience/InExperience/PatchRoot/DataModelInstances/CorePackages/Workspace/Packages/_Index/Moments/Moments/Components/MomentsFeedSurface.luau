local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

local Feed = require(Moments.Components.Feed)
local Constants = require(Moments.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local feed = Feed.Feed

local function MomentsFeedSurface(props)
	local bottomInset = props.bottomInset or 0

	local backgroundStyle = FFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil

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
	local feedContainer

	if renderFeedContainer == nil then
		feedContainer = React.createElement(View, {
			backgroundStyle = backgroundStyle,
			tag = "size-full",
			padding = bottomInset > 0 and { bottom = UDim.new(0, bottomInset) } or nil,
			ZIndex = Constants.DisplayOrder.Feed
		}, { Feed = element })
	else
		feedContainer = renderFeedContainer(element)
	end

	return React.createElement(View, {
		backgroundStyle = backgroundStyle,
		tag = {
			["size-full"] = FFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not FFlagMomentsRenderAvatarPostsInFeed
		}
	}, {
		FoundationContainer = React.createElement(View, {
			backgroundStyle = backgroundStyle,
			tag = "size-full"
		}, {
			OnVideoUI = React.createElement(FoundationProvider, { colorMode = ColorMode.Dark }, {
				FeedContainer = feedContainer,
				Header = props.header
			})
		})
	})
end

return MomentsFeedSurface
