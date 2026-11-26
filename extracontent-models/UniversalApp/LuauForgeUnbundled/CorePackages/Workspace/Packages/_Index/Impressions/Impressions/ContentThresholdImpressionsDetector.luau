local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/ViewportUtils").useViewportBounds

local function ContentThresholdImpressionsDetector(data): nil
	local v5 = useViewportBounds()
	local ref = React.useRef({})
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(data.impressionsTag)

	local v6 = React.useCallback(function()
		local current = data.containerRef.current

		if not current then
			return
		end

		local fullContentHeight = math.floor(data.fullContentHeight)

		if fullContentHeight <= 0 or current.AbsoluteSize.Y == 0 then
			return
		end

		local y = current.AbsolutePosition.Y
		local v7 = y + current.AbsoluteSize.Y
		local y2 = (if data.viewportBoundsOffset then {
			min = v5.min + data.viewportBoundsOffset.min,
			max = v5.max + data.viewportBoundsOffset.max
		} else v5).max.Y

		if y2 <= 0 then
			return
		end

		local v9 = math.clamp(math.min(v7, y2) - y, 0, fullContentHeight) / fullContentHeight

		ref2.current = math.max(ref2.current, v9)

		local v10 = {}

		for k, threshold in data.thresholds do
			if ref.current[k] or not (threshold <= ref2.current) then
				continue
			end

			ref.current[k] = true
			table.insert(v10, data.thresholds[k])
		end

		if #v10 > 0 then
			data.sendImpressions(v10)
		end
	end, {
		data.containerRef,
		data.fullContentHeight,
		data.thresholds,
		data.viewportBoundsOffset,
		data.sendImpressions,
		v5
	})

	local v7 = React.useCallback(function()
		if ref3.current then
			task.cancel(ref3.current)
		end

		ref3.current = task.delay(0.2, function()
			ref3.current = nil
			v6()
		end)
	end, { v6 })

	React.useEffect(function()
		if ref4.current ~= data.impressionsTag then
			ref4.current = data.impressionsTag
			ref.current = {}
			ref2.current = 0
			v7()
		end
	end, { data.impressionsTag, v7 })

	React.useEffect(function()
		local current = data.containerRef.current

		if not current then
			return nil
		end

		v7()

		local absolutePositionChangedConnection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v7)
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v7)
		return function()
			if ref3.current then
				task.cancel(ref3.current)
				ref3.current = nil
			end

			absolutePositionChangedConnection:Disconnect()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { data.containerRef, v7 })

	return nil
end

return ContentThresholdImpressionsDetector
