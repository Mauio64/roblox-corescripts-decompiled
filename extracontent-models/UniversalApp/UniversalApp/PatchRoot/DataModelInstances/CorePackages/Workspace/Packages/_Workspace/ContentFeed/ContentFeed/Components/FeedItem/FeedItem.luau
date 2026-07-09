local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Foundation = require(ParentParentParent.Foundation)
local GameVotesRodux = require(ParentParentParent.GameVotesRodux)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local FetchGameVotes = GameVotesRodux.GameVotes.FetchGameVotes
local LoadableImage = UIBlox.App.Loading.LoadableImage
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local View = Foundation.View
local BlurDirection = CapturesCommon.Enums.BlurDirection
local EventNames = require(ParentParent.Analytics.EventNames)
local ExperienceInfo = require(ParentParent.Components.FeedOverlay.ExperienceInfo)
local FeedContext = require(ParentParent.App.FeedContext)
local FeedItemPostsNotFound = require(ParentParent.Components.FeedItem.FeedItemPostsNotFound)
local FeedOverlay = require(ParentParent.Components.FeedOverlay.FeedOverlay)
local ImageBlurEffect = CapturesCommon.Components.ImageBlurEffect
local LoadableVideo = CapturesCommon.Components.LoadableVideo
local Networking = require(ParentParent.App.Networking)
local PostType = require(ParentParent.Enums.PostType)

require(ParentParent.Types)

local useAnalytics = require(ParentParent.Hooks.useAnalytics)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useFeedZoomController = require(ParentParent.Hooks.useFeedZoomController)
local useMemo = React.useMemo
local usePostThumbnail = CapturesCommon.Hooks.usePostThumbnail
local useRef = React.useRef
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState

local function getFeedVideoUrl(n1: number?) -- line: 44
	if not n1 then
		return ""
	end

	return "rbxassetid://" .. tostring(n1)
end

return function(t1: {[any]: any}) -- line: 67
	-- upvalues: useAnalytics (copy), useDispatch (copy), useScreenSize (copy), React (copy), FeedContext (copy), useState (copy), useRef (copy), useSelector (copy), useEffect (copy), Networking (copy), FetchGameVotes (copy), PostType (copy), useCallback (copy), EventNames (copy), FeedItemPostsNotFound (copy), useMemo (copy), useFeedZoomController (copy), usePostThumbnail (copy), View (copy), ImageBlurEffect (copy), BlurDirection (copy), LoadableVideo (copy), LoadableImage (copy), LoadingStrategy (copy), FeedOverlay (copy), ExperienceInfo (copy)
	local v38 = useAnalytics()
	local v39 = useDispatch()
	local v40 = useScreenSize()
	local isZooming = React.useContext(FeedContext).isZooming
	local v42, v43 = useState(0)
	local v44 = useRef(false)
	local v45, v46 = useState(false)
	local v47 = useRef(os.clock())
	local v48, v49 = useState(Vector2.new(v40.X, v40.Y))
	local v50 = useRef(nil)
	local v51 = useSelector(function(p1) -- line: 82
		return p1.ContentFeed.Inspect.IsOpen
	end)

	useEffect(function() -- line: 86
		-- upvalues: v39 (copy), Networking (copy), t1 (copy)
		v39(Networking.NetworkingUsers.GetUserV2FromUserId.API((tostring(t1.creatorUserId)))):catch(function() -- line: 87
		end)
	end, {
		v39,
		t1.creatorUserId
	})
	useEffect(function() -- line: 92
		-- upvalues: v39 (copy), FetchGameVotes (copy), Networking (copy), t1 (copy)
		v39(FetchGameVotes.Fetch(Networking.ContentFeedNetworkImpl, (tostring(t1.universeId)))):catch(function() -- line: 93
		end)
	end, {
		v39,
		t1.universeId
	})
	useEffect(function() -- line: 98
		-- upvalues: t1 (copy), PostType (copy), v49 (copy)
		if t1.type ~= PostType.Video then
			v49(Vector2.new(t1.screenshotMetadata.width, t1.screenshotMetadata.height))
		end
	end, {
		t1.screenshotMetadata,
		t1.type
	})

	local v52 = useCallback(function() -- line: 104
		-- upvalues: v44 (copy), EventNames (copy), t1 (copy), PostType (copy), v38 (copy), v47 (copy)
		if not v44.current then
			local ContentFeedImageLatency = EventNames.ContentFeedImageLatency

			if t1.type == PostType.Video then
				ContentFeedImageLatency = EventNames.ContentFeedVideoLatency
			end

			v38.fireEvent(ContentFeedImageLatency, {
				statValue = os.clock() - v47.current
			})
			v44.current = true
		end
	end, {
		v38,
		v44,
		v47
	})
	local v53 = useCallback(function() -- line: 117
		-- upvalues: v45 (copy), EventNames (copy), t1 (copy), PostType (copy), v38 (copy), v46 (copy), React (copy), FeedItemPostsNotFound (copy)
		if not v45 then
			local ContentFeedImageLoadFailed = EventNames.ContentFeedImageLoadFailed

			if t1.type == PostType.Video then
				ContentFeedImageLoadFailed = EventNames.ContentFeedVideoLoadFailed
			end

			v38.fireEvent(ContentFeedImageLoadFailed, {
				postId = t1.postId
			})
			v46(true)
		end

		return React.createElement(FeedItemPostsNotFound, {
			layoutOrder = 1
		})
	end, {
		v38,
		v45,
		t1.postId,
		t1.type
	})
	local v54, v55, v56 = useMemo(function() -- line: 133
		-- upvalues: v48 (copy), v40 (copy), v42 (copy), t1 (copy), PostType (copy), v45 (copy)
		local v86 = v48.X / v48.Y
		local v87 = v40.Y * 0.33
		local v88 = v42 / v86

		if v88 < v87 then
			v88 = v87
		elseif v88 > v40.Y then
			v88 = v40.Y
		end

		if t1.type == PostType.Video then
			v88 = v40.Y
		end

		local v89 = v88 < v40.Y / 2

		if t1.type == PostType.Video then
			v89 = false
		elseif v45 then
			v89 = false
		end

		return v88, v89, (v40.Y - v88) / 2
	end, {
		v42,
		v45,
		v48,
		t1.type,
		v40.Y
	})
	local v57 = t1.postId == t1.currentPostId
	local v58 = useFeedZoomController(v57, v54, v42, v51)

	useEffect(function() -- line: 167
		-- upvalues: v57 (copy), v50 (copy)
		if v57 and v50.current then
			v50.current:Play()

			return
		end

		if v50.current then
			v50.current:Pause()
		end
	end, {
		v57,
		v50.current
	})

	local itemContainerRef = v58.itemContainerRef
	local itemFinalScale = v58.itemFinalScale
	local initialZoomFocusPosition = v58.initialZoomFocusPosition
	local nonItemTransparency = v58.nonItemTransparency
	local zoomAverageDelta = v58.zoomAverageDelta
	local zoomEndTransition = v58.zoomEndTransition
	local zoomEndTransitionActive = v58.zoomEndTransitionActive
	local fullSizeUrl = t1.screenshotMetadata.fullSizeUrl
	local v67 = not fullSizeUrl or fullSizeUrl == ""
	local v68, v69 = usePostThumbnail(if not v67 then nil else t1.assetId, t1.screenshotMetadata.width, t1.screenshotMetadata.height)

	if v67 and v69 then
		fullSizeUrl = v68
	end

	local createElement = React.createElement
	local v71 = View
	local t2 = {
		tag = "bg-action-subtle",
		LayoutOrder = t1.layoutOrder,
		onAbsoluteSizeChanged = function(p2) -- line: 198
			-- upvalues: v43 (copy)
			v43(p2.AbsoluteSize.X)
		end,
		Size = UDim2.new(1, 0, 0, v40.Y),
		ZIndex = not v57 and 1 or 2
	}
	local t3 = {
		TopBlur = if not v55 then nil else React.createElement(ImageBlurEffect, {
			AnchorPoint = Vector2.new(0.5, 1),
			direction = BlurDirection.Up,
			image = fullSizeUrl,
			imageSize = v48,
			Position = UDim2.new(0.5, 0, 0.5, -v54 / 2),
			Size = UDim2.new(1, 0, 0, v56),
			transparencyBinding = if not v57 then nil else nonItemTransparency,
			ZIndex = (not isZooming or not v57) and 0 or -3
		})
	}
	local createElement2 = React.createElement
	local v75 = View
	local t4 = {
		ZIndex = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = if not zoomEndTransitionActive or not initialZoomFocusPosition.current then UDim2.fromScale(0.5, 0.5) else zoomEndTransition:map(function(p3) -- line: 221
			-- upvalues: itemFinalScale (copy), initialZoomFocusPosition (copy), zoomAverageDelta (copy), v40 (copy)
			local v92 = itemFinalScale.current / (1 + (itemFinalScale.current - 1) * p3)
			local v93 = (0.5 - (initialZoomFocusPosition.current.X - zoomAverageDelta.current.X) / v40.X) * v40.X * (v92 - 1)
			local v94 = (0.5 - (initialZoomFocusPosition.current.Y - zoomAverageDelta.current.Y) / v40.Y) * v40.Y * (v92 - 1)

			return UDim2.new(0.5, v93, 0.5, v94)
		end),
		ref = itemContainerRef,
		Size = if not zoomEndTransitionActive then UDim2.new(1, 0, 0, v54) else zoomEndTransition:map(function(p4) -- line: 240
			-- upvalues: itemFinalScale (copy), v54 (copy)
			local v96 = itemFinalScale.current / (1 + (itemFinalScale.current - 1) * p4)

			return UDim2.new(v96, 0, 0, v54 * v96)
		end)
	}
	local t5 = {}
	local v82

	if t1.type == PostType.Video then
		local createElement3 = React.createElement
		local v79 = LoadableVideo
		local t6 = {
			BackgroundTransparency = 1,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			onLoaded = v52,
			onResolutionChanged = v49,
			Position = UDim2.fromScale(0.5, 0.5),
			renderOnFailed = v53,
			Size = UDim2.fromScale(1, 1)
		}
		local assetId = t1.assetId

		t6.Video = if assetId then "rbxassetid://" .. tostring(assetId) else ""
		t6.videoRef = v50
		v82 = createElement3(v79, t6)
	else
		v82 = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = fullSizeUrl,
			loadingStrategy = LoadingStrategy.Eager,
			onLoaded = v52,
			renderOnFailed = v53,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		})
	end

	t5.ContentFeedItem = v82
	t3.ContentFeedImageContainer = createElement2(v75, t4, t5)
	t3.BottomBlur = if not v55 then nil else React.createElement(ImageBlurEffect, {
		AnchorPoint = Vector2.new(0.5, 0),
		direction = BlurDirection.Down,
		image = fullSizeUrl,
		imageSize = v48,
		Position = UDim2.new(0.5, 0, 0.5, v54 / 2),
		Size = UDim2.new(1, 0, 0, v56),
		transparencyBinding = if not v57 then nil else nonItemTransparency,
		ZIndex = (not isZooming or not v57) and 0 or -3
	})
	t3.BottomBar = React.createElement(View, {
		tag = "auto-y anchor-bottom-center position-bottom-center bg-action-subtle size-full-0 col align-x-left align-y-bottom",
		ZIndex = 2,
		GroupTransparency = nonItemTransparency:map(function(p5) -- line: 291
			return p5
		end)
	}, {
		Overlay = React.createElement(FeedOverlay, {
			additionalInfo = t1.additionalInfo,
			caption = t1.caption,
			creatorUserId = t1.creatorUserId,
			postId = t1.postId,
			uploadedAtTimestamp = t1.uploadedAtTimestamp
		}),
		ExperienceInfo = React.createElement(ExperienceInfo, {
			layoutOrder = 2,
			placeId = t1.placeId,
			postId = t1.postId,
			universeId = t1.universeId
		})
	})

	return createElement(v71, t2, t3)
end
