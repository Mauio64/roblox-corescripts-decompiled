local parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(parent.React)

local ReactProfilerContext = require(script.Parent.ReactProfilerContext)
local isReactProfilingEnabled = require(script.Parent.isReactProfilingEnabled)

local context = React.createContext(nil)

local function ReactProfiler(p)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)

	local v = React.useContext(context)

	local v2 = React.useContext(ReactProfilerContext)

	local onRender = React.useCallback(
		function(profilerId: string, _: string, duration: number, _: number, startTime: number, commitTime: number)
			if v ~= nil then
				v.exclusiveRenderDurationRef.current -= duration
			end

			ref.current += duration

			if v2 ~= nil then
				v2.onRender:fire({
					profilerId = profilerId,
					startTime = startTime,
					commitTime = commitTime,
					duration = duration,
					exclusiveDuration = ref.current
				})
			end

			ref.current = 0
		end,
		{}
	)

	local onCommit = React.useCallback(function(profilerId: string, _: string, duration: number, commitTime: number)
		if v ~= nil then
			v.exclusiveEffectDurationRef.current -= duration
		end

		ref2.current += duration

		if v2 ~= nil then
			v2.onCommit:fire({
				profilerId = profilerId,
				commitTime = commitTime,
				duration = duration,
				exclusiveDuration = ref2.current
			})
		end

		ref2.current = 0
	end, {})

	local v3 = React.useMemo(function()
		return { exclusiveRenderDurationRef = ref, exclusiveEffectDurationRef = ref2 }
	end, {})

	return React.createElement(
		React.Profiler,
		{ id = p.id, onRender = onRender, onCommit = onCommit },
		React.createElement(context.Provider, { key = "ExclusiveDurationsContext", value = v3 }, p.children)
	)
end

return function(p)
	if isReactProfilingEnabled then
		return React.createElement(ReactProfiler, { id = p.id }, p.children)
	end

	return React.createElement(React.Fragment, nil, p.children)
end
