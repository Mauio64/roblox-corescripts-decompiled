local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local ImpressionsVisualizer = require(CorePackages.Workspace.Packages.Impressions).ImpressionsVisualizer

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), Signal (copy), ImpressionsVisualizer (copy), useSelector (copy), TopicContentsReducer (copy), ScreenSizeImpressionsDetector (copy)
	local v9 = React.useRef({})
	local v10 = React.useRef(Signal.new())
	local v11 = React.useCallback(function(p1) -- line: 33
		-- upvalues: t1 (copy)
		return t1.gameSortId .. "_" .. p1
	end, { t1.gameSortId })
	local u12 = React.useRef(nil)

	if u12.current == nil then
		u12.current = ImpressionsVisualizer.new(t1.impressionsTag, v11)
	end

	assert(u12.current)

	local v13 = useSelector(function(p2) -- line: 43
		-- upvalues: TopicContentsReducer (copy), t1 (copy)
		local v18 = p2.Personalization[TopicContentsReducer.key][t1.gameSortId]

		return v18 and v18.updatedTimestamp or nil
	end)

	React.useEffect(function() -- line: 48
		-- upvalues: u12 (ref), v11 (copy), v10 (copy)
		u12.current:setCustomKeyMapper(v11)
		v10.current:fire()
	end, { v11 })
	React.useEffect(function() -- line: 53
		-- upvalues: v9 (copy), t1 (copy), v13 (copy), u12 (ref), v10 (copy)
		local v19 = v9.current[t1.gameSortId] or {}

		if v19.lastUpdatedTimestamp ~= nil and v13 ~= v19.lastUpdatedTimestamp then
			local impressionsSeen = v19.impressionsSeen

			if impressionsSeen then
				local t2 = {}

				for k, v in pairs(impressionsSeen) do
					if v then
						table.insert(t2, k)
					end
				end

				if #t2 > 0 then
					u12.current:onClearImpressions(t2)
				end
			end

			v19.impressionsSeen = {}
		end

		v19.lastUpdatedTimestamp = v13
		v9.current[t1.gameSortId] = v19
		v10.current:fire()
	end, {
		t1.gameSortId,
		v13
	})
	React.useEffect(function() -- line: 81
		-- upvalues: v10 (copy), t1 (copy)
		v10.current:fire()

		local u24 = nil

		if t1.scrollViewPositionChangedSignal then
			u24 = t1.scrollViewPositionChangedSignal:connect(function() -- line: 89
				-- upvalues: v10 (copy)
				v10.current:fire()
			end)
		end

		return function() -- line: 94
			-- upvalues: u24 (ref)
			if u24 ~= nil then
				u24:disconnect()
			end
		end
	end, { t1.scrollViewPositionChangedSignal })
	React.useEffect(function() -- line: 101
		-- upvalues: u12 (ref)
		return function() -- line: 102
			-- upvalues: u12 (ref)
			u12.current:destroy()
		end
	end, {})

	local v14 = React.useCallback(function(p3) -- line: 107
		-- upvalues: v9 (copy), t1 (copy), v13 (copy)
		if v9.current[t1.gameSortId] == nil then
			v9.current[t1.gameSortId] = {
				impressionsSeen = {},
				lastUpdatedTimestamp = v13
			}
		end

		local v26 = v9.current[t1.gameSortId]

		v26.impressionsSeen = v26.impressionsSeen or {}

		if v26.impressionsSeen[p3] ~= nil then
			return false
		end

		v26.impressionsSeen[p3] = true

		return true
	end, { t1.gameSortId })
	local v15 = React.useCallback(function(p4) -- line: 125
		-- upvalues: t1 (copy), u12 (ref)
		if not p4 or #p4 == 0 then
			return
		end

		t1.sendGameImpressions(p4)
		u12.current:onSendImpressions(p4)
	end, { t1.sendGameImpressions })

	return React.createElement(ScreenSizeImpressionsDetector, {
		onRequestImpressionsSignal = v10.current,
		parentRef = t1.parentRef,
		filterImpressionFunc = v14,
		onImpressionsDetected = v15,
		impressionsTag = t1.impressionsTag
	})
end
