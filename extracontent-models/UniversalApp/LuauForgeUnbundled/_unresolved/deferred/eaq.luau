local module = require("@luauforge/deferred/dXS")
local module2 = require("@luauforge/deferred/eaj")
local module3 = require("@luauforge/deferred/dZz")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module5 = require("@luauforge/deferred/dZm")
local module6 = require("@luauforge/deferred/eal")
local module7 = require("@luauforge/deferred/ear")

local fetchGameVotes = module3.GameVotes.FetchGameVotes

local loadableImage = module7.App.Loading.LoadableImage
local loadingStrategy = module7.App.Loading.Enum.LoadingStrategy
local view = module2.View

local blurDirection = module.Enums.BlurDirection
local module8 = require("@luauforge/deferred/eam")
local module9 = require("@luauforge/deferred/eas")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local module11 = require("@luauforge/deferred/eaA")
local module12 = require("@luauforge/deferred/eaB")
local imageBlurEffect = module.Components.ImageBlurEffect
local loadableVideo = module.Components.LoadableVideo
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
local module14 = require("@luauforge/deferred/eaS")
require("@luauforge/deferred/eaT")

local module15 = require("@luauforge/deferred/dZw")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useCallback = React.useCallback
local useDispatch = module5.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local module17 = require("@luauforge/deferred/eaU")
local useMemo = React.useMemo
local usePostThumbnail = module.Hooks.usePostThumbnail
local useRef = React.useRef
local useScreenSize = module6.useScreenSize
local useSelector = module5.Hooks.RoactRodux.useSelector
local useState = React.useState

local function getFeedVideoUrl(p2)
	if p2 then
		return "rbxassetid://" .. tostring(p2)
	end

	return ""
end

return function(props)
	local v5 = useAnalytics()
	local v6 = useDispatch()
	local v7 = useScreenSize()

	local isZooming = React.useContext(CapturesContext).isZooming

	local state, setState = useState(0)
	local v8 = useRef(false)
	local state2, setState2 = useState(false)
	local v9 = useRef(os.clock())
	local state3, setState3 = useState(Vector2.new(v7.X, v7.Y))
	local v10 = useRef(nil)

	local v11 = useSelector(function(p2)
		return p2.ContentFeed.Inspect.IsOpen
	end)

	useEffect(function()
		if module15 then
			return
		end

		v6(Networking.NetworkingUsers.GetUserV2FromUserId.API((tostring(props.creatorUserId)))):catch(function() end)
	end, { v6, props.creatorUserId })

	useEffect(function()
		v6(fetchGameVotes.Fetch(Networking.ContentFeedNetworkImpl, (tostring(props.universeId)))):catch(function() end)
	end, { v6, props.universeId })

	useEffect(function()
		if props.type ~= module14.Video then
			setState3(Vector2.new(props.screenshotMetadata.width, props.screenshotMetadata.height))
		end
	end, { props.screenshotMetadata, props.type })

	local v12 = useCallback(function()
		if not v8.current then
			local v13 = module8.ContentFeedImageLatency

			if props.type == module14.Video then
				v13 = module8.ContentFeedVideoLatency
			end

			v5.fireEvent(v13, {
				statValue = os.clock() - v9.current
			})

			v8.current = true
		end
	end, { v5, v8, v9 })

	local v13 = useCallback(function()
		if not state2 then
			local v14 = module8.ContentFeedImageLoadFailed

			if props.type == module14.Video then
				v14 = module8.ContentFeedVideoLoadFailed
			end

			v5.fireEvent(v14, { postId = props.postId })

			setState2(true)
		end

		return React.createElement(module11, { layoutOrder = 1 })
	end, { v5, state2, props.postId, props.type })

	local v14, v15, v16 = useMemo(function()
		local v17 = state3.X / state3.Y
		local v18 = v7.Y * 0.33

		local v19 = state / v17

		if v19 < v18 then
			v19 = v18
		elseif v7.Y < v19 then
			v19 = v7.Y
		end

		if props.type == module14.Video then
			v19 = v7.Y
		end

		local v20 = v19 < v7.Y / 2

		if props.type == module14.Video then
			v20 = false
		elseif state2 then
			v20 = false
		end

		return v19, v20, (v7.Y - v19) / 2
	end, { state, state2, state3, props.type, v7.Y })

	local v17 = props.postId == props.currentPostId
	local v18 = module17(v17, v14, state, v11)

	useEffect(function()
		if v17 and v10.current then
			v10.current:Play()
		elseif v10.current then
			v10.current:Pause()
		end
	end, { v17, v10.current })

	local itemContainerRef = v18.itemContainerRef
	local itemFinalScale = v18.itemFinalScale
	local initialZoomFocusPosition = v18.initialZoomFocusPosition
	local nonItemTransparency = v18.nonItemTransparency
	local zoomAverageDelta = v18.zoomAverageDelta
	local zoomEndTransition = v18.zoomEndTransition
	local zoomEndTransitionActive = v18.zoomEndTransitionActive

	local v19 = props.screenshotMetadata.fullSizeUrl
	local v20 = not v19 or v19 == ""
	local v22 = if v20 then props.assetId else nil
	local v23, v24 = usePostThumbnail(v22, props.screenshotMetadata.width, props.screenshotMetadata.height)

	if v20 and v24 then
		v19 = v23
	end

	local createElement = React.createElement
	local v26 = {
		LayoutOrder = props.layoutOrder,
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize.X)
		end,
		Size = UDim2.new(1, 0, 0, v7.Y),
		tag = "bg-action-subtle",
		ZIndex = v17 and 2 or 1
	}
	local v27

	if v15 then
		v27 = React.createElement(imageBlurEffect, {
			AnchorPoint = Vector2.new(0.5, 1),
			direction = blurDirection.Up,
			image = v19,
			imageSize = state3,
			Position = UDim2.new(0.5, 0, 0.5, -v14 / 2),
			Size = UDim2.new(1, 0, 0, v16),
			transparencyBinding = if v17 then nonItemTransparency else nil,
			ZIndex = isZooming and v17 and -3 or 0
		})
	end

	local createElement2 = React.createElement
	local v29 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = 0,
		ref = 0,
		Size = 0,
		ZIndex = 1
	}
	local v30

	if zoomEndTransitionActive and initialZoomFocusPosition.current then
		v30 = zoomEndTransition:map(function(p2)
			local v31 = itemFinalScale.current / (1 + (itemFinalScale.current - 1) * p2)

			local v32 = (0.5 - (initialZoomFocusPosition.current.X - zoomAverageDelta.current.X) / v7.X) * v7.X * (v31 - 1)

			local v33 = (0.5 - (initialZoomFocusPosition.current.Y - zoomAverageDelta.current.Y) / v7.Y) * v7.Y * (v31 - 1)
			return UDim2.new(0.5, v32, 0.5, v33)
		end)
	else
		v30 = UDim2.fromScale(0.5, 0.5)
	end

	v29.Position = v30

	v29.ref = itemContainerRef
	local v31

	if zoomEndTransitionActive then
		v31 = zoomEndTransition:map(function(p2)
			local v32 = itemFinalScale.current / (1 + (itemFinalScale.current - 1) * p2)
			return UDim2.new(v32, 0, 0, v14 * v32)
		end)
	else
		v31 = UDim2.new(1, 0, 0, v14)
	end

	v29.Size = v31
	local v33

	if props.type == module14.Video then
		local createElement3 = React.createElement
		local v35 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			onLoaded = v12,
			onResolutionChanged = setState3,
			Position = UDim2.fromScale(0.5, 0.5),
			renderOnFailed = v13,
			Size = UDim2.fromScale(1, 1),
			Video = 0,
			videoRef = 0,
			ZIndex = 1
		}
		local assetId = props.assetId
		v35.Video = not assetId and "" or "rbxassetid://" .. tostring(assetId)
		v35.videoRef = v10
		v33 = createElement3(loadableVideo, v35)
	else
		v33 = React.createElement(loadableImage, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = v19,
			loadingStrategy = loadingStrategy.Eager,
			onLoaded = v12,
			renderOnFailed = v13,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1
		})
	end

	local children = {
		TopBlur = v27,
		ContentFeedImageContainer = createElement2(view, v29, { ContentFeedItem = v33 }),
		BottomBlur = 0,
		BottomBar = 0
	}
	local v34

	if v15 then
		v34 = React.createElement(imageBlurEffect, {
			AnchorPoint = Vector2.new(0.5, 0),
			direction = blurDirection.Down,
			image = v19,
			imageSize = state3,
			Position = UDim2.new(0.5, 0, 0.5, v14 / 2),
			Size = UDim2.new(1, 0, 0, v16),
			transparencyBinding = if v17 then nonItemTransparency else nil,
			ZIndex = isZooming and v17 and -3 or 0
		})
	end

	children.BottomBlur = v34

	children.BottomBar = React.createElement(view, {
		GroupTransparency = nonItemTransparency:map(function(p2)
			return p2
		end),
		tag = "auto-y anchor-bottom-center position-bottom-center bg-action-subtle size-full-0 col align-x-left align-y-bottom",
		ZIndex = 2
	}, {
		Overlay = React.createElement(module12, {
			additionalInfo = props.additionalInfo,
			caption = props.caption,
			creatorUserId = props.creatorUserId,
			postId = props.postId,
			uploadedAtTimestamp = props.uploadedAtTimestamp
		}),
		ExperienceInfo = React.createElement(module9, {
			layoutOrder = 2,
			placeId = props.placeId,
			postId = props.postId,
			universeId = props.universeId
		})
	})
	return createElement(view, v26, children)
end
