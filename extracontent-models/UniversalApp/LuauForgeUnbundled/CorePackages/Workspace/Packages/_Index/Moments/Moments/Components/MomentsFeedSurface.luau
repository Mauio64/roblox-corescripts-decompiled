local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local view = Foundation.View
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local MomentsHostContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed
local fFlagProfileRenderAvatarMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagProfileRenderAvatarMoments

local feed = module3.Feed

local function MomentsFeedSurface(props)
	local bottomInset = props.bottomInset or 0

	local v5 = if fFlagProfileRenderAvatarMoments then MomentsHostContext.useMomentsHost() else nil
	local v6 = v5 == nil or v5.isTopShell ~= false

	local v7 = fFlagMomentsRenderAvatarPostsInFeed and { Transparency = 1 } or nil

	local element = React.createElement(feed, {
		source = props.source,
		active = not (fFlagProfileRenderAvatarMoments and not v6) and props.active,
		playbackActive = not (fFlagProfileRenderAvatarMoments and not v6) and props.playbackActive,
		telemetry = props.telemetry,
		inactiveDestination = props.inactiveDestination,
		controllerRef = props.controllerRef,
		initialIndex = props.initialIndex,
		trackSurfaceLoad = props.trackSurfaceLoad,
		emptyState = props.emptyState,
		caughtUpState = props.caughtUpState
	})

	local renderFeedContainer = props.renderFeedContainer
	local v12

	if renderFeedContainer == nil then
		v12 = React.createElement(view, {
			backgroundStyle = v7,
			tag = "size-full",
			padding = bottomInset > 0 and { bottom = UDim.new(0, bottomInset) } or nil,
			ZIndex = Constants.DisplayOrder.Feed
		}, { Feed = element })
	else
		v12 = renderFeedContainer(element)
	end

	return React.createElement(view, {
		backgroundStyle = v7,
		tag = {
			["size-full"] = fFlagMomentsRenderAvatarPostsInFeed,
			["size-full bg-surface-0"] = not fFlagMomentsRenderAvatarPostsInFeed
		}
	}, {
		FoundationContainer = React.createElement(view, {
			backgroundStyle = v7,
			tag = "size-full"
		}, {
			OnVideoUI = React.createElement(foundationProvider, {
				colorMode = colorMode.Dark
			}, {
				FeedContainer = v12,
				Header = props.header
			})
		})
	})
end

return MomentsFeedSurface
