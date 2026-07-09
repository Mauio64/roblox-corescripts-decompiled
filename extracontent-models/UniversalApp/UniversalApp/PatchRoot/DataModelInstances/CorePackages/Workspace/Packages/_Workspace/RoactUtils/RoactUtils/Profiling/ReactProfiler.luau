local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local ReactProfilerContext = require(script.Parent.ReactProfilerContext)
local isReactProfilingEnabled = require(script.Parent.isReactProfilingEnabled)
local v5 = React.createContext(nil)

local function ReactProfiler(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), v5 (copy), ReactProfilerContext (copy)
	local v8 = React.useRef(0)
	local v9 = React.useRef(0)
	local v10 = React.useContext(v5)
	local v11 = React.useContext(ReactProfilerContext)
	local v12 = React.useCallback(function(s1: string, _: string, n1: number, _: number, n3: number, n4: number) -- line: 30
		-- upvalues: v10 (copy), v8 (copy), v11 (copy)
		if v10 ~= nil then
			local exclusiveRenderDurationRef = v10.exclusiveRenderDurationRef

			exclusiveRenderDurationRef.current = exclusiveRenderDurationRef.current - n1
		end

		local v23 = v8

		v23.current = v23.current + n1

		if v11 ~= nil then
			v11.onRender:fire({
				profilerId = s1,
				startTime = n3,
				commitTime = n4,
				duration = n1,
				exclusiveDuration = v8.current
			})
		end

		v8.current = 0
	end, {})
	local v13 = React.useCallback(function(s3: string, _: string, n5: number, n6: number) -- line: 61
		-- upvalues: v10 (copy), v9 (copy), v11 (copy)
		if v10 ~= nil then
			local exclusiveEffectDurationRef = v10.exclusiveEffectDurationRef

			exclusiveEffectDurationRef.current = exclusiveEffectDurationRef.current - n5
		end

		local v29 = v9

		v29.current = v29.current + n5

		if v11 ~= nil then
			v11.onCommit:fire({
				profilerId = s3,
				commitTime = n6,
				duration = n5,
				exclusiveDuration = v9.current
			})
		end

		v9.current = 0
	end, {})
	local v14 = React.useMemo(function() -- line: 83
		-- upvalues: v8 (copy), v9 (copy)
		return {
			exclusiveRenderDurationRef = v8,
			exclusiveEffectDurationRef = v9
		}
	end, {})

	return React.createElement(React.Profiler, {
		id = t1.id,
		onRender = v12,
		onCommit = v13
	}, React.createElement(v5.Provider, {
		key = "ExclusiveDurationsContext",
		value = v14
	}, t1.children))
end

return function(t2: {[any]: any}) -- line: 104
	-- upvalues: isReactProfilingEnabled (copy), React (copy), ReactProfiler (copy)
	if isReactProfilingEnabled then
		return React.createElement(ReactProfiler, {
			id = t2.id
		}, t2.children)
	end

	return React.createElement(React.Fragment, nil, t2.children)
end
