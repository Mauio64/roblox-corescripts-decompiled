local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)

local previewPopoverMath = require(script.Parent.previewPopoverMath)
require(script.Parent.Parent.Hooks.useMomentProgress)
local useVideoScrubPreview = require(script.Parent.useVideoScrubPreview)
local MomentContext = require(script.Parent.Parent.MomentContext)
local TimeLabel = require(script.Parent.TimeLabel)
local VideoPreview = require(script.Parent.VideoPreview)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useSignalState = SignalsReact.useSignalState

local SCRUB_FADE_SECONDS = MomentContext.SCRUB_FADE_SECONDS

local function PreviewPopover(p)
	local v = useTokens()
	local v2 = MomentContext.useMoment()
	local v3 = useScreenSize()
	local v4 = useDeviceInsets()
	local nextOrder = ReactUtils.createNextOrder()

	local controller = v2.controller
	local v5 = useSignalState(v2.store.getIsScrubbing)

	local preview = useVideoScrubPreview(React.useMemo(function()
		if controller == nil then
			return nil
		end

		return (controller.getVideoPreviewSource())
	end, { controller }), v5, v2.store.getScrubPosition)

	local state, setState = React.useState(false)
	React.useEffect(function()
		if v5 then
			setState(true)
			return
		end

		local v6 = false
		task.delay(SCRUB_FADE_SECONDS, function()
			if not v6 then
				setState(false)
			end
		end)
		return function()
			v6 = true
		end
	end, { v5 })

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v6, v7 = React.useBinding({ position = 0, width = 0 })

	local v8, v9 = React.useBinding(0)

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			v7({ position = current.AbsolutePosition.X, width = current.AbsoluteSize.X })
		end

		update() -- inferred equivalent call
		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		local current = ref2.current

		if current == nil then
			return
		end

		local function update() -- 1 equivalent call inferred from this helper
			v9(current.AbsoluteSize.X)
		end

		update() -- inferred equivalent call
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { state })

	local size_100 = v.Size.Size_100

	local mapped = React.joinBindings({ p.progressRatio, v6, v8 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]

		local centerOffsetX = previewPopoverMath.getCenterOffsetX({
			ratio = item,
			containerPosition = item2.position,
			containerWidth = item2.width,
			popoverWidth = item3,
			screenWidth = v3.X,
			insetLeft = v4.left,
			insetRight = v4.right,
			margin = size_100
		})

		return UDim2.new(0, centerOffsetX, 0, -v.Size.Size_600)
	end)

	local createElement = React.createElement
	local movingContainer

	if state then
		local createElement2 = React.createElement
		local videoPreview

		if not (controller == nil or not controller.getHasVideoPreview()) then
			videoPreview = React.createElement(VideoPreview, {
				preview = preview,
				animationRatio = v2.animationRatio,
				LayoutOrder = nextOrder()
			})
		end

		movingContainer = createElement2(
			View,
			{
				tag = "col align-x-center gap-medium anchor-bottom-center auto-xy",
				ref = ref2,
				Position = mapped
			},
			{
				VideoPreview = videoPreview,
				TimeLabel = React.createElement(TimeLabel, {
					progress = p.progress,
					animationRatio = v2.animationRatio,
					LayoutOrder = nextOrder()
				})
			}
		)
	end

	return createElement(View, { tag = "size-full", ref = ref }, {
		MovingContainer = movingContainer
	})
end

return React.memo(PreviewPopover)
