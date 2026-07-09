local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

require(script.Parent.FeedTypes)

local function useFeedTelemetry(p1, t1: {[any]: any}) -- line: 62
	-- upvalues: React (copy), Signals (copy)
	local active = t1.active
	local v8 = React.useRef(nil)
	local v9 = React.useRef(1)
	local v10 = React.useRef(0)
	local v11 = React.useRef(nil)
	local v12 = React.useRef(t1.telemetry)

	v12.current = t1.telemetry

	local v13 = React.useRef(t1.recommendationSource)

	v13.current = t1.recommendationSource

	local v14 = React.useRef(t1.getAttribution)

	v14.current = t1.getAttribution

	local v15 = React.useRef(t1.onItemBecameActive)

	v15.current = t1.onItemBecameActive

	local v16 = React.useRef(active)

	v16.current = active

	local v17 = React.useCallback(function() -- line: 94
		-- upvalues: v8 (copy), v10 (copy), v11 (copy), v12 (copy), v9 (copy), v13 (copy)
		local current = v8.current

		if current == nil then
			return
		end

		local current2 = v10.current

		if v11.current ~= nil then
			current2 += os.clock() - v11.current
		end

		v8.current = nil
		v11.current = nil
		v10.current = 0

		if current2 <= 0 then
			return
		end

		v12.current.logView(current, {
			durationSeconds = current2,
			itemPosition = v9.current,
			recommendationSource = v13.current
		})
	end, {})

	React.useEffect(function() -- line: 126
		-- upvalues: Signals (copy), p1 (copy), v17 (copy), v14 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v16 (copy), v15 (copy)
		local v20 = Signals.createEffect(function(p2) -- line: 127
			-- upvalues: p1 (copy), v17 (copy), v14 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v16 (copy), v15 (copy)
			local v23 = p1.getCurrentItem(p2)

			v17()

			if v23 == nil then
				return
			end

			local v24 = v14.current(v23)

			if v24 == nil then
				return
			end

			v8.current = v24
			v9.current = p1.getCurrentIndex(false)
			v10.current = 0
			v11.current = if not v16.current then nil else os.clock()

			if v16.current and v15.current then
				v15.current(v23)
			end
		end)

		return function() -- line: 154
			-- upvalues: v20 (copy), v17 (copy)
			v20()
			v17()
		end
	end, {
		p1,
		v17
	})
	React.useEffect(function() -- line: 165
		-- upvalues: active (copy), v8 (copy), v11 (copy), v10 (copy)
		if active then
			if v8.current ~= nil and v11.current == nil then
				v11.current = os.clock()

				return
			end
		elseif v11.current ~= nil then
			local v21 = v10

			v21.current = v21.current + (os.clock() - v11.current)
			v11.current = nil
		end
	end, { active })

	return {
		flushView = v17
	}
end

return useFeedTelemetry
