local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Otter")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/ReactOtter")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib")

local MAX_VISIBLE_INDICATORS = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants").MAX_VISIBLE_INDICATORS

local function getFirstVisibleIndex(p2, p3, p4)
	if p2 <= MAX_VISIBLE_INDICATORS then
		return 1
	end

	if p4 == "Right" then
		return (math.max(1, math.min(p3, p2 - 2) - MAX_VISIBLE_INDICATORS + 2 + 1))
	end

	return (math.min(p2 - MAX_VISIBLE_INDICATORS + 1, math.max(p3, 3) - 2))
end

local function useIndicatorScrollAnimation(data)
	local state, setState = React.useState(data.startIndex)
	local state2, setState2 = React.useState(data.startIndex)
	local state3, setState3 = React.useState(1)

	local v5, v6 = React.useBinding(Vector2.new(0, 0))
	local state4, setState4 = React.useState(false)
	local v7, v8 = React.useBinding(0)

	local v9 = React.useCallback(function(p2)
		return Vector2.new((p2 - 1) * (data.indicatorSize + data.indicatorPadding), 0)
	end, { data.indicatorSize, data.indicatorPadding })

	React.useEffect(function()
		local numberOfItems = data.numberOfItems
		local startIndex = data.startIndex
		local v10 = numberOfItems <= MAX_VISIBLE_INDICATORS and 1
			or math.max(1, math.min(startIndex, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1)

		v6(v9(v10))
		setState3(v10)
		v8(1)
		setState2(data.startIndex)
		setState(data.startIndex)
	end, { data.numberOfItems, data.startIndex, v9 })

	React.useEffect(function()
		local scrolledSignalConnection = data.scrolledSignal:connect(function(p2)
			setState(function(p3)
				local v10 = p3 < p2 and "Right" or "Left"
				setState2(p3)
				local numberOfItems = data.numberOfItems
				local v12 = p2
				local v13

				if numberOfItems <= MAX_VISIBLE_INDICATORS then
					v13 = 1
				elseif v10 == "Right" then
					v13 = math.max(1, math.min(v12, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1)
				else
					v13 = math.min(numberOfItems - MAX_VISIBLE_INDICATORS + 1, math.max(v12, 3) - 2)
				end

				setState3(v13)
				setState4(true)
				return p2
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
		local v10 = if data.useSpring then Otter.spring(1, data.springConfig) else Otter.instant(1)
		singleMotor:setGoal(v10)

		local value = v5:getValue()
		local v11 = v9(state3)

		singleMotor:onStep(function(p2)
			v8(p2)
			v6(value:Lerp(v11, p2))
		end)

		singleMotor:onComplete(function()
			setState4(false)
		end)

		return function()
			singleMotor:destroy()
		end
	end, { data.useSpring, data.springConfig, state4, state3, v9 })

	return {
		currentItemIndex = state,
		previousItemIndex = state2,
		firstVisibleIndex = state3,
		animationProgressBinding = v7,
		canvasPositionBinding = v5
	}
end

return useIndicatorScrollAnimation
