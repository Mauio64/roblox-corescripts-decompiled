local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local Signal = require(Parent.AppCommonLib).Signal
local ImpressionsDetector = require(script.Parent.ImpressionsDetector)
local ImpressionDetectorWithoutNavigation = require(script.Parent.ImpressionDetectorWithoutNavigation)
local ImpressionsVisualizer = require(script.Parent.ImpressionsVisualizer)
local SharedFlags = require(Parent.SharedFlags)
local v8 = game:DefineFastFlag("LuaAppFixImpressionsHookDependencies", false)
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local v10 = game:DefineFastFlag("LuaAppFireRequestImpressionsOnTagChange", false)

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), Signal (copy), ImpressionsVisualizer (copy), v10 (copy), v8 (copy), ImpressionsDetector (copy), ImpressionDetectorWithoutNavigation (copy), FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy)
	local v12 = React.useRef({})
	local v13 = React.useRef(Signal.new())
	local u14 = React.useRef(nil)

	if u14.current == nil then
		u14.current = ImpressionsVisualizer.new(t1.impressionsTag)
	end

	assert(u14.current, "impressionsVisualizer should always be truthy; check needed for lint")

	local v15, v16 = React.useState({})
	local v17, v18 = React.useState(t1.dataUpdatedTimestamp)
	local v19 = React.useRef(t1.impressionsTag)
	local viewPortBounds = t1.viewPortBounds

	React.useEffect(function() -- line: 51
		-- upvalues: v19 (copy), t1 (copy), v18 (copy), v12 (copy), u14 (ref), v10 (copy), v13 (copy)
		if v19.current ~= t1.impressionsTag then
			v19.current = t1.impressionsTag
			v18(t1.dataUpdatedTimestamp)
			v12.current = {}
			u14.current:onClearAllImpressions()
			u14.current:setImpressionsTag(t1.impressionsTag)

			if v10 then
				v13.current:fire()
			end
		end
	end, {
		t1.impressionsTag,
		if not v8 then nil else t1.dataUpdatedTimestamp
	})
	React.useEffect(function() -- line: 67
		-- upvalues: v13 (copy), t1 (copy)
		v13.current:fire()

		local u24 = nil

		if t1.scrollViewPositionChangedSignal then
			u24 = t1.scrollViewPositionChangedSignal:connect(function() -- line: 71
				-- upvalues: v13 (copy)
				v13.current:fire()
			end)
		end

		return function() -- line: 76
			-- upvalues: u24 (ref)
			if u24 ~= nil then
				u24:disconnect()
			end
		end
	end, { t1.scrollViewPositionChangedSignal })
	React.useEffect(function() -- line: 84
		-- upvalues: t1 (copy), v13 (copy), v17 (copy), v18 (copy), v12 (copy), u14 (ref)
		if t1.pageContext and t1.routeName == t1.pageContext then
			v13.current:fire()

			if t1.dataUpdatedTimestamp ~= v17 then
				v18(t1.dataUpdatedTimestamp)
				v12.current = {}
				u14.current:onClearAllImpressions()
			end
		end
	end, {
		t1.routeName,
		t1.pageContext,
		t1.dataUpdatedTimestamp,
		v17,
		viewPortBounds
	})
	React.useEffect(function() -- line: 107
		-- upvalues: v15 (copy), t1 (copy), u14 (ref), v16 (copy)
		if v15 ~= nil and #v15 > 0 then
			t1.sendImpressions(v15)
			u14.current:onSendImpressions(v15)
			v16({})
		end
	end, {
		v15,
		if not v8 then nil else t1.sendImpressions
	})
	React.useEffect(function() -- line: 118
		-- upvalues: u14 (ref)
		return function() -- line: 119
			-- upvalues: u14 (ref)
			u14.current:destroy()
		end
	end, {})

	local v21 = React.useCallback(function(p1) -- line: 124
		-- upvalues: v12 (copy)
		if v12.current[p1] ~= nil then
			return false
		end

		v12.current[p1] = true

		return true
	end, {})
	local v22 = React.useCallback(function(p2) -- line: 133
		-- upvalues: v16 (copy)
		if not p2 or #p2 == 0 then
			return
		end

		v16(p2)
	end, {})
	local v23 = if not t1.pageContext then ImpressionDetectorWithoutNavigation else ImpressionsDetector

	return React.createElement(v23, {
		parentRef = t1.parentRef,
		viewPortBounds = viewPortBounds,
		viewPortFillBounds = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else t1.viewPortFillBounds,
		onRequestImpressionsSignal = v13.current,
		filterImpressionFunc = v21,
		onImpressionsDetected = v22,
		impressionsTag = t1.impressionsTag
	})
end
