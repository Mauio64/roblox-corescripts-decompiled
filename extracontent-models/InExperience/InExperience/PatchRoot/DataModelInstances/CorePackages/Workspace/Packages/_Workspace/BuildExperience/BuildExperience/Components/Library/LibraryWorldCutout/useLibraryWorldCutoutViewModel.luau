local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)

local WorldCutoutTransition = require(script.Parent.WorldCutoutTransition)
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function toRect(current) -- 2 equivalent calls inferred from this helper
	if current == nil or current.AbsoluteSize.X <= 1 or current.AbsoluteSize.Y <= 1 then
		return nil
	end

	return Rect.new(current.AbsolutePosition, current.AbsolutePosition + current.AbsoluteSize)
end

local function toUnscrolledRect(current, rect: Rect) -- 1 equivalent call inferred from this helper
	local scrollingFrame = current:FindFirstAncestorWhichIsA("ScrollingFrame")

	if scrollingFrame == nil then
		return rect
	end

	return Rect.new(rect.Min + scrollingFrame.CanvasPosition, rect.Max + scrollingFrame.CanvasPosition)
end

local function useLibraryWorldCutoutViewModel(current)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion or UserGameSettings.ReducedMotion
	local ref = React.useRef(WorldCutoutTransition.initialState)
	local state, setState = React.useState(ref.current.phase)
	local state2, setState2 = React.useState(false)
	local cell, v = React.useBinding(nil)
	local content, v2 = React.useBinding(nil)
	local v3, current3 = Motion.useMotion({ progress = 0 })
	local progress = v3.progress
	local ref2 = React.useRef(current3)
	ref2.current = current3
	local ref3 = React.useRef(current)
	ref3.current = current
	local current4 = current.isAvailable and current.isHome and current.isOpen and state == "Home"
	local ref4 = React.useRef(current4)
	ref4.current = current4

	local v4 = React.useCallback(function(p)
		local current2 = ref.current
		ref.current = WorldCutoutTransition.reduce(current2, p)

		if ref.current.phase ~= current2.phase then
			setState(ref.current.phase)
		end

		return ref.current
	end, {})

	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(nil)
	local v5 = React.useCallback(function()
		local rect = toRect(ref7.current) -- inferred equivalent call

		if rect ~= nil then
			v2(rect)
		end

		local current2 = ref5.current
		local current5 = toRect(current2) -- inferred equivalent call

		if current2 == nil or current5 == nil then
			return
		end

		v(current5)
		setState2(true)
		current5 = toUnscrolledRect(current2, current5) -- inferred equivalent call
		ref6.current = current5

		if ref4.current then
			ref3.current.onViewportRectChanged(ref6.current)
		end
	end, { v, v2 })
	local v6 = React.useCallback(function()
		v5()

		if ref8.current == nil then
			ref8.current = task.defer(function()
				ref8.current = nil
				v5()
			end)
		end
	end, { v5 })
	React.useEffect(function()
		return function()
			if ref8.current ~= nil then
				task.cancel(ref8.current)
				ref8.current = nil
			end
		end
	end, {})

	local onCellRectChanged = React.useCallback(function(current2)
		ref5.current = current2
		v6()
	end, { v6 })

	local onContentRectChanged = React.useCallback(function(current2)
		ref7.current = current2
		v6()
	end, { v6 })

	local enter = React.useCallback(function(): boolean
		local current2 = ref3.current
		local phase = ref.current.phase

		if
			not current2.isAvailable
			or not current2.isHome
			or not current2.isOpen
			or phase ~= "Home" and phase ~= "Collapsing"
		then
			return false
		end

		v4({ type = "Expand" })
		return true
	end, { v4 })

	local exit = React.useCallback(function(): boolean
		local phase = ref.current.phase

		if phase ~= "World" and phase ~= "Expanding" then
			return false
		end

		v4({ type = "Collapse" })
		return true
	end, { v4 })

	React.useEffect(function()
		if current4 then
			local current2 = ref6.current

			if current2 ~= nil then
				current.onViewportRectChanged(current2)
			end
		elseif current.isAvailable and current.isOpen and state == "Home" then
			current.onViewportRectChanged(nil)
		end
	end, {
		current4,
		state,
		current.isAvailable,
		current.isOpen,
		current.onViewportRectChanged,
		cell
	})

	React.useEffect(function()
		if
			state ~= "Home"
			and (not current.isAvailable or not current.isHome or state == "World" and current.isOpen)
		then
			v4({ type = "Reset" })
		end
	end, { state, current.isAvailable, current.isHome, current.isOpen, v4 })

	React.useEffect(function()
		local transitioning = WorldCutoutTransition.isTransitioning(state)
		local v7 = false
		local heartbeatConnection

		if transitioning then
			heartbeatConnection = RunService.Heartbeat:Connect(function()
				local v8 = v4({ type = "Progress", progress = progress:getValue() })
				local value = cell:getValue()
				local value2 = content:getValue()

				if WorldCutoutTransition.isTransitioning(v8.phase) and value ~= nil and value2 ~= nil then
					ref3.current.onViewportRectChanged(WorldCutoutTransition.interpolateRect(value, value2, v8.progress))
				end
			end)
		else
			heartbeatConnection = nil
		end

		ref2.current(Motion.createState({
			progress = WorldCutoutTransition.getTarget(state)
		}, {
			default = Motion.transition({
				duration = (reducedMotion or not transitioning) and 0 or 0.3,
				easingStyle = Enum.EasingStyle.Quad
			})
		}), {
			onAnimationComplete = function(p)
				if p == true and not v7 and ref.current.phase == state then
					v4({ type = "Settle" })
				end
			end
		})

		return function()
			v7 = true

			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
			end
		end
	end, { state, reducedMotion, progress, cell, content, v4 })

	local hole = React.useMemo(function()
		return React.joinBindings({ progress = progress, cell = cell, content = content }):map(function(data)
			if data.cell == nil or data.content == nil then
				return nil
			end

			local interpolateRect = WorldCutoutTransition.interpolateRect(data.cell, data.content, data.progress)
			local min = data.content.Min
			return Rect.new(interpolateRect.Min - min, interpolateRect.Max - min)
		end)
	end, { progress, cell, content })

	local transitioning = WorldCutoutTransition.isTransitioning(state)
	return {
		phase = state,
		isMeasured = state2,
		enter = enter,
		exit = exit,
		onCellRectChanged = onCellRectChanged,
		view = current.isAvailable and {
			isTransitioning = transitioning,
			showHole = transitioning or current.isHome and state == "Home",
			progress = progress,
			hole = hole,
			onContentRectChanged = onContentRectChanged
		} or nil
	}
end

return useLibraryWorldCutoutViewModel
