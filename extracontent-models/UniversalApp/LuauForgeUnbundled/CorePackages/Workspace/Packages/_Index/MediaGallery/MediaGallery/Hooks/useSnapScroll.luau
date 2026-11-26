local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Otter")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/ReactOtter")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib").Signal

require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")

local function useSnapScroll(data)
	local state, setState = React.useState(data.targetIndex or 1)

	local ref = React.useRef(state)
	ref.current = state

	local v5, v6 = React.useBinding(Vector2.new(0, 0))
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)

	local v7 = React.useCallback(function(p2)
		if p2 == 1 then
			return Vector2.new(0, 0)
		end

		local v8 = v5:getValue().X + data.itemPadding
		return Vector2.new(v8, 0)
	end, { data.itemPadding })

	local v8, v9 = React.useBinding(v7(state))

	React.useEffect(function()
		if v5:getValue().X > 0 then
			v9(v7(state))
		end
	end, { v7, state })

	local ref5 = React.useRef(signal.new())

	local v10 = React.useCallback(function(p2, p3)
		if ref3.current then
			return
		end

		local value = v8:getValue()
		local v11 = v5:getValue().X + data.itemPadding
		local current = ref.current
		local v12, v13

		if p2 == "Right" then
			v12 = current + 1
			v13 = value + Vector2.new(v11, 0)
		else
			v12 = current - 1
			v13 = value - Vector2.new(v11, 0)
		end

		if v12 < 1 or data.itemCount < v12 then
			return
		end

		ref3.current = true
		ref5.current:fire(v12)

		if ref4.current then
			ref4.current:destroy()
		end

		local singleMotor = Otter.createSingleMotor(0)
		ref4.current = singleMotor

		singleMotor:onStep(function(p4)
			v9(value:Lerp(v13, p4))
		end)

		singleMotor:onComplete(function()
			ref3.current = false
			ref4.current = nil
			ref.current = v12
			setState(v12)

			if data.onScrollComplete then
				data.onScrollComplete(v12, p3)
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
		v8
	})

	local v11 = React.useCallback(function(p2)
		v6(p2.AbsoluteSize)

		if not ref3.current then
			v9(v7(ref.current))
		end
	end, { v7 })

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
		canvasPosition = v8,
		scrolledSignal = ref5.current,
		scrollingFrameRef = ref2,
		absoluteSizeBinding = v5,
		scrollInDirection = v10,
		onAbsoluteSizeChanged = v11
	}
end

return useSnapScroll
