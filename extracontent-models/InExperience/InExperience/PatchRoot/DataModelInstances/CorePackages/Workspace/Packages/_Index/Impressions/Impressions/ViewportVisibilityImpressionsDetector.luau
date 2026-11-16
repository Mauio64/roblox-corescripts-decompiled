local parent = script:FindFirstAncestor("Impressions").Parent
local React = require(parent.React)
local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds

local function ViewportVisibilityImpressionsDetector(data): nil
	local v = useViewportBounds()
	local threshold = data.threshold or 0.5
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local v2 = React.useCallback(function()
		if ref.current then
			return
		end

		local current = data.targetRef.current

		if not current or not current.Visible or current.AbsoluteSize.X == 0 or current.AbsoluteSize.Y == 0 then
			return
		end

		local x = current.AbsolutePosition.X

		if math.max(0, math.min(x + current.AbsoluteSize.X, v.max.X) - math.max(x, v.min.X)) <= 0 then
			return
		end

		local y = current.AbsolutePosition.Y

		if threshold <= math.max(0, math.min(y + current.AbsoluteSize.Y, v.max.Y) - math.max(y, v.min.Y)) / current.AbsoluteSize.Y then
			ref.current = true
			data.onImpression()
		end
	end, { data.targetRef, data.onImpression, threshold, v })

	local v3 = React.useCallback(function()
		if ref2.current then
			task.cancel(ref2.current)
		end

		ref2.current = task.delay(0.2, function()
			ref2.current = nil
			v2()
		end)
	end, { v2 })

	React.useEffect(function()
		local current = data.targetRef.current

		if not current then
			return nil
		end

		v3()

		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v3)
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v3)
		local visibleChangedConnection = current:GetPropertyChangedSignal("Visible"):Connect(v3)
		return function()
			if ref2.current then
				task.cancel(ref2.current)
				ref2.current = nil
			end

			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
			visibleChangedConnection:Disconnect()
		end
	end, { data.targetRef, v3 })

	return nil
end

return ViewportVisibilityImpressionsDetector
