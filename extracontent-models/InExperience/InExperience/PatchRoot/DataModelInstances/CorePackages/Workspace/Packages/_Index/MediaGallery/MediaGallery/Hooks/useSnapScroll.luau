local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)
require(parent.ReactOtter)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

require(MediaGallery.MediaGalleryTypes)

local function useSnapScroll(data)
	local state, setState = React.useState(data.targetIndex or 1)

	local ref = React.useRef(state)
	ref.current = state

	local absoluteSizeBinding, v = React.useBinding(Vector2.new(0, 0))
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)

	local v2 = React.useCallback(function(p: number)
		if p == 1 then
			return Vector2.new(0, 0)
		end

		local v2 = absoluteSizeBinding:getValue().X + data.itemPadding
		return Vector2.new(v2, 0)
	end, { data.itemPadding })

	local canvasPosition, v3 = React.useBinding(v2(state))

	React.useEffect(function()
		if absoluteSizeBinding:getValue().X > 0 then
			v3(v2(state))
		end
	end, { v2, state })

	local ref5 = React.useRef(Signal.new())

	local scrollInDirection = React.useCallback(function(p, flag: boolean?)
		if ref3.current then
			return
		end

		local value = canvasPosition:getValue()
		local v4 = absoluteSizeBinding:getValue().X + data.itemPadding
		local current = ref.current
		local current2, v5

		if p == "Right" then
			current2 = current + 1
			v5 = value + Vector2.new(v4, 0)
		else
			current2 = current - 1
			v5 = value - Vector2.new(v4, 0)
		end

		if current2 < 1 or data.itemCount < current2 then
			return
		end

		ref3.current = true
		ref5.current:fire(current2)

		if ref4.current then
			ref4.current:destroy()
		end

		local singleMotor = Otter.createSingleMotor(0)
		ref4.current = singleMotor

		singleMotor:onStep(function(p2: number)
			v3(value:Lerp(v5, p2))
		end)

		singleMotor:onComplete(function()
			ref3.current = false
			ref4.current = nil
			ref.current = current2
			setState(current2)

			if data.onScrollComplete then
				data.onScrollComplete(current2, flag)
			end
		end)

		if data.springConfig then
			singleMotor:setGoal(Otter.spring(1, data.springConfig))
		else
			singleMotor:setGoal(Otter.instant(1))
		end
	end, {
		data.itemCount,
		data.itemPadding,
		data.springConfig,
		data.onScrollComplete,
		canvasPosition
	})

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v(p.AbsoluteSize)

		if not ref3.current then
			v3(v2(ref.current))
		end
	end, { v2 })

	React.useEffect(function()
		setState(data.targetIndex or 1)
	end, { data.targetIndex })

	React.useEffect(function()
		return function()
			if ref4.current then
				ref4.current:destroy()
				ref4.current = nil
			end
		end
	end, {})

	return {
		currentIndex = state,
		canvasPosition = canvasPosition,
		scrolledSignal = ref5.current,
		scrollingFrameRef = ref2,
		absoluteSizeBinding = absoluteSizeBinding,
		scrollInDirection = scrollInDirection,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}
end

return useSnapScroll
