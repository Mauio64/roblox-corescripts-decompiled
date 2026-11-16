local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)
require(parent.ReactOtter)
require(parent.AppCommonLib)

local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)

local MAX_VISIBLE_INDICATORS = MediaGalleryConstants.MAX_VISIBLE_INDICATORS

local function getFirstVisibleIndex(numberOfItems: number, p: number, p2: string) -- 1 equivalent call inferred from this helper
	if numberOfItems <= MAX_VISIBLE_INDICATORS then
		return 1
	end

	if p2 == "Right" then
		return (math.max(1, math.min(p, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1))
	end

	return (math.min(numberOfItems - MAX_VISIBLE_INDICATORS + 1, math.max(p, 3) - 2))
end

local function useIndicatorScrollAnimation(data)
	local state, setState = React.useState(data.startIndex)
	local state2, setState2 = React.useState(data.startIndex)
	local state3, setState3 = React.useState(1)

	local canvasPositionBinding, v = React.useBinding(Vector2.new(0, 0))
	local state4, setState4 = React.useState(false)
	local animationProgressBinding, v2 = React.useBinding(0)

	local v3 = React.useCallback(function(p: number)
		return Vector2.new((p - 1) * (data.indicatorSize + data.indicatorPadding), 0)
	end, { data.indicatorSize, data.indicatorPadding })

	React.useEffect(function()
		local numberOfItems = data.numberOfItems
		local startIndex = data.startIndex
		local v4 = numberOfItems <= MAX_VISIBLE_INDICATORS and 1
			or math.max(1, math.min(startIndex, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1)

		v(v3(v4))
		setState3(v4)
		v2(1)
		setState2(data.startIndex)
		setState(data.startIndex)
	end, { data.numberOfItems, data.startIndex, v3 })

	React.useEffect(function()
		local scrolledSignalConnection = data.scrolledSignal:connect(function(p: number)
			setState(function(p2)
				local v4 = p2 < p and "Right" or "Left"
				setState2(p2)
				setState3(getFirstVisibleIndex(data.numberOfItems, p, v4)) -- inferred equivalent call
				setState4(true)
				return p
			end)
		end)

		return function()
			if scrolledSignalConnection ~= nil then
				scrolledSignalConnection:disconnect()
				scrolledSignalConnection = nil
			end
		end
	end, { data.numberOfItems, data.scrolledSignal })

	React.useEffect(function()
		if not state4 then
			return
		end

		local singleMotor = Otter.createSingleMotor(0)
		local v4

		if data.useSpring then
			v4 = Otter.spring(1, data.springConfig)
		else
			v4 = Otter.instant(1)
		end

		singleMotor:setGoal(v4)

		local value = canvasPositionBinding:getValue()
		local v5 = v3(state3)

		singleMotor:onStep(function(p: number)
			v2(p)
			v(value:Lerp(v5, p))
		end)

		singleMotor:onComplete(function()
			setState4(false)
		end)

		return function()
			singleMotor:destroy()
		end
	end, { data.useSpring, data.springConfig, state4, state3, v3 })

	return {
		currentItemIndex = state,
		previousItemIndex = state2,
		firstVisibleIndex = state3,
		animationProgressBinding = animationProgressBinding,
		canvasPositionBinding = canvasPositionBinding
	}
end

return useIndicatorScrollAnimation
