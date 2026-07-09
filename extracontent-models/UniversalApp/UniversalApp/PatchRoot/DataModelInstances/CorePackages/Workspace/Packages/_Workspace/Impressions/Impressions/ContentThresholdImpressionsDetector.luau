local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds

local function ContentThresholdImpressionsDetector(t1: {[any]: any}) -- line: 24
	-- upvalues: useViewportBounds (copy), React (copy)
	local v6 = useViewportBounds()
	local v7 = React.useRef({})
	local v8 = React.useRef(0)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(t1.impressionsTag)
	local v11 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy), v6 (copy), v8 (copy), v7 (copy)
		local current = t1.containerRef.current

		if not current then
			return
		end

		local v14 = math.floor(t1.fullContentHeight)

		if v14 <= 0 then
			return
		end

		if current.AbsoluteSize.Y == 0 then
			return
		end

		local AbsolutePositionY = current.AbsolutePosition.Y
		local v16 = AbsolutePositionY + current.AbsoluteSize.Y
		local maxY = ((if not t1.viewportBoundsOffset then v6 else {
			min = v6.min + t1.viewportBoundsOffset.min,
			max = v6.max + t1.viewportBoundsOffset.max
		})).max.Y

		if maxY <= 0 then
			return
		end

		local v18 = math.clamp(math.min(v16, maxY) - AbsolutePositionY, 0, v14) / v14

		v8.current = math.max(v8.current, v18)

		local t2 = {}

		for v20, v21 in t1.thresholds do
			if not v7.current[v20] and v21 <= v8.current then
				v7.current[v20] = true
				table.insert(t2, t1.thresholds[v20])
			end
		end

		if #t2 > 0 then
			t1.sendImpressions(t2)
		end
	end, {
		t1.containerRef,
		t1.fullContentHeight,
		t1.thresholds,
		t1.viewportBoundsOffset,
		t1.sendImpressions,
		v6
	})
	local v12 = React.useCallback(function() -- line: 89
		-- upvalues: v9 (copy), v11 (copy)
		if v9.current then
			task.cancel(v9.current)
		end

		v9.current = task.delay(0.2, function() -- line: 93
			-- upvalues: v9 (copy), v11 (copy)
			v9.current = nil
			v11()
		end)
	end, { v11 })

	React.useEffect(function() -- line: 99
		-- upvalues: v10 (copy), t1 (copy), v7 (copy), v8 (copy), v12 (copy)
		if v10.current ~= t1.impressionsTag then
			v10.current = t1.impressionsTag
			v7.current = {}
			v8.current = 0
			v12()
		end
	end, {
		t1.impressionsTag,
		v12
	})
	React.useEffect(function() -- line: 108
		-- upvalues: t1 (copy), v12 (copy), v9 (copy)
		local current = t1.containerRef.current

		if not current then
			return nil
		end

		v12()

		local connection = current:GetPropertyChangedSignal("AbsolutePosition"):Connect(v12)
		local connection2 = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v12)

		return function() -- line: 118
			-- upvalues: v9 (copy), connection (copy), connection2 (copy)
			if v9.current then
				task.cancel(v9.current)
				v9.current = nil
			end

			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		t1.containerRef,
		v12
	})

	return nil
end

return ContentThresholdImpressionsDetector
