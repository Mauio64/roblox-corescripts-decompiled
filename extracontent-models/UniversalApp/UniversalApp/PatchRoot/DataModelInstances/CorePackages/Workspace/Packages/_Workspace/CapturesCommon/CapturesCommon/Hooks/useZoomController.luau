local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local ReactUtils = require(ParentParentParent.ReactUtils)
local isPointWithinBounds = require(ParentParent.Utils.isPointWithinBounds)
local useMotor = ReactOtter.useMotor
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useRef = React.useRef
local useState = React.useState
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

local function useZoomController(b1: boolean) -- line: 28
	-- upvalues: useState (copy), useRef (copy), useCallback (copy), useMotor (copy), useEffect (copy), ReactOtter (copy), t1 (copy), isPointWithinBounds (copy), useEventConnection (copy), UserInputService (copy)
	local v17, v18 = useState(false)
	local v19 = useRef(nil)
	local v20 = useRef(nil)
	local v21 = useRef(nil)
	local v22 = useCallback(function(p1) -- line: 35
		-- upvalues: v19 (copy)
		if not v19.current then
			return
		end

		v19.current.AnchorPoint = Vector2.new(p1.xAnchor, p1.yAnchor)
		v19.current.Position = UDim2.fromScale(p1.xPos, p1.yPos)
		v19.current.Size = UDim2.fromScale(p1.scale, p1.scale)
	end, {})
	local v23 = useMotor({
		scale = 1,
		xAnchor = 0.5,
		yAnchor = 0.5,
		xPos = 0.5,
		yPos = 0.5
	}, v22)

	useEffect(function() -- line: 53
		-- upvalues: v19 (copy), b1 (copy), v20 (copy), v21 (copy)
		if not v19.current then
			return
		end

		if b1 then
			v20.current = v19.current.AbsolutePosition
			v21.current = v19.current.AbsoluteSize

			return
		end

		v20.current = nil
		v21.current = nil
		v19.current.AnchorPoint = Vector2.new(0.5, 0.5)
		v19.current.Position = UDim2.fromScale(0.5, 0.5)
		v19.current.Size = UDim2.fromScale(1, 1)
	end, { b1 })

	local v24 = useCallback(function(t2: {[any]: any}, p2, _, p4, _) -- line: 71
		-- upvalues: b1 (copy), v19 (copy), v17 (copy), v23 (copy), ReactOtter (copy), t1 (copy), v20 (copy), v21 (copy), v18 (copy), isPointWithinBounds (copy)
		if not b1 or not v19.current then
			return
		end

		if p4 == Enum.UserInputState.End and v17 or #t2 < 2 then
			v23({
				scale = ReactOtter.spring(1, t1),
				xPos = ReactOtter.spring(v19.current.AnchorPoint.X, t1),
				yPos = ReactOtter.spring(v19.current.AnchorPoint.Y, t1)
			})
			v20.current = nil
			v21.current = nil
			v18(false)

			return
		end

		if p4 == Enum.UserInputState.Begin then
			local v31 = t2[1]
			local v32 = t2[2]
			local AbsolutePosition = v19.current.AbsolutePosition
			local AbsoluteSize = v19.current.AbsoluteSize

			if not isPointWithinBounds(v31, AbsolutePosition, AbsoluteSize) or not isPointWithinBounds(v32, AbsolutePosition, AbsoluteSize) then
				return
			end

			v20.current = AbsolutePosition
			v21.current = AbsoluteSize

			local v35 = AbsolutePosition + AbsoluteSize / 2
			local v36 = (v31 + v32) / 2 - v35
			local v37 = v36.X / AbsoluteSize.X + 0.5
			local v38 = v36.Y / AbsoluteSize.Y + 0.5

			v23({
				xAnchor = ReactOtter.instant(v37),
				yAnchor = ReactOtter.instant(v38),
				xPos = ReactOtter.instant(v37),
				yPos = ReactOtter.instant(v38)
			})
			v18(true)
		end

		if not v17 then
			return
		end

		if not v20.current or not v21.current then
			return
		end

		local v39 = math.clamp(p2, 0.5, 3)
		local v40 = v20.current + v21.current / 2
		local v41 = (t2[1] + t2[2]) / 2 - v40
		local v42 = v41.X / v21.current.X + 0.5
		local v43 = v41.Y / v21.current.Y + 0.5

		v23({
			scale = ReactOtter.instant(v39),
			xPos = ReactOtter.instant(v42),
			yPos = ReactOtter.instant(v43)
		})
	end, {
		b1,
		v17,
		v23
	})

	useEventConnection(UserInputService.TouchPinch, v24)

	return v17, v19
end

return useZoomController
