local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ReactUtils = require(Parent.ReactUtils)
local SignalsReact = require(Parent.SignalsReact)
local MomentsCommon = require(Parent.MomentsCommon)
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

local function PreviewPopover(t1: {[any]: any}) -- line: 37
	-- upvalues: useTokens (copy), MomentContext (copy), useScreenSize (copy), useDeviceInsets (copy), ReactUtils (copy), useSignalState (copy), React (copy), useVideoScrubPreview (copy), SCRUB_FADE_SECONDS (copy), previewPopoverMath (copy), View (copy), VideoPreview (copy), TimeLabel (copy)
	local v20 = useTokens()
	local v21 = MomentContext.useMoment()
	local v22 = useScreenSize()
	local v23 = useDeviceInsets()
	local v24 = ReactUtils.createNextOrder()
	local controller = v21.controller
	local v26 = useSignalState(v21.store.getIsScrubbing)
	local v27 = React.useMemo(function() -- line: 47
		-- upvalues: controller (copy)
		if controller ~= nil then
			return (controller.getVideoPreviewSource())
		end

		return nil
	end, { controller })
	local v28 = useVideoScrubPreview(v27, v26, v21.store.getScrubPosition)
	local v29, v30 = React.useState(false)

	React.useEffect(function() -- line: 55
		-- upvalues: v26 (copy), v30 (copy), SCRUB_FADE_SECONDS (copy)
		if v26 then
			v30(true)

			return
		end

		local u39 = false

		task.delay(SCRUB_FADE_SECONDS, function() -- line: 61
			-- upvalues: u39 (ref), v30 (copy)
			if not u39 then
				v30(false)
			end
		end)

		return function() -- line: 66
			-- upvalues: u39 (ref)
			u39 = true
		end
	end, { v26 })

	local v31 = React.useRef(nil)
	local v32 = React.useRef(nil)
	local v33, v34 = React.useBinding({
		position = 0,
		width = 0
	})
	local v35, v36 = React.useBinding(0)

	React.useEffect(function() -- line: 80
		-- upvalues: v31 (copy), v34 (copy)
		local current = v31.current

		if current == nil then
			return
		end

		local function update() -- line: 86
			-- upvalues: v34 (copy), current (copy)
			v34({
				position = current.AbsolutePosition.X,
				width = current.AbsoluteSize.X
			})
		end

		v34({
			position = current.AbsolutePosition.X,
			width = current.AbsoluteSize.X
		})

		local connection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
		local connection2 = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function() -- line: 96
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 104
		-- upvalues: v32 (copy), v36 (copy)
		local current = v32.current

		if current == nil then
			return
		end

		local function update() -- line: 110
			-- upvalues: v36 (copy), current (copy)
			v36(current.AbsoluteSize.X)
		end

		v36(current.AbsoluteSize.X)

		local connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function() -- line: 116
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v29 })

	local Size_100 = v20.Size.Size_100
	local v38 = React.joinBindings({
		t1.progressRatio,
		v33,
		v35
	}):map(function(t2: {[any]: any}) -- line: 124
		-- upvalues: previewPopoverMath (copy), v22 (copy), v23 (copy), Size_100 (copy), v20 (copy)
		local v48 = t2[1]
		local v49 = t2[2]
		local v50 = t2[3]
		local v51 = previewPopoverMath.getCenterOffsetX({
			ratio = v48,
			containerPosition = v49.position,
			containerWidth = v49.width,
			popoverWidth = v50,
			screenWidth = v22.X,
			insetLeft = v23.left,
			insetRight = v23.right,
			margin = Size_100
		})

		return UDim2.new(0, v51, 0, -v20.Size.Size_600)
	end)

	return React.createElement(View, {
		tag = "size-full",
		ref = v31
	}, {
		MovingContainer = if not v29 then nil else React.createElement(View, {
			tag = "col align-x-center gap-medium anchor-bottom-center auto-xy",
			ref = v32,
			Position = v38
		}, {
			VideoPreview = if controller == nil or not controller.getHasVideoPreview() then nil else React.createElement(VideoPreview, {
				preview = v28,
				animationRatio = v21.animationRatio,
				LayoutOrder = v24()
			}),
			TimeLabel = React.createElement(TimeLabel, {
				progress = t1.progress,
				animationRatio = v21.animationRatio,
				LayoutOrder = v24()
			})
		})
	})
end

return React.memo(PreviewPopover)
