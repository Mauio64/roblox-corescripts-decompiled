local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/ReactOtter")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/ReactUtils")

local isPointWithinBounds = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/isPointWithinBounds")

local useMotor = ReactOtter.useMotor
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useRef = React.useRef
local useState = React.useState

local v5 = { dampingRatio = 1, frequency = 4 }

local function useZoomController(p2)
	local state, setState = useState(false)

	local v6 = useRef(nil)
	local v7 = useRef(nil)
	local v8 = useRef(nil)

	local v10 = useMotor({
		scale = 1,
		xAnchor = 0.5,
		yAnchor = 0.5,
		xPos = 0.5,
		yPos = 0.5
	}, (useCallback(function(data)
		if not v6.current then
			return
		end

		v6.current.AnchorPoint = Vector2.new(data.xAnchor, data.yAnchor)
		v6.current.Position = UDim2.fromScale(data.xPos, data.yPos)
		v6.current.Size = UDim2.fromScale(data.scale, data.scale)
	end, {})))

	useEffect(function()
		if not v6.current then
			return
		end

		if p2 then
			v7.current = v6.current.AbsolutePosition
			v8.current = v6.current.AbsoluteSize
		else
			v7.current = nil
			v8.current = nil

			v6.current.AnchorPoint = Vector2.new(0.5, 0.5)
			v6.current.Position = UDim2.fromScale(0.5, 0.5)
			v6.current.Size = UDim2.fromScale(1, 1)
		end
	end, { p2 })

	local v11 = useCallback(function(list, value, p3, p4, p5)
		if not (p2 and v6.current) then
			return
		end

		if p4 == Enum.UserInputState.End and state or #list < 2 then
			v10({
				scale = ReactOtter.spring(1, v5),
				xPos = ReactOtter.spring(v6.current.AnchorPoint.X, v5),
				yPos = ReactOtter.spring(v6.current.AnchorPoint.Y, v5)
			})

			v7.current = nil
			v8.current = nil

			setState(false)
		else
			if p4 == Enum.UserInputState.Begin then
				local item = list[1]
				local item2 = list[2]
				local absolutePosition = v6.current.AbsolutePosition
				local absoluteSize = v6.current.AbsoluteSize

				if not (isPointWithinBounds(item, absolutePosition, absoluteSize) and isPointWithinBounds(item2, absolutePosition, absoluteSize)) then
					return
				end

				v7.current = absolutePosition
				v8.current = absoluteSize

				local v12 = absolutePosition + absoluteSize / 2
				local v13 = (item + item2) / 2 - v12
				local v14 = v13.X / absoluteSize.X + 0.5
				local v15 = v13.Y / absoluteSize.Y + 0.5

				v10({
					xAnchor = ReactOtter.instant(v14),
					yAnchor = ReactOtter.instant(v15),
					xPos = ReactOtter.instant(v14),
					yPos = ReactOtter.instant(v15)
				})

				setState(true)
			end

			if not (state and (v7.current and v8.current)) then
				return
			end

			local v12 = math.clamp(value, 0.5, 3)
			local v13 = v7.current + v8.current / 2
			local v14 = (list[1] + list[2]) / 2 - v13
			local v15 = v14.X / v8.current.X + 0.5
			local v16 = v14.Y / v8.current.Y + 0.5

			v10({
				scale = ReactOtter.instant(v12),
				xPos = ReactOtter.instant(v15),
				yPos = ReactOtter.instant(v16)
			})
		end
	end, { p2, state, v10 })

	useEventConnection(UserInputService.TouchPinch, v11)

	return state, v6
end

return useZoomController
