local parent = script.Parent.Parent
local parent2 = parent.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)
local ReactUtils = require(parent2.ReactUtils)

local isPointWithinBounds = require(parent.Utils.isPointWithinBounds)

local useMotor = ReactOtter.useMotor
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useRef = React.useRef
local useState = React.useState

local v = { dampingRatio = 1, frequency = 4 }

local function useZoomController(flag: boolean)
	local state, setState = useState(false)

	local v2 = useRef(nil)
	local v3 = useRef(nil)
	local v4 = useRef(nil)

	local v5 = useMotor({
		scale = 1,
		xAnchor = 0.5,
		yAnchor = 0.5,
		xPos = 0.5,
		yPos = 0.5
	}, (useCallback(function(data)
		if not v2.current then
			return
		end

		v2.current.AnchorPoint = Vector2.new(data.xAnchor, data.yAnchor)
		v2.current.Position = UDim2.fromScale(data.xPos, data.yPos)
		v2.current.Size = UDim2.fromScale(data.scale, data.scale)
	end, {})))

	useEffect(function()
		if not v2.current then
			return
		end

		if flag then
			v3.current = v2.current.AbsolutePosition
			v4.current = v2.current.AbsoluteSize
		else
			v3.current = nil
			v4.current = nil

			v2.current.AnchorPoint = Vector2.new(0.5, 0.5)
			v2.current.Position = UDim2.fromScale(0.5, 0.5)
			v2.current.Size = UDim2.fromScale(1, 1)
		end
	end, { flag })

	local v6 = useCallback(function(list, value, _, p, _)
		if not (flag and v2.current) then
			return
		end

		if p == Enum.UserInputState.End and state or #list < 2 then
			v5({
				scale = ReactOtter.spring(1, v),
				xPos = ReactOtter.spring(v2.current.AnchorPoint.X, v),
				yPos = ReactOtter.spring(v2.current.AnchorPoint.Y, v)
			})

			v3.current = nil
			v4.current = nil

			setState(false)
		else
			if p == Enum.UserInputState.Begin then
				local item = list[1]
				local item2 = list[2]
				local absolutePosition = v2.current.AbsolutePosition
				local absoluteSize = v2.current.AbsoluteSize

				if not (isPointWithinBounds(item, absolutePosition, absoluteSize) and isPointWithinBounds(item2, absolutePosition, absoluteSize)) then
					return
				end

				v3.current = absolutePosition
				v4.current = absoluteSize

				local v6 = absolutePosition + absoluteSize / 2
				local v7 = (item + item2) / 2 - v6
				local v8 = v7.X / absoluteSize.X + 0.5
				local v9 = v7.Y / absoluteSize.Y + 0.5

				v5({
					xAnchor = ReactOtter.instant(v8),
					yAnchor = ReactOtter.instant(v9),
					xPos = ReactOtter.instant(v8),
					yPos = ReactOtter.instant(v9)
				})

				setState(true)
			end

			if not (state and (v3.current and v4.current)) then
				return
			end

			local v6 = math.clamp(value, 0.5, 3)
			local v7 = v3.current + v4.current / 2
			local v8 = (list[1] + list[2]) / 2 - v7
			local v9 = v8.X / v4.current.X + 0.5
			local v10 = v8.Y / v4.current.Y + 0.5

			v5({
				scale = ReactOtter.instant(v6),
				xPos = ReactOtter.instant(v9),
				yPos = ReactOtter.instant(v10)
			})
		end
	end, { flag, state, v5 })

	useEventConnection(UserInputService.TouchPinch, v6)

	return state, v2
end

return useZoomController
