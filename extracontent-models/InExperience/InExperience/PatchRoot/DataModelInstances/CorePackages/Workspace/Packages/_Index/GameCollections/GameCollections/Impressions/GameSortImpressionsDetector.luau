local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local Signal = require(Parent.AppCommonLib).Signal
local useRouteName = require(Parent.Navigation).useRouteName
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local Cryo = require(Parent.Cryo)
local Impressions = require(Parent.Impressions)
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
local ImpressionsVisualizer = Impressions.ImpressionsVisualizer

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), Signal (copy), ImpressionsVisualizer (copy), useRouteName (copy), useSelector (copy), Cryo (copy), ScreenSizeImpressionsDetector (copy)
	local v11 = React.useRef({})
	local v12 = React.useRef(Signal.new())
	local u13 = React.useRef(nil)

	if u13.current == nil then
		u13.current = ImpressionsVisualizer.new(t1.impressionsTag)
	end

	assert(u13.current, "impressionsVisualizer should always be truthy; check needed for lint")

	local v14, v15 = React.useState({})
	local v16, v17 = React.useState(t1.dataUpdatedTimestamp)
	local v18 = useRouteName()
	local v19 = useSelector(function(p1) -- line: 36
		return p1.ScreenSize
	end)
	local v20 = React.useRef(t1.impressionsTag)

	React.useEffect(function() -- line: 42
		-- upvalues: v20 (copy), t1 (copy), v17 (copy), v11 (copy), u13 (ref)
		if v20.current ~= t1.impressionsTag then
			v20.current = t1.impressionsTag
			v17(t1.dataUpdatedTimestamp)
			v11.current = {}
			u13.current:onClearAllImpressions()
			u13.current:setImpressionsTag(t1.impressionsTag)
		end
	end, { t1.impressionsTag })
	React.useEffect(function() -- line: 52
		-- upvalues: v12 (copy), t1 (copy)
		v12.current:fire()

		local u24 = nil

		if t1.scrollViewPositionChangedSignal then
			u24 = t1.scrollViewPositionChangedSignal:connect(function() -- line: 59
				-- upvalues: v12 (copy)
				v12.current:fire()
			end)
		end

		return function() -- line: 64
			-- upvalues: u24 (ref)
			if u24 ~= nil then
				u24:disconnect()
			end
		end
	end, { t1.scrollViewPositionChangedSignal })
	React.useEffect(function() -- line: 71
		-- upvalues: t1 (copy), Cryo (copy), v18 (copy), v12 (copy), v16 (copy), v17 (copy), v11 (copy), u13 (ref)
		if if type(t1.pageContext) ~= "table" then v18 == t1.pageContext else Cryo.List.find(t1.pageContext, v18) ~= nil then
			v12.current:fire()

			if t1.dataUpdatedTimestamp ~= v16 then
				v17(t1.dataUpdatedTimestamp)
				v11.current = {}
				u13.current:onClearAllImpressions()
			end
		end
	end, {
		v18,
		t1.pageContext,
		t1.dataUpdatedTimestamp,
		v16,
		v19
	})
	React.useEffect(function() -- line: 90
		-- upvalues: v14 (copy), t1 (copy), u13 (ref), v15 (copy)
		if v14 ~= nil and #v14 > 0 then
			t1.sendGameImpressions(v14)
			u13.current:onSendImpressions(v14)
			v15({})
		end
	end, { v14 })
	React.useEffect(function() -- line: 98
		-- upvalues: u13 (ref)
		return function() -- line: 99
			-- upvalues: u13 (ref)
			u13.current:destroy()
		end
	end, {})

	local v21 = React.useCallback(function(p2) -- line: 104
		-- upvalues: v11 (copy)
		if v11.current[p2] ~= nil then
			return false
		end

		v11.current[p2] = true

		return true
	end, {})
	local v22 = React.useCallback(function(p3) -- line: 113
		-- upvalues: v15 (copy)
		if not p3 or #p3 == 0 then
			return
		end

		v15(p3)
	end, {})

	return React.createElement(ScreenSizeImpressionsDetector, {
		onRequestImpressionsSignal = v12.current,
		parentRef = t1.parentRef,
		filterImpressionFunc = v21,
		onImpressionsDetected = v22,
		impressionsTag = t1.impressionsTag
	})
end
