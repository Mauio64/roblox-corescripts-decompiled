local parent = script:FindFirstAncestor("Impressions").Parent
local React = require(parent.React)
local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds

local function ContentThresholdImpressionsDetector(data): nil
	local v = useViewportBounds()
	local ref = React.useRef({})
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(data.impressionsTag)

	local v2 = React.useCallback(function()
		local current = data.containerRef.current

		if not current then
			return
		end

		local fullContentHeight = math.floor(data.fullContentHeight)

		if fullContentHeight <= 0 or current.AbsoluteSize.Y == 0 then
			return
		end

		local y = current.AbsolutePosition.Y
		local v2 = y + current.AbsoluteSize.Y
		local v3

		if data.viewportBoundsOffset then
			v3 = {
				min = v.min + data.viewportBoundsOffset.min,
				max = v.max + data.viewportBoundsOffset.max
			}
		else
			v3 = v
		end

		local y2 = v3.max.Y

		if y2 <= 0 then
			return
		end

		local v4 = math.clamp(math.min(v2, y2) - y, 0, fullContentHeight) / fullContentHeight

		ref2.current = math.max(ref2.current, v4)

		local v5 = {}

		for k, threshold in data.thresholds do
			if ref.current[k] or not (threshold <= ref2.current) then
				continue
			end

			ref.current[k] = true
			table.insert(v5, data.thresholds[k])
		end

		if #v5 > 0 then
			data.sendImpressions(v5)
		end
	end, {
		data.containerRef,
		data.fullContentHeight,
		data.thresholds,
		data.viewportBoundsOffset,
		data.sendImpressions,
		v
	})

	local v3 = React.useCallback(function()
		if ref3.current then
			task.cancel(ref3.current)
		end

		ref3.current = task.delay(0.2, function()
			ref3.current = nil
			v2()
		end)
	end, { v2 })

	React.useEffect(function()
		if ref4.current ~= data.impressionsTag then
			ref4.current = data.impressionsTag
			ref.current = {}
			ref2.current = 0
			v3()
		end
	end, { data.impressionsTag, v3 })

	React.useEffect(function()
		local current = data.containerRef.current

		if not current then
			return nil
		end

		v3()

		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v3)
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v3)
		return function()
			if ref3.current then
				task.cancel(ref3.current)
				ref3.current = nil
			end

			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { data.containerRef, v3 })

	return nil
end

return ContentThresholdImpressionsDetector
