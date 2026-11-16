local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)

local function truncatePath(list, p: number)
	local result = {}

	for i = 1, p do
		if list[i] then
			result[i] = list[i]
		end
	end

	return result
end

local function buildPath(list, p: number, p2) -- 2 equivalent calls inferred from this helper
	local path = {}

	for i = 1, p - 1 do
		if list[i] then
			path[i] = list[i]
		end
	end

	path[p] = p2
	return path
end

local function useSubmenuHover()
	local v = useTokens()
	local time_100 = v.Time.Time_100
	local time_300 = v.Time.Time_300

	local state, setState = React.useState({})
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	ref.current = state

	local v2 = React.useCallback(function()
		if ref2.current then
			task.cancel(ref2.current)
			ref2.current = nil
		end

		if ref3.current then
			task.cancel(ref3.current)
			ref3.current = nil
		end
	end, {})

	local openAtDepth = React.useCallback(function(p: number, p2, flag: boolean?)
		v2()

		if ref.current[p] == p2 then
			return
		end

		if flag then
			setState(function(list)
				return buildPath(list, p, p2) -- inferred equivalent call
			end)
		else
			ref2.current = task.delay(time_100, function()
				setState(function(list)
					return buildPath(list, p, p2) -- inferred equivalent call
				end)

				ref2.current = nil
			end)
		end
	end, { v2, time_100 })

	local closeAtDepth = React.useCallback(function(p: number)
		v2()

		if #ref.current < p then
			return
		end

		ref3.current = task.delay(time_300, function()
			setState(function(list)
				if #list < p then
					return list
				end

				local result = {}

				for i = 1, p - 1 do
					if list[i] then
						result[i] = list[i]
					end
				end

				return result
			end)

			ref3.current = nil
		end)
	end, { v2, time_300 })

	local reset = React.useCallback(function()
		v2()
		setState({})
	end, { v2 })

	React.useEffect(function()
		return function()
			if ref2.current then
				task.cancel(ref2.current)
			end

			if ref3.current then
				task.cancel(ref3.current)
			end
		end
	end, {})

	return {
		openPath = state,
		openAtDepth = openAtDepth,
		closeAtDepth = closeAtDepth,
		reset = reset
	}
end

return useSubmenuHover
