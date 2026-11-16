local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/ViewportUtils").useViewportBounds

local function ViewportVisibilityImpressionsDetector(data): nil
	local v5 = useViewportBounds()
	local threshold = data.threshold or 0.5
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local v6 = React.useCallback(function()
		if ref.current then
			return
		end

		local current = data.targetRef.current

		if
			not current
			or not current.Visible
			or current.AbsoluteSize.X == 0
			or current.AbsoluteSize.Y == 0
		then
			return
		end

		local x = current.AbsolutePosition.X

		if math.max(0, math.min(x + current.AbsoluteSize.X, v5.max.X) - math.max(x, v5.min.X)) <= 0 then
			return
		end

		local y = current.AbsolutePosition.Y

		if threshold <= math.max(0, math.min(y + current.AbsoluteSize.Y, v5.max.Y) - math.max(y, v5.min.Y)) / current.AbsoluteSize.Y then
			ref.current = true
			data.onImpression()
		end
	end, { data.targetRef, data.onImpression, threshold, v5 })

	local v7 = React.useCallback(function()
		if ref2.current then
			task.cancel(ref2.current)
		end

		ref2.current = task.delay(0.2, function()
			ref2.current = nil
			v6()
		end)
	end, { v6 })

	React.useEffect(function()
		local current = data.targetRef.current

		if not current then
			return nil
		end

		v7()

		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v7)
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v7)
		local visibleChangedConnection = current:GetPropertyChangedSignal("Visible"):Connect(v7)
		return function()
			if ref2.current then
				task.cancel(ref2.current)
				ref2.current = nil
			end

			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
			visibleChangedConnection:Disconnect()
		end
	end, { data.targetRef, v7 })

	return nil
end

return ViewportVisibilityImpressionsDetector
