local ReactUtils = script:FindFirstAncestor("ReactUtils")

local React = require(ReactUtils.Parent.React)

local function shallowEqual(current, current2): boolean
	if current == current2 then
		return true
	end

	if typeof(current) ~= typeof(current2) then
		return false
	end

	if typeof(current) ~= "table" then
		return current == current2
	end

	assert(typeof(current2) == "table", "Luau")

	if #current ~= #current2 then
		return false
	end

	for k in current do
		if current[k] ~= current2[k] then
			return false
		end
	end

	for k in current2 do
		if current[k] ~= current2[k] then
			return false
		end
	end

	return true
end

local function useStagnatingState(p, current)
	local ref = React.useRef(current)
	local ref2 = React.useRef(0)

	if not shallowEqual(ref.current, current) then
		ref.current = current
		ref2.current += 1
	end

	local state, setState = React.useState({ tick = ref2.current, value = p })

	local v = React.useCallback(function(callback)
		if typeof(callback) == "function" then
			setState(function(p2)
				local v

				if p2.tick == ref2.current then
					v = p2.value
				else
					v = p
				end

				return { tick = ref2.current, value = callback(v) }
			end)
		else
			setState({ tick = ref2.current, value = callback })
		end
	end, { p })

	local v2 = if state.tick == ref2.current then state.value else p
	return v2, v
end

return useStagnatingState
