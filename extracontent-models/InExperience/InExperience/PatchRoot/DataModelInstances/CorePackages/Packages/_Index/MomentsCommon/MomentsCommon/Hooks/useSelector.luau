local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)

local useStore = require(script.Parent.useStore)

local function fn(p, p2): boolean
	return p == p2
end

function useSelectorWithStore(current, callback, object)
	local _, v = React.useReducer(function(p: number)
		return p + 1
	end, 0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local state = object:getState()
	local current4 = nil

	local success, result = pcall(function()
		if current == ref2.current and state == ref3.current and not ref.current then
			current4 = ref4.current

			return
		end

		local v2 = current(state)

		if ref4.current == nil or not callback(v2, ref4.current) then
			current4 = v2
		else
			current4 = ref4.current
		end
	end)

	if not success then
		if ref.current then
			result = string.format(
				"%s\nThe error may be correlated with this previous error:\n%s\n\n",
				tostring(result),
				(tostring(ref.current))
			)
		end

		error(result)
	end

	React.useLayoutEffect(function()
		ref2.current = current
		ref3.current = state
		ref4.current = current4
		ref.current = nil
	end)

	React.useLayoutEffect(function()
		local function checkForUpdates(current2) -- 1 equivalent call inferred from this helper
			local success2, result2 = pcall(function(): boolean
				if current2 == ref3.current then
					return false
				end

				assert(ref2.current, "latestSelector")
				local current3 = ref2.current(current2)

				if callback(current3, ref4.current) then
					return false
				end

				ref4.current = current3
				ref3.current = current2
				return true
			end)

			if not success2 then
				result2 = result2 or "Error"

				ref.current = result2
			end

			if result2 then
				v(nil)
			end
		end
		local changedConnection = object.changed:connect(checkForUpdates)

		checkForUpdates(object:getState()) -- inferred equivalent call

		return function()
			changedConnection.disconnect()
		end
	end, { object })

	return current4
end

function useSelector(callback, callback2)
	local v = useStore()

	return (useSelectorWithStore(callback, callback2 or fn, v))
end

return useSelector
