local module = require("@luauforge/bundled/dTk")

local function getNativeScrollingFrame(p2)
	local current = p2.current

	if current == nil then
		return nil
	end

	local nativeScrollRef = current:getNativeScrollRef()

	if nativeScrollRef == nil then
		return nil
	end

	return nativeScrollRef._nativeRef.current
end

local function recordAndRestoreScrollPosition(current, p2, p3)
	local v5

	if p3 then
		v5 = p3.current or 0
		p3.current = nil
	else
		v5 = 0
	end

	local v6 = v5 > 0
	local v7 = if v6 then v5 else math.max(0, current.CanvasPosition.Y)
	p2.current = v7
	local v8 = nil
	local connections = {}

	local function stopRestoring()
		v6 = false

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	local function stepTowardTarget()
		if not v6 then
			return
		end

		local canvasPosition = current.CanvasPosition
		local v9 = math.max(0, current.AbsoluteCanvasSize.Y - current.AbsoluteWindowSize.Y)
		local v10 = math.min(v5, v9)

		if canvasPosition.Y < v10 then
			v8 = v10
			current.CanvasPosition = Vector2.new(canvasPosition.X, v10)
		end

		if v5 <= v10 then
			v6 = false

			for k, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)
		end
	end

	local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		local y = current.CanvasPosition.Y

		if v6 then
			if v8 ~= nil and math.abs(y - v8) < 1 then
				return
			end

			v6 = false

			for k, connection in connections do
				connection:Disconnect()
			end

			table.clear(connections)
		end

		p2.current = math.max(0, y)
	end)

	if v6 then
		table.insert(
			connections,
			current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(stepTowardTarget)
		)

		table.insert(
			connections,
			current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(stepTowardTarget)
		)

		stepTowardTarget()
	end

	return function()
		canvasPositionChangedConnection:Disconnect()
		v6 = false

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end
end

local function useRestoreFeedScrollPosition(p2, p3, p4)
	module.useLayoutEffect(function()
		if not p3 then
			return nil
		end

		local current = p2.current
		local current2

		if current ~= nil then
			local nativeScrollRef = current:getNativeScrollRef()

			if nativeScrollRef ~= nil then
				current2 = nativeScrollRef._nativeRef.current
			end
		end

		if current2 then
			return recordAndRestoreScrollPosition(current2, p3, p4)
		end

		return nil
	end, { p2, p3, p4 })
end

return useRestoreFeedScrollPosition
