local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local ReactProfilerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Profiling/ReactProfilerContext")
local isReactProfilingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Profiling/isReactProfilingEnabled")

local context = React.createContext(nil)

local function ReactProfiler(p2)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)

	local v5 = React.useContext(context)

	local v6 = React.useContext(ReactProfilerContext)

	local v7 = React.useCallback(function(p3, p4, p5, p6, p7, p8)
		if v5 ~= nil then
			v5.exclusiveRenderDurationRef.current -= p5
		end

		ref.current += p5

		if v6 ~= nil then
			v6.onRender:fire({
				profilerId = p3,
				startTime = p7,
				commitTime = p8,
				duration = p5,
				exclusiveDuration = ref.current
			})
		end

		ref.current = 0
	end, {})

	local v8 = React.useCallback(function(p3, p4, p5, p6)
		if v5 ~= nil then
			v5.exclusiveEffectDurationRef.current -= p5
		end

		ref2.current += p5

		if v6 ~= nil then
			v6.onCommit:fire({
				profilerId = p3,
				commitTime = p6,
				duration = p5,
				exclusiveDuration = ref2.current
			})
		end

		ref2.current = 0
	end, {})

	local v9 = React.useMemo(function()
		return { exclusiveRenderDurationRef = ref, exclusiveEffectDurationRef = ref2 }
	end, {})

	return React.createElement(
		React.Profiler,
		{ id = p2.id, onRender = v7, onCommit = v8 },
		React.createElement(
			context.Provider,
			{ key = "ExclusiveDurationsContext", value = v9 },
			p2.children
		)
	)
end

return function(p2)
	if isReactProfilingEnabled then
		return React.createElement(ReactProfiler, { id = p2.id }, p2.children)
	end

	return React.createElement(React.Fragment, nil, p2.children)
end
