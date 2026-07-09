local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Foundation = require(ParentParentParent.Foundation)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local React = require(ParentParentParent.React)
local Responsive = require(ParentParentParent.Responsive)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local EventNames = require(ParentParent.Analytics.EventNames)
local FeedContext = require(ParentParent.App.FeedContext)
local FeedDirectionType = require(ParentParent.Enums.FeedDirectionType)
local FeedItem = require(ParentParent.Components.FeedItem.FeedItem)
local FeedItemPlaceholder = require(ParentParent.Components.FeedItem.FeedItemPlaceholder)
local FeedItemPostsNotFound = require(ParentParent.Components.FeedItem.FeedItemPostsNotFound)
local FeedTopBar = require(ParentParent.Components.FeedHeader.FeedTopBar)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getFeedPostElements = require(ParentParent.Utils.getFeedPostElements)
local getIsPlaceholder = require(ParentParent.Utils.getIsPlaceholder)
local getPostIndex = require(ParentParent.Utils.getPostIndex)
local InspectClosed = require(ParentParent.Actions.InspectClosed)
local NavigationSidebar = require(ParentParent.Components.NavigationSidebar.NavigationSidebar)

require(ParentParent.Enums.NavigationType)

local PlaceholderType = require(ParentParent.Enums.PlaceholderType)
local RetrievePosts = require(ParentParent.Thunks.RetrievePosts)
local SortOrderType = require(ParentParent.Enums.SortOrderType)

require(ParentParent.Types)

local View = Foundation.View
local useAnalytics = require(ParentParent.Hooks.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useFeedMotionController = require(ParentParent.Hooks.useFeedMotionController)
local useGuiInset = CapturesCommon.Hooks.useGuiInset
local usePreferredInput = Responsive.usePreferredInput
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local v38 = game:DefineFastFlag("ContentFeedCloseInspectOnOpen", false)
local FIntContentFeedZoomEventThrottle = require(ParentParent.Flags.FIntContentFeedZoomEventThrottle)
local FIntContentPostFetchThreshold = require(ParentParent.Flags.FIntContentPostFetchThreshold)

local function v41(t1: {[any]: any}, n1: number?, n2: number?, n3: number?, b1: boolean, s1: string) -- line: 58
	-- upvalues: PlaceholderType (copy), React (copy), FeedItemPostsNotFound (copy), FeedItemPlaceholder (copy), FeedItem (copy)
	local t2 = {}

	if b1 then
		t2[PlaceholderType.PostsNotFound] = React.createElement(FeedItemPostsNotFound, {
			layoutOrder = 1
		})

		return t2
	end

	if #t1 == 0 or n3 == nil then
		t2[PlaceholderType.PostsNotLoaded] = React.createElement(FeedItemPlaceholder, {
			layoutOrder = 1
		})

		return t2
	end

	if n1 then
		t2[PlaceholderType.NextPostsLoading] = React.createElement(FeedItemPlaceholder, {
			layoutOrder = 0
		})
	end

	for i = 1, #t1 do
		local v51 = t1[i]

		t2[v51.postId] = React.createElement(FeedItem, {
			additionalInfo = v51.additionalInfo,
			assetId = v51.assetId,
			caption = v51.caption,
			creatorUserId = v51.creatorUserId,
			currentPostId = s1,
			layoutOrder = i,
			placeId = v51.experienceContext.placeId,
			postId = v51.postId,
			screenshotMetadata = v51.screenshotMetadata,
			universeId = v51.experienceContext.experienceId,
			type = v51.type,
			uploadedAtTimestamp = v51.uploadedAtTimestamp
		})
	end

	if n2 then
		t2[PlaceholderType.PreviousPostsLoading] = React.createElement(FeedItemPlaceholder, {
			layoutOrder = #t1 + 1
		})
	end

	return t2
end
local function v42(t3: {[any]: any}, n4: number) -- line: 115
	-- upvalues: getFeedPostElements (copy)
	local v54 = getFeedPostElements(t3)

	for _, v in pairs(v54) do
		local vName = v.Name

		if math.abs(v.AbsolutePosition.Y + n4) < 5 then
			return vName
		end
	end

	return nil
end

return function(t4: {[any]: any}) -- line: 147
	-- upvalues: useGuiInset (copy), usePreferredInput (copy), useScreenSize (copy), React (copy), FeedContext (copy), useState (copy), useAnalytics (copy), useDispatch (copy), useTokens (copy), useSelector (copy), getDeepValue (copy), v38 (copy), useEffectOnce (copy), InspectClosed (copy), useEffect (copy), getPostIndex (copy), PlaceholderType (copy), useFeedMotionController (copy), EventNames (copy), FIntContentFeedZoomEventThrottle (copy), v42 (copy), FeedDirectionType (copy), FIntContentPostFetchThreshold (copy), RetrievePosts (copy), SortOrderType (copy), getIsPlaceholder (copy), v41 (copy), View (copy), FeedTopBar (copy), Responsive (copy), NavigationSidebar (copy), Foundation (copy)
	local v65 = useGuiInset()
	local v66 = usePreferredInput()
	local v67 = useScreenSize()
	local v68 = React.useContext(FeedContext)
	local v69, v70 = useState(v67)
	local v71 = useAnalytics()
	local v72 = useDispatch()
	local v73 = useTokens()
	local v74, v75 = useState({})
	local v76 = useSelector(function(p1) -- line: 161
		-- upvalues: getDeepValue (copy), t4 (copy), v74 (copy)
		local t5 = {}
		local v111 = getDeepValue(p1, "ContentSharing.byUserId." .. t4.creatorUserId .. ".posts") or {}

		for _, v in pairs(v111) do
			if not table.find(v74, v.postId) then
				table.insert(t5, v)
			end
		end

		return t5
	end)
	local v77, v78 = useState(nil)
	local v79 = useSelector(function(p2) -- line: 174
		return p2.ContentFeed.Inspect.IsOpen
	end)
	local g93 = nil
	local v92 = nil
	local g97 = nil
	local v96 = nil

	if v38 then
		useEffectOnce(function() -- line: 179
			-- upvalues: v79 (copy), v72 (copy), InspectClosed (copy)
			if v79 then
				v72(InspectClosed())
			end
		end, {})
	end

	useEffect(function() -- line: 186
		-- upvalues: getPostIndex (copy), v76 (copy), t4 (copy), v78 (copy)
		local v115 = getPostIndex(v76, t4.initialPostId)

		if #v76 == 0 or v115 == nil then
			return
		end

		v78(v115 - 1)
	end, {
		v76,
		t4.initialPostId
	})

	local v80 = useSelector(function(p3) -- line: 195
		-- upvalues: getDeepValue (copy), t4 (copy)
		return getDeepValue(p3, "ContentSharing.byUserId." .. t4.creatorUserId .. ".nextTimeCursor")
	end)
	local v81 = useSelector(function(p4) -- line: 199
		-- upvalues: getDeepValue (copy), t4 (copy)
		return getDeepValue(p4, "ContentSharing.byUserId." .. t4.creatorUserId .. ".previousTimeCursor")
	end)
	local v82, v83 = useState(if #v76 == 0 then PlaceholderType.PostsNotLoaded else t4.initialPostId)
	local v84 = #v76 == 0 or (v80 ~= nil and v82 == PlaceholderType.NextPostsLoading or (v80 == nil and v82 == v76[1].postId or (v82 == PlaceholderType.PostsNotLoaded or v82 == PlaceholderType.PostsNotFound)))
	local v85 = #v76 == 0 or (v81 ~= nil and v82 == PlaceholderType.PreviousPostsLoading or (v81 == nil and v82 == v76[#v76].postId or (v82 == PlaceholderType.PostsNotLoaded or v82 == PlaceholderType.PostsNotFound)))
	local v86 = #v76
	local v87, v88, v89 = useFeedMotionController(v84, v85, v86, v79)

	useEffect(function() -- line: 221
		-- upvalues: v71 (copy), EventNames (copy), v82 (copy)
		v71.fireEvent(EventNames.ContentFeedPostViewed, {
			postId = v82
		})
	end, {
		v71.fireEvent,
		v82
	})
	useEffect(function() -- line: 227
		-- upvalues: v68 (copy), FIntContentFeedZoomEventThrottle (copy), v71 (copy), EventNames (copy), v82 (copy)
		if v68.isZooming and math.random() < 1 / FIntContentFeedZoomEventThrottle then
			v71.fireEvent(EventNames.ContentFeedZoomOccurred, {
				postId = v82
			})
		end
	end, {
		v71.fireEvent,
		v82,
		v68.isZooming
	})
	useEffect(function() -- line: 235
		-- upvalues: v42 (copy), v87 (copy), v65 (copy), v83 (copy)
		local v118 = v42(v87, v65.top)

		if v118 then
			v83(v118)
		end
	end, {
		v76,
		v65.top
	})

	local v90 = React.useCallback(function() -- line: 243
		-- upvalues: v42 (copy), v87 (copy), v65 (copy), v83 (copy), v74 (copy), v82 (copy), v76 (copy), v68 (copy), v89 (copy), FeedDirectionType (copy), v75 (copy)
		local v119 = v42(v87, v65.top)

		if v119 then
			v83(v119)
		end

		local t6 = {}

		for _, v in pairs(v74) do
			table.insert(t6, v)
		end

		table.insert(t6, v82)

		if #v76 == 1 then
			v68.navigateBack(true)
		elseif v82 ~= v76[1].postId then
			v89(FeedDirectionType.Up)
			task.wait(0.1)
		end

		v75(t6)
	end, {
		v76,
		v68.navigateBack,
		v65.top,
		v88,
		v74,
		v77,
		v89
	})

	useEffect(function() -- line: 276
		-- upvalues: v88 (copy), v42 (copy), v87 (copy), v65 (copy), v83 (copy)
		local v123 = v88:connect(function(_) -- line: 278
			-- upvalues: v42 (copy), v87 (copy), v65 (copy), v83 (copy)
			local v126 = v42(v87, v65.top)

			if v126 then
				v83(v126)
			end
		end)

		return function() -- line: 286
			-- upvalues: v123 (copy)
			v123:disconnect()
		end
	end, {
		v76,
		v82,
		v65.top,
		v88,
		v80,
		v81
	})

	for i = 1, math.min(#v76, FIntContentPostFetchThreshold) do
		if v82 == v76[i].postId then
			v92 = true
			g93 = true
		end

		if g93 then
			break
		end
	end

	if not g93 then
		v92 = false
	end

	g93 = false

	local v94 = v92

	for i = math.max(1, #v76 - (FIntContentPostFetchThreshold - 1)), #v76 do
		if v82 == v76[i].postId then
			v96 = true
			g97 = true
		end

		if g97 then
			break
		end
	end

	if not g97 then
		v96 = false
	end

	g97 = false

	local v98 = v96

	useEffect(function() -- line: 304
		-- upvalues: v94 (copy), v80 (copy), v72 (copy), RetrievePosts (copy), t4 (copy), SortOrderType (copy), v98 (copy), v81 (copy)
		if v94 and v80 then
			assert(v80 ~= nil, "nextTimeCursor should not be nil")
			v72(RetrievePosts(t4.creatorUserId, v80, SortOrderType.Ascending))
		end

		if v98 and v81 then
			assert(v81 ~= nil, "previousTimeCursor should not be nil")
			v72(RetrievePosts(t4.creatorUserId, v81, SortOrderType.Descending))
		end
	end, {
		v72,
		v94,
		v98,
		v80,
		v81,
		RetrievePosts
	})

	local v99 = React.useCallback(function() -- line: 318
		-- upvalues: v72 (copy), InspectClosed (copy)
		v72(InspectClosed())
	end, {
		v72,
		InspectClosed
	})
	local v100 = React.useCallback(function() -- line: 322
		-- upvalues: v89 (copy), FeedDirectionType (copy)
		v89(FeedDirectionType.Up)
	end, { v89 })
	local v101 = React.useCallback(function() -- line: 326
		-- upvalues: v89 (copy), FeedDirectionType (copy)
		v89(FeedDirectionType.Down)
	end, { v89 })
	local v102 = getIsPlaceholder(v82)
	local n5 = 0

	if v80 then
		n5 += 1
	end

	local v104 = n5 + if v77 ~= nil then v77 else 0
	local v105 = -v67.Y * v104 - v65.top
	local v106 = v41(v76, v80, v81, v77, t4.initialPostsCallFailed, v82)
	local v107 = math.min(v69.X, v69.Y * 0.5625)
	local v108 = v107 / 2 + v73.Padding.Medium

	return React.createElement(View, {
		tag = "bg-surface-0",
		onAbsoluteSizeChanged = function(p6) -- line: 353
			-- upvalues: v70 (copy)
			v70(p6.AbsoluteSize)
		end,
		Size = UDim2.new(1, 0, 0, v67.Y)
	}, {
		TopBar = React.createElement(FeedTopBar, {
			ZIndex = 3,
			creatorId = t4.creatorUserId,
			isPlaceholderPost = v102,
			postId = v82,
			removePostTransition = v90
		}),
		FeedContainer = React.createElement(View, {
			tag = "anchor-top-center bg-action-subtle position-top-center shrink size-0-full",
			Size = UDim2.new(0, v107, 1, 0)
		}, {
			ContentFeed = React.createElement(View, {
				LayoutOrder = 1,
				tag = "align-x-center bg-action-subtle col no-clip",
				Position = UDim2.fromOffset(0, v105),
				ref = v87,
				Size = UDim2.new(1, 0, 0, #v76 * v67.Y)
			}, v106)
		}),
		NavigationSidebar = if v66 ~= Responsive.Input.Pointer or not ((v108 + v73.Size.Size_1200) * 2 <= v69.X) then nil else React.createElement(NavigationSidebar, {
			isTerminalFinalPost = v85,
			isTerminalInitialPost = v84,
			position = UDim2.new(0.5, v108, 0.5, 0),
			onNavigateDown = v101,
			onNavigateUp = v100
		}),
		ShadowBlock = if not v79 then nil else React.createElement(View, {
			tag = "align-x-center bg-over-media-0 col items-center size-full-full",
			ZIndex = 3,
			onActivated = v99,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		})
	})
end
