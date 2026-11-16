local module = require("@luauforge/deferred/dUv")
local module2 = require("@luauforge/deferred/dWM")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module5 = require("@luauforge/deferred/dWN")
local module6 = require("@luauforge/deferred/dVP")
local module7 = require("@luauforge/deferred/dWO")

local module8 = require("@luauforge/deferred/dWP")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local module10 = require("@luauforge/deferred/dWS")
local module11 = require("@luauforge/deferred/dWT")
local module12 = require("@luauforge/deferred/dXA")
local module13 = require("@luauforge/deferred/dXd")
local module14 = require("@luauforge/deferred/dXB")
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local module15 = require("@luauforge/deferred/dXF")
local module16 = require("@luauforge/deferred/dXG")
local module17 = require("@luauforge/deferred/dXI")
local module18 = require("@luauforge/deferred/dWh")
local module19 = require("@luauforge/deferred/dXJ")
require("@luauforge/deferred/dXK")
local module20 = require("@luauforge/deferred/dXH")
local module21 = require("@luauforge/deferred/dXL")
local module22 = require("@luauforge/deferred/dXN")
require("@luauforge/deferred/dXw")
local view = module2.View

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnce = module6.Hooks.useEffectOnce
local module24 = require("@luauforge/deferred/dXO")
local useGuiInset = module.Hooks.useGuiInset
local usePreferredInput = module5.usePreferredInput
local useScreenSize = module7.useScreenSize
local useSelector = module6.Hooks.RoactRodux.useSelector
local useState = React.useState
local useTokens = module2.Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("ContentFeedCloseInspectOnOpen", false)
local module25 = require("@luauforge/deferred/dXR")
local module26 = require("@luauforge/deferred/dXS")

local function fn(list, p2, p3, state, initialPostsCallFailed, p4)
	local children = {}

	if initialPostsCallFailed then
		children[module20.PostsNotFound] = React.createElement(module13, {
			layoutOrder = 1
		})

		return children
	end

	if #list == 0 or state == nil then
		children[module20.PostsNotLoaded] = React.createElement(module12, {
			layoutOrder = 1
		})

		return children
	end

	if p2 then
		children[module20.NextPostsLoading] = React.createElement(module12, {
			layoutOrder = 0
		})
	end

	for i = 1, #list do
		local item = list[i]
		children[item.postId] = React.createElement(module11, {
			additionalInfo = item.additionalInfo,
			assetId = item.assetId,
			caption = item.caption,
			creatorUserId = item.creatorUserId,
			currentPostId = p4,
			layoutOrder = i,
			placeId = item.experienceContext.placeId,
			postId = item.postId,
			screenshotMetadata = item.screenshotMetadata,
			universeId = item.experienceContext.experienceId,
			type = item.type,
			uploadedAtTimestamp = item.uploadedAtTimestamp
		})
	end

	if p3 then
		children[module20.PreviousPostsLoading] = React.createElement(module12, {
			layoutOrder = #list + 1
		})
	end

	return children
end

local function fn2(p2, top)
	local v5 = module15(p2)

	for k, v6 in pairs(v5) do
		local name = v6.Name

		if math.abs(v6.AbsolutePosition.Y + top) < 5 then
			return name
		end
	end

	return nil
end

return function(props)
	local v5 = useGuiInset()
	local v6 = usePreferredInput()
	local v7 = useScreenSize()

	local v8 = React.useContext(CapturesContext)
	local state, setState = useState(v7)

	local v9 = useAnalytics()
	local v10 = useDispatch()
	local v11 = useTokens()

	local state2, setState2 = useState({})

	local v12 = useSelector(function(p2)
		local v13 = getDeepValue(p2, "ContentSharing.byUserId." .. props.creatorUserId .. ".posts") or {}
		local result = {}

		for k, v14 in pairs(v13) do
			if not table.find(state2, v14.postId) then
				table.insert(result, v14)
			end
		end

		return result
	end)

	local state3, setState3 = useState(nil)

	local v13 = useSelector(function(p2)
		return p2.ContentFeed.Inspect.IsOpen
	end)

	if defineFastFlag then
		useEffectOnce(function()
			if v13 then
				v10(module18())
			end
		end, {})
	end

	useEffect(function()
		local v14 = module17(v12, props.initialPostId)

		if #v12 == 0 or v14 == nil then
			return
		end

		setState3(v14 - 1)
	end, { v12, props.initialPostId })

	local v14 = useSelector(function(p2)
		return getDeepValue(p2, "ContentSharing.byUserId." .. props.creatorUserId .. ".nextTimeCursor")
	end)

	local v15 = useSelector(function(p2)
		return getDeepValue(p2, "ContentSharing.byUserId." .. props.creatorUserId .. ".previousTimeCursor")
	end)

	local v17 = if #v12 == 0 then module20.PostsNotLoaded else props.initialPostId
	local v18, v19 = useState(v17)

	local v20 = #v12 == 0
		or v14 ~= nil and v18 == module20.NextPostsLoading
		or v14 == nil and v18 == v12[1].postId
		or v18 == module20.PostsNotLoaded
		or v18 == module20.PostsNotFound
	local v21 = #v12 == 0
		or v15 ~= nil and v18 == module20.PreviousPostsLoading
		or v15 == nil and v18 == v12[#v12].postId
		or v18 == module20.PostsNotLoaded
		or v18 == module20.PostsNotFound
	local v22, v23, v24 = module24(v20, v21, #v12, v13)

	useEffect(function()
		v9.fireEvent(module8.ContentFeedPostViewed, { postId = v18 })
	end, { v9.fireEvent, v18 })

	useEffect(function()
		if v8.isZooming and math.random() < 1 / module25 then
			v9.fireEvent(module8.ContentFeedZoomOccurred, { postId = v18 })
		end
	end, { v9.fireEvent, v18, v8.isZooming })

	useEffect(function()
		local v25 = fn2(v22, v5.top)

		if v25 then
			v19(v25)
		end
	end, { v12, v5.top })

	local v25 = React.useCallback(function()
		local v26 = fn2(v22, v5.top)

		if v26 then
			v19(v26)
		end

		local v27 = {}

		for k, v28 in pairs(state2) do
			table.insert(v27, v28)
		end

		table.insert(v27, v18)

		if #v12 == 1 then
			v8.navigateBack(true)
		elseif v18 ~= v12[1].postId then
			v24(module10.Up)
			task.wait(0.1)
		end

		setState2(v27)
	end, { v12, v8.navigateBack, v5.top, v23, state2, state3, v24 })

	useEffect(function()
		local connection = v23:connect(function(p2)
			local v26 = fn2(v22, v5.top)

			if v26 then
				v19(v26)
			end
		end)

		return function()
			connection:disconnect()
		end
	end, { v12, v18, v5.top, v23, v14, v15 })
	local flag = true
	local v26

	for i = 1, math.min(#v12, module26) do
		if v12[i].postId == v18 then
			v26 = true
			flag = false
			break
		end
	end

	if flag then
		v26 = false
	end

	local flag2 = true
	local v27

	for i = math.max(1, #v12 - (module26 - 1)), #v12 do
		if v12[i].postId == v18 then
			v27 = true
			flag2 = false
			break
		end
	end

	if flag2 then
		v27 = false
	end

	useEffect(function()
		if v26 and v14 then
			assert(v14 ~= nil, "nextTimeCursor should not be nil")
			v10(module21(props.creatorUserId, v14, module22.Ascending))
		end

		if v27 and v15 then
			assert(v15 ~= nil, "previousTimeCursor should not be nil")
			v10(module21(props.creatorUserId, v15, module22.Descending))
		end
	end, { v10, v26, v27, v14, v15, module21 })

	local v29 = React.useCallback(function()
		v10(module18())
	end, { v10, module18 })

	local v30 = React.useCallback(function()
		v24(module10.Up)
	end, { v24 })

	local v31 = React.useCallback(function()
		v24(module10.Down)
	end, { v24 })

	local v32 = module16(v18)

	local count = 0

	if v14 then
		count += 1
	end

	local v33 = count + (state3 == nil and 0 or state3)
	local v34 = -v7.Y * v33 - v5.top

	local v35 = fn(v12, v14, v15, state3, props.initialPostsCallFailed, v18)

	local v36 = math.min(state.X, state.Y * 0.5625)
	local v37 = v36 / 2 + v11.Padding.Medium

	local createElement = React.createElement
	local v39 = {
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize)
		end,
		Size = UDim2.new(1, 0, 0, v7.Y),
		tag = "bg-surface-0"
	}

	local v40 = {
		TopBar = React.createElement(module14, {
			creatorId = props.creatorUserId,
			isPlaceholderPost = v32,
			postId = v18,
			removePostTransition = v25,
			ZIndex = 3
		}),
		FeedContainer = React.createElement(
			view,
			{
				Size = UDim2.new(0, v36, 1, 0),
				tag = "anchor-top-center bg-action-subtle position-top-center shrink size-0-full"
			},
			{
				ContentFeed = React.createElement(view, {
					LayoutOrder = 1,
					Position = UDim2.fromOffset(0, v34),
					ref = v22,
					Size = UDim2.new(1, 0, 0, #v12 * v7.Y),
					tag = "align-x-center bg-action-subtle col no-clip"
				}, v35)
			}
		),
		NavigationSidebar = 0,
		ShadowBlock = 0
	}

	local v41 = if v6 == module5.Input.Pointer and (v37 + v11.Size.Size_1200) * 2 <= state.X then React.createElement(module19, {
		isTerminalFinalPost = v21,
		isTerminalInitialPost = v20,
		position = UDim2.new(0.5, v37, 0.5, 0),
		onNavigateDown = v31,
		onNavigateUp = v30
	}) else nil
	v40.NavigationSidebar = v41

	local v42 = if v13 then React.createElement(view, {
		onActivated = v29,
		stateLayer = { affordance = module2.Enums.StateLayerAffordance.None },
		tag = "align-x-center bg-over-media-0 col items-center size-full-full",
		ZIndex = 3
	}) else nil
	v40.ShadowBlock = v42
	return createElement(view, v39, v40)
end
