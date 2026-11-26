local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local previewPopoverMath = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/previewPopoverMath")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Hooks/useMomentProgress")
local useVideoScrubPreview = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/useVideoScrubPreview")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/TimeLabel")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/VideoPreview")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useSignalState = SignalsReact.useSignalState

local SCRUB_FADE_SECONDS = MomentContext.SCRUB_FADE_SECONDS

local function PreviewPopover(p2)
	local v5 = useTokens()
	local v6 = MomentContext.useMoment()
	local v7 = useScreenSize()
	local v8 = useDeviceInsets()
	local nextOrder = ReactUtils.createNextOrder()

	local controller = v6.controller
	local v9 = useSignalState(v6.store.getIsScrubbing)

	local v11 = useVideoScrubPreview(React.useMemo(function()
		if controller == nil then
			return nil
		end

		return (controller.getVideoPreviewSource())
	end, { controller }), v9, v6.store.getScrubPosition)

	local state, setState = React.useState(false)
	React.useEffect(function()
		if v9 then
			setState(true)
			return
		end

		local v12 = false
		task.delay(SCRUB_FADE_SECONDS, function()
			if not v12 then
				setState(false)
			end
		end)
		return function()
			v12 = true
		end
	end, { v9 })

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v12, v13 = React.useBinding({ position = 0, width = 0 })

	local v14, v15 = React.useBinding(0)

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local function update()
			v13({
				position = current.AbsolutePosition.X,
				width = current.AbsoluteSize.X
			})
		end

		v13({ position = current.AbsolutePosition.X, width = current.AbsoluteSize.X })

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

		local function update()
			v15(current.AbsoluteSize.X)
		end

		v15(current.AbsoluteSize.X)

		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { state })

	local size_100 = v5.Size.Size_100

	local mapped = React.joinBindings({ p2.progressRatio, v12, v14 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]

		local centerOffsetX = previewPopoverMath.getCenterOffsetX({
			ratio = item,
			containerPosition = item2.position,
			containerWidth = item2.width,
			popoverWidth = item3,
			screenWidth = v7.X,
			insetLeft = v8.left,
			insetRight = v8.right,
			margin = size_100
		})

		return UDim2.new(0, centerOffsetX, 0, -v5.Size.Size_600)
	end)

	local createElement = React.createElement
	local v19

	if state then
		local createElement2 = React.createElement

		local v23 = if controller ~= nil and not not controller.getHasVideoPreview() then React.createElement(module10, {
			preview = v11,
			animationRatio = v6.animationRatio,
			LayoutOrder = nextOrder()
		}) else nil
		v19 = createElement2(
			view,
			{
				tag = "col align-x-center gap-medium anchor-bottom-center auto-xy",
				ref = ref2,
				Position = mapped
			},
			{
				VideoPreview = v23,
				TimeLabel = React.createElement(module9, {
					progress = p2.progress,
					animationRatio = v6.animationRatio,
					LayoutOrder = nextOrder()
				})
			}
		)
	end

	return createElement(view, { tag = "size-full", ref = ref }, {
		MovingContainer = v19
	})
end

return React.memo(PreviewPopover)
