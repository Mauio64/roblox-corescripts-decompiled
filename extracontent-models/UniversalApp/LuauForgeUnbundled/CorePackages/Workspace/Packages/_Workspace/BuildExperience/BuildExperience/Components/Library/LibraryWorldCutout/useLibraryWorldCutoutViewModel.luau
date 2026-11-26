local RunService = game:GetService("RunService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local WorldCutoutTransition = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryWorldCutout/WorldCutoutTransition")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function toRect(p2)
	if p2 == nil or p2.AbsoluteSize.X <= 1 or p2.AbsoluteSize.Y <= 1 then
		return nil
	end

	return Rect.new(p2.AbsolutePosition, p2.AbsolutePosition + p2.AbsoluteSize)
end

local function toUnscrolledRect(instance, p2)
	local scrollingFrame = instance:FindFirstAncestorWhichIsA("ScrollingFrame")

	if scrollingFrame == nil then
		return p2
	end

	return Rect.new(p2.Min + scrollingFrame.CanvasPosition, p2.Max + scrollingFrame.CanvasPosition)
end

local function useLibraryWorldCutoutViewModel(current)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion or UserGameSettings.ReducedMotion
	local ref = React.useRef(WorldCutoutTransition.initialState)
	local state, setState = React.useState(ref.current.phase)
	local state2, setState2 = React.useState(false)
	local v5, v6 = React.useBinding(nil)
	local v7, v8 = React.useBinding(nil)
	local v9, v10 = Motion.useMotion({ progress = 0 })
	local progress = v9.progress
	local ref2 = React.useRef(v10)
	ref2.current = v10
	local ref3 = React.useRef(current)
	ref3.current = current
	local v11 = current.isAvailable and current.isHome and current.isOpen and state == "Home"
	local ref4 = React.useRef(v11)
	ref4.current = v11

	local v12 = React.useCallback(function(p2)
		local current2 = ref.current
		ref.current = WorldCutoutTransition.reduce(current2, p2)

		if ref.current.phase ~= current2.phase then
			setState(ref.current.phase)
		end

		return ref.current
	end, {})

	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(nil)
	local v13 = React.useCallback(function()
		local current2 = ref7.current
		local rect

		if not (current2 == nil or current2.AbsoluteSize.X <= 1 or current2.AbsoluteSize.Y <= 1) then
			rect = Rect.new(current2.AbsolutePosition, current2.AbsolutePosition + current2.AbsoluteSize)
		end

		if rect ~= nil then
			v8(rect)
		end

		local current3 = ref5.current
		local rect2

		if not (current3 == nil or current3.AbsoluteSize.X <= 1 or current3.AbsoluteSize.Y <= 1) then
			rect2 = Rect.new(current3.AbsolutePosition, current3.AbsolutePosition + current3.AbsoluteSize)
		end

		if current3 == nil or rect2 == nil then
			return
		end

		v6(rect2)
		setState2(true)
		local v14 = ref6
		local scrollingFrame = current3:FindFirstAncestorWhichIsA("ScrollingFrame")

		if scrollingFrame ~= nil then
			rect2 = Rect.new(
				rect2.Min + scrollingFrame.CanvasPosition,
				rect2.Max + scrollingFrame.CanvasPosition
			)
		end

		v14.current = rect2

		if ref4.current then
			ref3.current.onViewportRectChanged(ref6.current)
		end
	end, { v6, v8 })
	local v14 = React.useCallback(function()
		v13()

		if ref8.current == nil then
			ref8.current = task.defer(function()
				ref8.current = nil
				v13()
			end)
		end
	end, { v13 })
	React.useEffect(function()
		return function()
			if ref8.current ~= nil then
				task.cancel(ref8.current)
				ref8.current = nil
			end
		end
	end, {})

	local v15 = React.useCallback(function(current2)
		ref5.current = current2
		v14()
	end, { v14 })

	local v16 = React.useCallback(function(current2)
		ref7.current = current2
		v14()
	end, { v14 })

	local v17 = React.useCallback(function(): boolean
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

		v12({ type = "Expand" })
		return true
	end, { v12 })

	local v18 = React.useCallback(function(): boolean
		local phase = ref.current.phase

		if phase ~= "World" and phase ~= "Expanding" then
			return false
		end

		v12({ type = "Collapse" })
		return true
	end, { v12 })

	React.useEffect(function()
		if v11 then
			local current2 = ref6.current

			if current2 ~= nil then
				current.onViewportRectChanged(current2)
			end
		elseif current.isAvailable and current.isOpen and state == "Home" then
			current.onViewportRectChanged(nil)
		end
	end, {
		v11,
		state,
		current.isAvailable,
		current.isOpen,
		current.onViewportRectChanged,
		v5
	})

	React.useEffect(function()
		if
			state ~= "Home"
			and (not current.isAvailable or not current.isHome or state == "World" and current.isOpen)
		then
			v12({ type = "Reset" })
		end
	end, { state, current.isAvailable, current.isHome, current.isOpen, v12 })

	React.useEffect(function()
		local transitioning = WorldCutoutTransition.isTransitioning(state)
		local v19 = false
		local heartbeatConnection

		if transitioning then
			heartbeatConnection = RunService.Heartbeat:Connect(function()
				local v20 = v12({ type = "Progress", progress = progress:getValue() })
				local value = v5:getValue()
				local value2 = v7:getValue()

				if WorldCutoutTransition.isTransitioning(v20.phase) and value ~= nil and value2 ~= nil then
					ref3.current.onViewportRectChanged(WorldCutoutTransition.interpolateRect(value, value2, v20.progress))
				end
			end)
		else
			heartbeatConnection = nil
		end

		ref2.current(Motion.createState({ progress = WorldCutoutTransition.getTarget(state) }, {
			default = Motion.transition({
				duration = (reducedMotion or not transitioning) and 0 or 0.3,
				easingStyle = Enum.EasingStyle.Quad
			})
		}), {
			onAnimationComplete = function(p2)
				if p2 == true and not v19 and ref.current.phase == state then
					v12({ type = "Settle" })
				end
			end
		})

		return function()
			v19 = true

			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
			end
		end
	end, { state, reducedMotion, progress, v5, v7, v12 })

	local v19 = React.useMemo(function()
		return React.joinBindings({ progress = progress, cell = v5, content = v7 }):map(function(data)
			if data.cell == nil or data.content == nil then
				return nil
			end

			local interpolateRect = WorldCutoutTransition.interpolateRect(data.cell, data.content, data.progress)
			local min = data.content.Min
			return Rect.new(interpolateRect.Min - min, interpolateRect.Max - min)
		end)
	end, { progress, v5, v7 })

	local transitioning = WorldCutoutTransition.isTransitioning(state)
	return {
		phase = state,
		isMeasured = state2,
		enter = v17,
		exit = v18,
		onCellRectChanged = v15,
		view = current.isAvailable and {
			isTransitioning = transitioning,
			showHole = transitioning or current.isHome and state == "Home",
			progress = progress,
			hole = v19,
			onContentRectChanged = v16
		} or nil
	}
end

return useLibraryWorldCutoutViewModel
