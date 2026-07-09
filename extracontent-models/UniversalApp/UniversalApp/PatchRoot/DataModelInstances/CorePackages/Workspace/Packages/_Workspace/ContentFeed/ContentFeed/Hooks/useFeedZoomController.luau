local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local ReactUtils = require(ParentParentParent.ReactUtils)
local FeedContext = require(ParentParent.App.FeedContext)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useGuiInset = CapturesCommon.Hooks.useGuiInset
local useRef = React.useRef
local useScreenSize = RobloxAppHooks.useScreenSize
local useState = React.useState

local function useFeedZoomController(p1, p2, p3, p4) -- line: 26
	-- upvalues: React (copy), FeedContext (copy), useGuiInset (copy), useScreenSize (copy), useRef (copy), useState (copy), useAnimatedBinding (copy), useEffect (copy), ReactOtter (copy), useCallback (copy), useEventConnection (copy), UserInputService (copy)
	local v23 = React.useContext(FeedContext)
	local v24 = useGuiInset()
	local v25 = useScreenSize()
	local isZooming = v23.isZooming
	local setIsZooming = v23.setIsZooming
	local v28 = useRef(nil)
	local v29 = useRef(nil)
	local v30 = useRef(1)
	local v31 = useRef(false)
	local v32 = useRef(Vector2.new(0, 0))
	local v33, v34 = useState(false)
	local v35, v36 = useAnimatedBinding(0)
	local v37, v38 = useAnimatedBinding(0)

	useEffect(function() -- line: 44
		-- upvalues: v33 (copy), v28 (copy)
		if not v33 then
			v28.current = nil
		end
	end, { v33 })
	useEffect(function() -- line: 50
		-- upvalues: p1 (copy), p4 (copy), isZooming (copy), v36 (copy), ReactOtter (copy)
		if not p1 or p4 then
			return
		end

		if isZooming then
			v36(ReactOtter.spring(1, {
				frequency = 4,
				dampingRatio = 1
			}))

			return
		end

		v36(ReactOtter.spring(0, {
			frequency = 4,
			dampingRatio = 1
		}))
	end, {
		p1,
		isZooming,
		v36
	})

	local v39 = useCallback(function() -- line: 68
		-- upvalues: p1 (copy), v34 (copy), v38 (copy), ReactOtter (copy)
		if not p1 then
			return
		end

		v34(true)
		v38(ReactOtter.instant(0))
		task.delay(0.1, function() -- line: 75
			-- upvalues: ReactOtter (copy), v38 (copy)
			local v52 = ReactOtter.spring(1, {
				dampingRatio = 1,
				frequency = 4
			})

			v38(v52)
		end)
		task.delay(0.2, function() -- line: 82
			-- upvalues: v34 (copy)
			v34(false)
		end)
	end, { p1 })

	useEffect(function() -- line: 87
		-- upvalues: p1 (copy), v29 (copy), p2 (copy)
		if not p1 and v29.current then
			v29.current.Size = UDim2.new(1, 0, 0, p2)
			v29.current.Position = UDim2.fromScale(0.5, 0.5)
		end
	end, { p1 })
	useEventConnection(UserInputService.TouchPinch, function(t1: {[any]: any}, p5, _, p7, _) -- line: 96
		-- upvalues: v31 (copy), v28 (copy), v39 (copy), setIsZooming (copy), p1 (copy), p4 (copy), v33 (copy), v29 (copy), v24 (copy), p3 (copy), p2 (copy), v30 (copy), v32 (copy), v25 (copy)
		if p7 == Enum.UserInputState.End then
			if v31.current or not v28.current then
				return
			end

			v39()
			setIsZooming(false)

			return
		end

		if not p1 or p4 or v33 then
			return
		end

		if not v29.current then
			return
		end

		if p7 == Enum.UserInputState.Begin then
			v31.current = false

			local v45 = (t1[1].X + t1[2].X) / 2
			local v46 = v24.top + (t1[1].Y + t1[2].Y) / 2
			local ContentFeedItem = v29.current:FindFirstChild("ContentFeedItem")

			if not ContentFeedItem then
				return
			end

			local AbsolutePosition = ContentFeedItem.AbsolutePosition

			if v45 < AbsolutePosition.X or v45 > AbsolutePosition.X + p3 then
				return
			end

			if v46 < v24.top + AbsolutePosition.Y or v46 > v24.top + AbsolutePosition.Y + p2 then
				return
			end

			v28.current = Vector2.new(v45, v46)
			setIsZooming(true)
		end

		if not v28.current then
			return
		end

		if v31.current then
			return
		end

		if #t1 < 2 then
			v31.current = true
			v39()
			setIsZooming(false)

			return
		end

		local v49 = math.max(1, p5)

		v30.current = v49

		local v50 = ((t1[1].X + t1[2].X) / 2 - v28.current.X) / v49
		local v51 = ((t1[1].Y + t1[2].Y) / 2 - v28.current.Y) / v49

		v32.current = Vector2.new(v50, v51)
		v29.current.Size = UDim2.new(v49, 0, 0, v49 * p2)
		v29.current.Position = UDim2.new(0.5, (0.5 - (v28.current.X - v50) / v25.X) * v25.X * (v49 - 1), 0.5, (0.5 - (v28.current.Y - v51) / v25.Y) * v25.Y * (v49 - 1))
	end)

	return {
		initialZoomFocusPosition = v28,
		itemContainerRef = v29,
		itemFinalScale = v30,
		nonItemTransparency = v35,
		zoomAverageDelta = v32,
		zoomEndTransition = v37,
		zoomEndTransitionActive = v33
	}
end

return useFeedZoomController
