local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/deferred/dXS")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module3 = require("@luauforge/deferred/eaV")
local module4 = require("@luauforge/deferred/eal")
local module5 = require("@luauforge/deferred/eaW")

local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")

local useAnimatedBinding = module3.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = module5.useEventConnection
local useGuiInset = module.Hooks.useGuiInset
local useRef = React.useRef
local useScreenSize = module4.useScreenSize
local useState = React.useState

local function useFeedZoomController(p2, p3, p4, p5)
	local v5 = React.useContext(CapturesContext)
	local v6 = useGuiInset()
	local v7 = useScreenSize()

	local isZooming = v5.isZooming
	local setIsZooming = v5.setIsZooming

	local v8 = useRef(nil)
	local v9 = useRef(nil)
	local v10 = useRef(1)
	local v11 = useRef(false)
	local v12 = useRef(Vector2.new(0, 0))
	local state, setState = useState(false)

	local v13, v14 = useAnimatedBinding(0)
	local v15, v16 = useAnimatedBinding(0)

	useEffect(function()
		if not state then
			v8.current = nil
		end
	end, { state })

	useEffect(function()
		if not p2 or p5 then
			return
		end

		if isZooming then
			v14(module3.spring(1, { frequency = 4, dampingRatio = 1 }))
		else
			v14(module3.spring(0, { frequency = 4, dampingRatio = 1 }))
		end
	end, { p2, isZooming, v14 })

	local v17 = useCallback(function()
		if not p2 then
			return
		end

		setState(true)
		v16(module3.instant(0))
		task.delay(0.1, function()
			v16((module3.spring(1, { dampingRatio = 1, frequency = 4 })))
		end)
		task.delay(0.2, function()
			setState(false)
		end)
	end, { p2 })

	useEffect(function()
		if not p2 and v9.current then
			v9.current.Size = UDim2.new(1, 0, 0, p3)
			v9.current.Position = UDim2.fromScale(0.5, 0.5)
		end
	end, { p2 })

	useEventConnection(UserInputService.TouchPinch, function(list, p6, p7, p8, p9)
		if p8 == Enum.UserInputState.End then
			if v11.current or not v8.current then
				return
			end

			v17()
			setIsZooming(false)
		else
			if not p2 or p5 or state or not v9.current then
				return
			end

			if p8 == Enum.UserInputState.Begin then
				v11.current = false
				local v18 = (list[1].X + list[2].X) / 2
				local v19 = v6.top + (list[1].Y + list[2].Y) / 2

				local contentFeedItem = v9.current:FindFirstChild("ContentFeedItem")

				if not contentFeedItem then
					return
				end

				local absolutePosition = contentFeedItem.AbsolutePosition

				if
					v18 < absolutePosition.X
					or absolutePosition.X + p4 < v18
					or (v19 < v6.top + absolutePosition.Y or v6.top + absolutePosition.Y + p3 < v19)
				then
					return
				end

				v8.current = Vector2.new(v18, v19)
				setIsZooming(true)
			end

			if not v8.current or v11.current then
				return
			end

			if #list < 2 then
				v11.current = true
				v17()
				setIsZooming(false)
			else
				local v18 = math.max(1, p6)
				v10.current = v18

				local v19 = ((list[1].X + list[2].X) / 2 - v8.current.X) / v18

				local v20 = ((list[1].Y + list[2].Y) / 2 - v8.current.Y) / v18

				v12.current = Vector2.new(v19, v20)

				v9.current.Size = UDim2.new(v18, 0, 0, v18 * p3)
				v9.current.Position = UDim2.new(
					0.5,
					(0.5 - (v8.current.X - v19) / v7.X) * v7.X * (v18 - 1),
					0.5,
					(0.5 - (v8.current.Y - v20) / v7.Y) * v7.Y * (v18 - 1)
				)
			end
		end
	end)

	return {
		initialZoomFocusPosition = v8,
		itemContainerRef = v9,
		itemFinalScale = v10,
		nonItemTransparency = v13,
		zoomAverageDelta = v12,
		zoomEndTransition = v15,
		zoomEndTransitionActive = state
	}
end

return useFeedZoomController
